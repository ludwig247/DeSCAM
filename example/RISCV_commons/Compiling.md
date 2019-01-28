# Directory: RISCV_MS

## Compiling with RISCV32 

- First you need to have this bootstrap.S file in your directory
     ```
            .globl _start
            .globl main

            _start:
            jal main

            _end:
            	j _end
      ```
    
- To generate assembly, binary and hex from main.c using the riscv32 compiler:
     ```
        riscv32-unknown-elf-gcc bootstrap.S main.c -O0 -o main.out -Ttext 0x0 -fpic -march=rv32i -mabi=ilp32 -nostartfiles
        riscv32-unknown-elf-objdump -D main.out > main.dump
        riscv32-unknown-elf-objcopy -O binary --pad-to=0x8000 main.out main.bin
        hexdump -v -e '1/4 "%08X\n"' main.bin > main.hex
     ```
- 	The core expects instructions in hex.
	An example assembly file is found in /RISCV/Programs/fibonacci.s
	An example file with hex instructions is found in /RISCV/Programs/fibonacci.hex
	
	
## Installing  RISCV32 

- Download: https://github.com/cliffordwolf/picorv32#building-a-pure-rv32i-toolchain

- The default settings in the riscv-tools build scripts will build a compiler,
  assembler and linker that can target any RISC-V ISA, but the libraries are built
    for RV32G and RV64G targets. Follow the instructions below to build a complete toolchain
    (including libraries) that target a pure RV32I CPU.

- The following commands will build the RISC-V GNU toolchain and libraries for a pure RV32I target,
 and install it in /opt/riscv32i:

   Ubuntu packages needed:
    ```
    sudo apt-get install autoconf automake autotools-dev curl libmpc-dev \
	libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo \
	gperf libtool patchutils bc zlib1g-dev libexpat-dev git
	

    sudo mkdir /opt/riscv32i
    sudo chown $USER /opt/riscv32i

    git clone https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
    cd riscv-gnu-toolchain-rv32i
    git checkout 1b80cbe
    git submodule update --init --recursive

    ./configure --prefix=/opt/riscv32i --with-arch=rv32i --with-abi=ilp32
    make -j$(nproc)
    ```

- Note: don't forget to add /opt/riscv32i/bin to your PATH variable in your .bashrc file

- The commands will all be named using the prefix riscv32-unknown-elf-, which makes it
easy to install them side-by-side with the regular riscv-tools (those are using the name
prefix riscv64-unknown-elf- by default). 

	