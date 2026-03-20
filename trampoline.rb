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
# Your task is to implement a system that keeps item off the stack until they need to execute
# -----------------------------------------------------------------------------
# The Runner
# -----------------------------------------------------------------------------

def run(step)
end

# -----------------------------------------------------------------------------
# Modified Primitives
# -----------------------------------------------------------------------------

def add(x, y, goto)
end

def mul(x, y, goto)
end

def sub(x, y, goto)
end

def div(x, y, goto)
end

# -----------------------------------------------------------------------------
# Task: Modify your previous functions to work with the runner.
# -----------------------------------------------------------------------------

# 1. Update your branching logic 
def cbranch(cond, true_goto, false_goto)
end

def eq(x, y, goto) 
end

# 2. Update sum_n to be stack-safe.
def sum_n(n, acc, goto)
end

# run(-> {
#   sum_n(10_000_000, 0, method(:puts))
# })

# -----------------------------------------------------------------------------
# Part 9 : The Concurrent Scheduler
# -----------------------------------------------------------------------------
# If you can control running, you can also control stopping
# This would mean you could write a system to interleave multiple tasks to start and stop

# We need a queue of ready steps.
$ready = []

# We need a function to enqueue a step.
def spawn(step)
  $ready << step
  nil
end

# We need a function to drain the queue.
def run_concurrent
end

# -----------------------------------------------------------------------------
# Example Usage:
# -----------------------------------------------------------------------------

# run(-> { sum_n(1000000, 0, method(:puts)) })

# Or for Part 9:
# spawn(-> { sum_n(19, 0, ->(res) { puts "Result 1: #{res}" }) })
# spawn(-> { sum_n(20, 0, ->(res) { puts "Result 2: #{res}" }) })
# run_concurrent()

# spawn(-> { sum_n(21, 0, ->(res) { puts "Result 1: #{res}" }) })
# spawn(-> { sum_n(20, 0, ->(res) { puts "Result 2: #{res}" }) })
# run_concurrent()
# Notice that the order of execution is not guaranteed and can swap depending on
# the order of the queue and length of steps to execute