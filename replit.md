# Goto Considered Awesome (Ruby Edition)

A Ruby CLI application implementing a Lisp-like interpreter using continuation-passing style (CPS) without traditional control flow.

## Project Overview

This is a coding challenge that demonstrates functional programming concepts in Ruby by removing standard control flow structures (`if`, `while`, `for`, `return`, exception handling) and replacing them with explicit "goto" continuations via Procs.

## Project Structure

- `main.rb` - Main Ruby CLI application with challenge exercises

## Key Constraints

- NO `if`, `unless`, or `case` statements
- NO ternary operators
- NO `while`, `until`, `for`, or `.each` loops
- NO `begin`, `rescue`, or `ensure` blocks
- NO `return` statements
- Functions must call an explicit "goto" (Proc) continuation instead of returning

## Running the App

```bash
ruby main.rb
```

The application provides a REPL (Read-Eval-Print Loop) for testing continuation-passing style functions.

## Technology Stack

- **Language**: Ruby
- **Type**: CLI/REPL Application
