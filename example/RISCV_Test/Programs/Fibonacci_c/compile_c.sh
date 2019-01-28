#!/bin/bash
START_ADDRESS="0x0"
MEM_DEPTH="0x10000"

riscv32-unknown-elf-gcc bootstrap.S main.cpp -O0 -o main.out -Ttext $START_ADDRESS -fpic -march=rv32i -mabi=ilp32 -nostartfiles
riscv32-unknown-elf-objdump -D main.out > main.asm
riscv32-unknown-elf-objcopy -O binary --pad-to=$MEM_DEPTH main.out main.bin
hexdump -v -e '1/4 "%08X\n"' main.bin > main.HEX
cp main.HEX ../main.hex

