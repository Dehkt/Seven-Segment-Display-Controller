# Seven-Segment-Display-Controller
This project implements a 4-digit 7-segment display controller on the Basys3 FPGA. 
The design uses 16 switches as input, with 4 switches representing each BCD (Binary-Coded Decimal) digit. 
The outputs are displayed on a 4-digit 7-segment display.
Truth tables and logic minimization with K-maps for Seven Segment BCD has already been done.

## Problem Description
The Basys3 FPGA features a 4-digit 7-segment display where:
- All digits share the same 7 segment lines (a,b,c,d,e,f,g).
- Each digit has a separate anode enable line.

![image](https://github.com/user-attachments/assets/fa53928e-494b-441e-b9e3-30f2fe40dbb6)
  
Due to this hardware constraint, we cannot simultaneously drive all four displays with different values.
Activating more than one would force all displays to show the same value because of shared seven segment LED data lines.

## Solution: Multiplexing and Clock Division
To overcome this constraint, we can use a multiplexer and clock division. The multiplexer cycles through each of the displays rapidly
and constantly updates each of their value based on the user's input (switches). The new clock signal is the speed at which the multiplexer
is updating the display value. I chose a slower clock speed as to avoid possible timing violations, an extremely fast speed is not required.

## Why does it work?
Because of the rate at which the displays are being cycled through, we perceive that all four digits are being continously lit even 
though only one of these digits are lit at any given instant in time.

We can now use this design for a variety of digital design applications like counters, FSMs, ALUs, displays for embedded systems and hardware, etc.

![image](https://github.com/user-attachments/assets/a253a8ff-b8c6-411d-b874-01e50091c6bf)
