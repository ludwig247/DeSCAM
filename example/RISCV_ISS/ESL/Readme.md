#ESL Implementation of a RISCV ISA
This folder contains the main components for the ESL implementation of a RISCV ISA.
The register file is implemented as an array

#Content
- **_Core_ISS.h_** File which integrates the ISS and the register file to form the CPU
- **_CPU_Interfaces.h_** File with some type definitions used in the design
- **_ISS.h_** File with the design of a instruction set simulator of a RISCV ISA. It simulates the fetching, decoding and execution of instructions
- **_regs_ISS.h_** File with the implementation of the register file as an array