# EC551 Final Project


## Project Description
This project implements a dual core RISC-V processor. A cache was written but
not integrated before the project deadline. One core is connected to the UART
peripheral. The other core is connected to the frame buffer read by the VGA
controller.

The target platform is the Terasic DE2i-150 FPGA with an Altera Cyclone IV FPGA.

The cache simulates correctly but has not been fully integrated with the
processor. Integrating the cache will be completed in the future.

The hardware folder contains all of the verilog and test benches. Testing was
done in simulation and with the Signal Tap Logic Analyzer provided by Altera.
The quartus directory contains IP provided by Altera (FIFOs and PLLs) as well as
some of the quartus settings files that can be imported into another quartus project.
The software directoty contains our test programs from throughout the semester.
The RISC-V gcc compiler is larger than 100MB (github's size limit) and cannot be
included in this repo.

## Demo Directions

When the FPGA is started, core 0 will print the valid menu options and core 1
will fill the screen with purple. Core 0 will wait until the user enters a menu
option.
Core 1 will wait in an infinite loop for core 0 to set the interrupt trigger,
forcing core 1 to jump to the Mandelbrot function.

### Menu Options:

**
A - Arithmatic Mode  
I - Interrupt Mode  
B - Benchmark Mode  
C - Clear Screen  
M - Render the Mandelbrot set  
**

#### A - Arithmatic Mode
This mode is a simple calculator. Once A mode has been entered, a user many
enter unsigned values 0-9. The supported operations are addition, subtraction,
bitwise and, bitwise xor, and multiplication.

Results should be positive. The values entered are unsigned so negative numbers
will be treated as positive and take a long time to print. Results greater than
9 are supported and will print correctly.

Examples:  
Input  $ 1+1  
Output $ 2

Input  $ 5-2  
Output $ 3

Input  $ 7&5  
Output $ 5

Input  $ 6^6  
Output $ 0

Input  $ 5*5  
Output $ 25

#### I - Interrupt Mode
This mode allows a user to enter a 32 bit address in base16 and jump to that
address in the program memory. After entering your program address and pressing
enter, the processor writes the new PC to the interrupt PC register and set the
interrupt trigger register, forcing a jump to the PC.

The demo software includes a UART loopback function not called from the normal
program. Jumping to 0x00000D79C
will enter the loopback function, where the processor will read serail data and
print it back to the terminal. Pressing escape in the loopback function will
trigger another interupt, stetting the PC to 0x00000000 effectively resetting
core 0.

Examples:
Output $ New PC:  
Input $ 00000000

Output $ New PC:  
Input $ 00000D9C

#### B - Benchmark Mode
This mode computes the fibonacci sequence. Sequence lengths of 0-9 are
supported. Longer sequences can be computed by entering Capital letters towards
the start of the alphabet. This works because conversion from ASCII to integer
is done by subtracting 0x30 from the entereed ASCII code. For example, the ASCII
code for 'A' is 0x41. When A is entered the resulting integer is 0x11
(17 in base 10)

Examples:
Output $ Sequence Len:
Input $ 7
Output $ 1 2 3 5 8 13 21

#### C - Clear Screen
This mode clears the frame buffer, setting the whole screen to purple. This
functionallity is achieved by using the interrupt controller in core 0 to reset
core 1.

#### M - Render the Mandelbrot set
This mode renderes the Mandelbrot set on the screen. Once core 1 has cleared the
screen, it waits in an infinite loop. The M mode uses an interrupt to enter the
Mandelbrot function.

Rendering the fractal takes several minutes because it involves complex numbers.
The processor has no multiply, divide or mod instructions so we have emulated
these with software functions.

Each multiplication involves 32 additions and computing the product of two
complex numbers involves 4 multiplications.

To speed up the rendering of the fractal, the equation used to compute inclusion
in the set is limited to 10 iterations. This produces a fuzzier version of the
mandelbrot set.
