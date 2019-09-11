# Complex Sequential Implementation
This folder contains a implementation of the RISC-V "R32VI Base Integer Instruction Set" using multiple submodules. 
The goal of this implementation was to offload tasks to dedicated modules.
To simulate assembly programs, specify the corresponding HEX file in the Memory module and simulate "CPU_tb.vhd".

## Content
- **_Properties_**: Folder containing the Properties for ALU, Control-Path, Decoder, Register-File as well as the ISA.
- **_ALU.vhd_**: Implementation of the ALU.
- **_cpath.vhd_**: Implementation of the Control-Path.
- **_CPU.vhd_**: Top-Level Description of the CPU, connecting ALU, Control-Path, Decoder and Register-File.
- **_CPU_tb.vhd_**: Top-Level Description to test the CPU by running Assembly Programs. Connects CPU and Memory.
- **_Decoder.vhd_**: Implementation of the Decoder.
- **_Memory.vhd_**: Implementation of the Memory.
- **_regs.vhd_**: Implementation of the Register-File.
- **_SCAM_Model_types.vhd_**: Package containing all used-defined data types.
