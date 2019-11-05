This README gives an overview of the structure of the Platform-Level Interrupt Controller (PLIC) and how to attach an interrupt source to it. For further reading refer
to the **riscv-privileged-v1.10** document.

![](../../Documentation/PLIC.png)


### Global Interrupt Sources:

*"Global interrupt sources can take many forms, including level-triggered, edge-triggered, and message-signalled.
Some sources might queue up a number of interrupt requests. All global interrupt sources are converted to a common interrupt request format for the PLIC."*

For every form of interrupt source the designer should implement a compatible Gateway module that will translate the interrupt sensitivity to a SystemC-PPA format
**master_out<bool>** in order to link it properly with the PLIC_Core.

*PLIC_Gateway.h* file has implementation of two types of interrupt sources formats available.
-   Gateway_PPA: transfer an interrupt from source with **master_out<bool> IntSig** to the PLIC_Core.
-   Gateway: transfer an interrupt from source with **sc_out<sc_logic> IntSig** to the PLIC_Core.




### PLIC_Gateway:

This module acts as a *TOP* for the used gateways and their attached interrupt sources.

When a new interrupt source needs to be added, the designer should include in this module the interrupt source and it's appropriate gateway.

**NOTE:** At the moment the PLIC doesn't offer the possibility to connect an interrupt source that is situated outside the PLIC bounds because of lack of interrupt
sources.



### PLIC_Core:

This module handles the processing and prioritization of interrupts.

When a new interrupt source is added, the designer should include in this module the required signals (slave_in<bool> fromGateway_Intx, ....) and added the processing
part of this interrupt to the main thread, keeping in mind the respectful order of processing the interrupts.




# Example:

### Prerequisites
- In order to generated elf or hex programs for an example you need to have a functioning RISCV compiler.
For more details about this look at the RISCV Compiler section.
- To make sure no mixing happens while generating the programs, add to your .bashrc file the following lines:

        export RISCV_XLEN=32
        export RISCV_LIB=elf
        export RISCV=/opt/riscv32i

- In order to run elf programs on this processor you need to have Boost library installed.

### Externals:

You can find this example at ($SCAM/example/RISCV_interrupts/Examples/).

This example has been constructed to test the functionality of the interrupt handling and interrupt triggering for external interrupt sources connected to PLIC.
Only external, timer and software interrupt has been enabled in this example.

*main.c* shows how to register an interrupt handler for each external interrupt source, with a maximum number of external interrupt source of 32.
The external interrupt is activated when a value larger than zeor is given to the *PLIC_Interrupt_Enables* register.
Each interrupt handler should include an assignment to the matching interrupt pending address as an indicator of interrupt completion in order to allow its gateway to
forward further interrupt requests.

        *(PLIC_Pending_ADDR_REGISTER + irq_id - 1) = 0;



## RISCV Compiler
You can download RISCV compiler from this link:
    https://github.com/cliffordwolf/picorv32#building-a-pure-rv32i-toolchain

The default settings in the riscv-tools build scripts will build a compiler,
assembler and linker that can target any RISC-V ISA, but the libraries are built
for RV32G and RV64G targets. Follow the instructions below to build a complete toolchain
(including libraries) that target a pure RV32I CPU.

- Ubuntu packages needed:

        sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
        gperf libtool patchutils bc zlib1g-dev libexpat-dev git


The following commands will build the RISC-V GNU toolchain and libraries for a pure RV32I target,
and install it in /opt/riscv32i:

    sudo mkdir /opt/riscv32i
    sudo chown $USER /opt/riscv32i

    git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
    cd riscv-gnu-toolchain-rv32i
    git checkout 1b80cbe
    git submodule update --init --recursive

    ./configure --prefix=/opt/riscv32i --with-arch=rv32i --with-abi=ilp32
    make -j$(nproc)

**NOTE**: don't forget to add /opt/riscv32i/bin to your PATH variable in your .bashrc file

The commands will all be named using the prefix riscv32-unknown-elf-, which makes it
easy to install them side-by-side with the regular riscv-tools (those are using the name
prefix riscv64-unknown-elf- by default).
