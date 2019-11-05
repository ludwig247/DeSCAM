# Pipelined Implementation
This folder contains a implementation of the RISC-V "R32VI Base Integer Instruction Set" with pipelining and forwarding. 
The goal of this implementation was implement a 5 stage pipeline with forwarding.
To simulate assembly programs, specify the corresponding HEX file in the Memory module and simulate "CUU_tb.vhd".

## Content
- **_Properties_**: Folder containing the Properties for ALU, Control-Path, Decoder, Register-File as well as the ISA.
- **_ALU.vhd_**: Implementation of the ALU.
- **_Control_unit.vhd_**: Implementation of the Control-Path.
- **_Data_path.vhd_**: Implementation of the data path.
- **_CUU.vhd_**: Top-Level Description of the CUU, connecting ALU, Control-Path, Decoder and Register-File.
- **_CUU_tb.vhd_**: Top-Level Description to test the CUU by running Assembly Programs. Connects CUU and Memory.
- **_Decoder.vhd_**: Implementation of the Decoder.
- **_Memory.vhd_**: Implementation of the Memory.
- **_regs.vhd_**: Implementation of the Register-File.
- **_SCAM_Model_types.vhd_**: Package containing all used-defined data types.
