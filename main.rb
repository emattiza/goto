# goto.rb
#
# Goto Considered Awesome (Ruby Edition)
# -----------------------
# Suffering from a raging head cold, you decide to take some strong
# medication and go to bed. In the restless sleep to follow, you have
# the most vivid dream wherein you decide that you've just had enough
# with structured control flow. All of those `if`, `while` and `for`
# statements? Bah! And exceptions? Or returning from functions?
#
# Imagine if all of those things were simply removed entirely from Ruby.
# Specifically:
#
#    - NO `if`, `unless`, or `case` statements.
#    - NO ternary operators (e.g., cond ? expr1 : expr2)
#    - NO `while`, `until`, `for`, or `.each` loops.
#    - NO `begin`, `rescue`, or `ensure`
#    - NO `return` statement.
#
# You begrudgingly allow yourself to keep the `def` statement and
# lambdas/procs because only a crazy person would also get rid of code organization.
#
# In this world, every function you write must end with an explicit "goto"
# (a Proc or Method object) that indicates what to do next. 
# There is no "return" value. If you forget the goto, everything just stops.

# -----------------------------------------------------------------------------
# Part 1 : Order of Operations
#
# Here are a few primitive math functions coded in the above style.
# In Ruby, we call the 'goto' using .call() or the shorthand .()
puts "=============================="

def add(x, y, goto)
  goto.call(x + y)
  nil
end
def mul(x, y, goto)
  goto.call(x * y)
  nil
end
def sub(x, y, goto)
  goto.call(x - y)
  nil
end
def div(x, y, goto) 
  goto.call(x / y)
  nil
end

# TODO: Show how you would use combinations of these functions and `method(:puts)`
# to calculate and print the result of computing 
# 2*(10-2)/4 + 3.

# Your code here...
# sub(10, 2, -> (x) {
#   mul(2, x, -> (y) {
#     div(y, 4, -> (z) {
#       mul(2, z, -> (w) {
#         add(w, 3, method(:puts))
#       })
#     })
#   })
# })

# -----------------------------------------------------------------------------
# Part 2 : Comparisons and Conditionals
#
# Let's add a few comparison operations into the mix.

def eq(x, y, goto) 
  goto.call(x == y)
  nil
end
def lt(x, y, goto) 
  goto.call(x < y)
  nil
end
def gt(x, y, goto) 
  goto.call(x > y)
  nil
end

# TODO: Implement a function to compute the maximum value of x and y.
# Reminder: You are *NOT* allowed to use `if` or ternary operators.
# Hint: You might need a helper function that takes a boolean and two 
# Procs (one for true, one for false).

# Branch based on cond to true or false goto
def branch(cond, true_goto, false_goto)
  {true => true_goto, false => false_goto}[cond].call()
  nil
end

def maxvalue(x, y, goto)
  gt(x, y, -> (is_greater) {
    branch(is_greater,
      -> { goto.call(x) }, 
      -> { goto.call(y) })
  })
  nil
  # ...
end

# maxvalue(2, 3, method(:puts))    # -> Prints 3
# maxvalue(3, 2, method(:puts))    # -> Prints 3
# Minitest test suite for maxvalue

# -----------------------------------------------------------------------------
# Part 3 : Looping.
#
# TODO: How would you use the `add`, `sub`, and `lt` functions above to compute 
# the result of summing the first N integers (1 + 2 + 3 + ... + N)?

def sum_n(n, acc, goto)
  eq(n, 0, -> (is_zero) {
    branch(is_zero,
      -> { goto.call(acc) }, 
      -> {
      sub(n, 1, -> (n_minus_1) {
        add(n, acc, -> (acc_plus_n) {
          sum_n(n_minus_1, acc_plus_n, goto)
        })
      })
    })
  })
  nil
end

# puts "-------------------------------"
# sum_n(10, 0, method(:puts))      # -> Prints 55
# puts "-------------------------------"
# sum_n(100, 0, method(:puts))     # -> Prints 5050
# puts "-------------------------------"
sum_n(100, 0, method(:puts))     # -> Prints 5050
sum_n(1_000_000, 0, method(:puts))
# -----------------------------------------------------------------------------
# Part 4 : S-Expressions
#
# In Ruby, we'll represent S-expressions using Arrays:
# expr = [:+, [:/, [:*, 2, [:-, 10, 2]], 4], 3]

# TODO: Figure out how to evaluate arbitrary S-expressions using
# only your primitive functions and gotos.

def eval_expression(sexp, goto)
  # Computes the value of sexp and calls goto.call(value) afterwards
  {
    "Integer" => -> (s, g) {g.call(s)},
    "Array" => method(:eval_operator)
  }[sexp.class.name].call(sexp, goto)
  nil
end

def eval_operator(sexp, goto)
  eval_expression(sexp[1], -> (left) {
    eval_expression(sexp[2], -> (right) {
      do_op(sexp[0], left, right, goto)
    })
  })
  nil
end

def do_op(op, left, right, goto) 
  {
    :+ => -> {add(left, right, goto)},
    :- => -> {sub(left, right, goto)},
    :* => -> {mul(left, right, goto)},
    :/ => -> {div(left, right, goto)}
  }[op].call()
  nil
end

# puts "-------------------------------"
# eval_expression(10, method(:puts))    # -> Prints 5)
# puts "-------------------------------"
# eval_expression([:-, 10, 2], method(:puts))    # -> Prints 5)
# puts "-------------------------------"
# eval_expression([:+, [:/, [:*, 2, [:-, 10, 2]], 4], 3], method(:puts))
# puts "-------------------------------"

# -----------------------------------------------------------------------------
# Part 5 : Error handling
#
# In our system we don't have exceptions. 
#
# TODO: Figure out some kind of error handling strategy for converting 
# strings to integers. Keep in mind you can't use `if` to check a return value.

def convert_int(text, success, failure)
  is_digit = !!(text.to_s =~ /\A\d+\z/)
  branch(is_digit,
  -> {success.call(text.to_i)},
  -> {failure.call("ValueError: '#{text}' is not an integer")}
  )
end

# convert_int("123", method(:puts), method(:puts))

# -----------------------------------------------------------------------------
# Part 6 : The Parser
#
# Write a parser that turns a string like "(+ 2 3)" into [:+, 2, 3].
# This is the "Boss Fight" of the activity. 

def parse_sexp(text, goto)
  # The result passed to goto should be [parsed_item, remaining_text]
  # ...
end

# -----------------------------------------------------------------------------
# Part 7 : The REPL
#
# Write a function that reads input, parses it, and evaluates it.
# This should repeat until an empty line is entered.

def repl
  # print "goto> "
  # input = gets.chomp
  # ...
end

# -----------------------------------------------------------------------------
# When you're ready, try running your REPL!
# repl()