This Directory includes a Test suite for RISCV processors based on a elf type test programs.

## Prerequisites
- In order to generated elf programs you need to have a functioning RISCV compiler. For more details about this look at the RISCV Compiler section.
- To make sure no mixing happens while generating the elf files, add to your .bashrc file the following lines:

        export RISCV_XLEN=32
        export RISCV_LIB=elf
        export RISCV=/opt/riscv32i

- In order to run the RISCV Test suite with elf files you need to have Boost library installed.

## Setup

1) Create a Core.h file, with a class Core containing your processor.
2) Within your Core class specify these ports for accessing the memory:
    * blocking_out<CPtoME_IF> COtoME_port;
    * blocking_in<MEtoCP_IF> MEtoCO_port;
2) Within your Core.h file define these pragmas and modify them acourding to your core structure. These pragmas will be used for accessing your pcReg and registerfile:
    * #define REGFILE(x) RF.reg_file_##x;
    * #define PCREG innerCore.ISA_inst.pcReg
3) Add your Core.h to ESL/Core_include/Core_include.h and uncomment all other cores.


## Running

1) Compile the riscv_elf_test and make sure the binary is in SCAM/bin
2) run the run_all_tests.sh. This includes:
    - Making the elf and asm files for the tests.
    - Running riscv_elf_test with each of these tests.
    - Removing the elf and asm files for the tests.


## Debugging
For each of the tests, the printed message will indicate the success or failure of the test.



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


