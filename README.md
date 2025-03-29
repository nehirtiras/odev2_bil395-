# odev2_bil395- Nehir Tıraş 231101065

***
## README - Multi-Language Calculator

# Introduction

This project contains a simple calculator implemented in multiple programming languages, including Perl, Rust, Scheme, Prolog, and Ada. The calculator performs basic arithmetic operations such as addition, subtraction, multiplication, and division.

# Requirements

To run the code, you need to have the respective language compilers or interpreters installed on your system:

Perl: Install Perl (sudo apt install perl or brew install perl). 
Rust: Install Rust (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh).
Scheme: Install a Scheme interpreter like MIT-Scheme (sudo apt install mit-scheme).
Prolog: Install SWI-Prolog (sudo apt install swi-prolog). 
Ada: Install GNAT (sudo apt install gnat). 

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

# Implementation

Each language's implementation follows a similar structure:

Accept user input (numbers and operations)

Perform the calculation

Display the result

Error handling for undefined variables and division by zero.
