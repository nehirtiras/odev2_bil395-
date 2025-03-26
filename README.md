# odev2_bil395-

***
# ADA Calculator

## Description
This is a simple calculator implemented in Ada that supports basic arithmetic operations (+, -, *, /) and variable assignments. Users can input expressions, and the calculator will evaluate them accordingly. The program supports the following features:

- Addition, subtraction, multiplication, and division.
- Variable assignments (e.g., `x = 5 + 3`).
- Error handling for undefined variables and division by zero.
- Interactive command-line interface.

## Requirements
To compile and run this Ada program on **Ubuntu**, you need:

- GNAT (Ada compiler) installed on your system. If you don’t have GNAT, install it using:
  
  ```sh
  sudo apt update
  sudo apt install gnat
  ```

## Compilation
To compile the program, use the following command:

```sh
 gnatmake Calculator.adb
```

This will generate an executable named `calculator`.

## Running the Program
After successful compilation, run the calculator using:

```sh
 ./calculator
```

## Usage Instructions
- The calculator runs in an interactive mode.
- Enter expressions like `5 + 3`, `10 / 2`, `x = 4 * 3`, etc.
- Type `exit` to quit the program.

### Example Usage
```
ADA Calculator (type 'exit' to quit)
Supports: + - * /, variables (x = 5 + 3)

> x = 10
Result: 10.00

> y = x + 5
Result: 15.00

> y / 3
Result: 5.00

> exit
```

## Notes
- Ensure input expressions are correctly formatted.
- Variables are case-sensitive.
- Error messages will be displayed for invalid expressions.

***

Perl Calculator - README
Overview
This is a simple command-line calculator written in Perl that supports basic arithmetic operations and variable assignments. The calculator evaluates mathematical expressions following standard operator precedence and allows users to store values in variables for later use.

Features
Basic arithmetic operations: +, -, *, /

Parentheses for expression grouping

Variable assignment and usage (e.g., x = 5 + 3)

Error handling for invalid expressions and undefined variables

Help command (help or ?)

Exit command (exit or quit)

Implementation Details
Key Components:
Variable Storage: Uses a hash (%variables) to store variable names and their values

Expression Evaluation:

Handles parentheses by recursively evaluating nested expressions

Processes multiplication and division before addition and subtraction

Validates input characters before evaluation

Error Handling:

Catches invalid characters, undefined variables, and division by zero

Uses eval blocks to gracefully handle runtime errors

Evaluation Process:
Input sanitization (checks for invalid characters)

Variable substitution (replaces variables with their stored values)

Parentheses evaluation (innermost first)

Multiplication and division (left to right)

Addition and subtraction (left to right)

How to Run
Prerequisites
Perl 5 installed on your system

Running the Calculator
Save the code to a file (e.g., calculator.pl)

Make the file executable if desired: chmod +x calculator.pl

Run the program: perl calculator.pl

Usage Examples
Copy
> 5 + 3 * 2
= 11

> x = 10 / 2
= 5

> y = x + 3
= 8

> (x + y) * 2
= 26

> help
***Perl Calculator***

> exit
Error Messages
The calculator provides descriptive error messages for:

Invalid characters in input

Undefined variables

Division by zero

Syntax errors in expressions
