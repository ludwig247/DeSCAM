# Simple Sequential Implementation
This folder contains a highly combinatorial implementation of the RISC-V "R32VI Base Integer Instruction Set". 
The goal of this implementation was to keep refining efforts as little as possible.
To simulate assembly programs, specify the corresponding HEX file in the Memory module and simulate "toplevel.vhd".

## Content
 - **_Properties_**: Folder containing the refined properties for the implementation.
 - **_types.vhd_**: Package with all used data types.
 - **_ISA.vhd_**: Main module for fetching, decoding and executing instructions.
 - **_regs.vhd_**: 32-bit register file.
 - **_CPU.vhd_**: Toplevel file, combining the ISA and the register file.
 - **_Memory.vhd_**: Memory module, holding both the program and process data.
 - **_CPU_tb.vhd_**: Toplevel file, combining the core with the memory.
