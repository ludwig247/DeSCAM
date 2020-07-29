 #Simple Sequential Implementation
 This folder contains a highly combinatorial implementation of the RISC-V "R32VI Base Integer Instruction Set". 
 The goal of this implementation was to keep refining efforts as little as possible.
 The register file was implemented as an array.

## Content
- **globalTypes.sv**: Package with all data types used in the RTL and in the Properties
- **ISA_new_types.sv**: Package with all data types and functions used only in the RTL
- **ISA_new_refactored.sv**: SystemVerilog implementation of a sequential RISCV ISA with the register file implemented as an array
- **Properties**: Folder containing the properties used to verify the design