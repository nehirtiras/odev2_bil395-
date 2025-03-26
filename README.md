# odev2_bil395-

***
## README - Multi-Language Calculator

# Introduction

This project contains a simple calculator implemented in multiple programming languages, including Perl, Rust, Scheme, Prolog, and Ada. The calculator performs basic arithmetic operations such as addition, subtraction, multiplication, and division.

# Requirements

To run the code, you need to have the respective language compilers or interpreters installed on your system:

Perl: Install Perl (sudo apt install perl or brew install perl). Perl is a high-level, general-purpose programming language known for its text-processing capabilities.

Rust: Install Rust (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh). Rust is a systems programming language focused on safety and performance.

Scheme: Install a Scheme interpreter like MIT-Scheme (sudo apt install mit-scheme). Scheme is a minimalist dialect of Lisp, used for functional programming.

Prolog: Install SWI-Prolog (sudo apt install swi-prolog). Prolog is a logic programming language commonly used in AI and symbolic reasoning.

Ada: Install GNAT (sudo apt install gnat). Ada is a statically typed language designed for safety-critical applications.

# Implementation

Each language's implementation follows a similar structure:

Accept user input (numbers and operations)

Perform the calculation

Display the result

Error handling for undefined variables and division by zero.

# How to Run

Perl

perl calculator.pl

Rust

cargo run --release

Scheme

Run the Scheme interpreter and load the file:

mit-scheme --load calculator.scm

Prolog

Start Prolog and load the calculator file:

swipl -s calculator.pl

Ada

Compile and run:

gnatmake calculator.adb
./calculator
