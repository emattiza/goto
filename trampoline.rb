# trampoline.rb
# -----------------------------------------------------------------------------
# Part 8 : The Trampoline
# -----------------------------------------------------------------------------
#
# As an astute observer, you might be looking at all of this "goto" business
# thinking "wait, isn't this going to blow Ruby's recursion limit?" 
#
# Yes. Every time you call a 'goto', you add a frame to the stack.
# If you try to sum 1,000,000 integers, Ruby will throw a SystemStackError.
#
# The Fix: Instead of calling the goto directly, we RETURN a lambda.
# The function "pops" off the stack, and a runner calls the next step.

# -----------------------------------------------------------------------------
# The Runner (The Trampoline)
# -----------------------------------------------------------------------------

def run(step)
  # Keep calling the step as long as it returns another Proc/Lambda
  while step.respond_to?(:call)
    step = step.call
  end
end

# -----------------------------------------------------------------------------
# Modified Primitives
# -----------------------------------------------------------------------------
# Note: These now return a lambda instead of just calling the goto.

def add(x, y, goto)
  -> { goto.call(x + y) }
end

def mul(x, y, goto)
  -> { goto.call(x * y) }
end

def sub(x, y, goto)
  -> { goto.call(x - y) }
end

def div(x, y, goto)
  -> { goto.call(x / y) }
end

# -----------------------------------------------------------------------------
# Task: Modify your previous functions to work with the trampoline.
# -----------------------------------------------------------------------------

# 1. Update your branching logic to return a lambda.
def cbranch(cond, true_goto, false_goto)
  # ... (return a lambda that picks the right goto)
  -> {{true => true_goto, false => false_goto}[cond].call()}
end

def eq(x, y, goto) 
  -> { goto.call(x == y) }
end

# 2. Update sum_n to be stack-safe.
def sum_n(n, acc, goto)
  # Hint: Every internal call (eq, sub, add, sum_n) 
  # must be wrapped or returned as a lambda.
  # ...
  -> { eq(n, 0, -> (is_zero) {
      cbranch(is_zero,
        -> { goto.call(acc) }, 
        -> {
        sub(n, 1, -> (n_minus_1) {
          add(n, acc, -> (acc_plus_n) {
            sum_n(n_minus_1, acc_plus_n, goto)
          })
        })
      })
    })
  }    
end

# run(-> {
#   sum_n(10_000_000, 0, method(:puts))
# })

# -----------------------------------------------------------------------------
# Part 9 : The Concurrent Scheduler
# -----------------------------------------------------------------------------

$ready = []

def spawn(step)
  $ready << step
  nil
end

def run_concurrent
  while !$ready.empty?
    step_proc = $ready.shift

    # Execute one "pulse"
    result = step_proc.call

    # If it returns a continuation, put it back in the queue
    if result.respond_to?(:call)
      $ready << result
    end
  end
end

# -----------------------------------------------------------------------------
# Example Usage:
# -----------------------------------------------------------------------------

# run(-> { sum_n(1000000, 0, method(:puts)) })

# Or for Part 9:
spawn(-> { sum_n(19, 0, ->(res) { puts "Result 1: #{res}" }) })
spawn(-> { sum_n(20, 0, ->(res) { puts "Result 2: #{res}" }) })
run_concurrent()