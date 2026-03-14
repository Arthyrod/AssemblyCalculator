x86 Assembly Calculator

A floating-point calculator written in x86 Assembly using the SASM IDE. This project serves as a practical application of x86 architecture concepts and data structure management.
How It Works

The program processes an input string containing two floating-point values and a mathematical operator (e.g., 4.5+7.75).

    Parsing: The program splits the input string into two distinct numerical values and identifies the operation.

    Calculation: It performs the floating-point arithmetic.

    Output: The result is printed to the terminal with a precision of up to two decimal places.

Roadmap & Upcoming Updates

To improve the robustness and portability of the project, the following updates are planned:

    Bug Fixes: Resolve precision issues during division operations and fix display errors when handling negative results.

    Precision Enhancements: Increase the number of supported decimal places for both the input operands and the final output.

    System Optimization: Replace SASM-specific macros with standard Linux System Calls (syscalls) for data input and output (I/O) to make the code more portable.
