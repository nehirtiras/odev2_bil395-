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

