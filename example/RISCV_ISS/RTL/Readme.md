# Simple Sequential Implementation
This folder contains a highly combinatorial implementation of the RISC-V "R32VI Base Integer Instruction Set". 
The goal of this implementation was to keep refining efforts as little as possible.
To simulate assembly programs, specify the corresponding HEX file in the Memory module and simulate "CPU_tb.vhd".

## Content
 - **_Properties_**: Folder containing the refined properties for the RTL implementation.
 - **_globalTypes.sv_**: Package with all the used data types in the RTL and the Properties.
 - **_ISS.sv_**: Main module for fetching, decoding and executing instructions.
 - **_regs_ISS.sv_**: 32-bit register file implemented as an array.
 - **_CPU.sv_**: Toplevel file, combining the ISS and the register file.
 - **_Memory.sv_**: Memory module, holding both the program and process data.
 - **_CPU_tb.sv_**: Toplevel file, combining the CPU with the memory.
 - **_Load_Properties_** TCL file which automatically loads the design and the properties and checks all properties.

