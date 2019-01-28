#!/bin/bash
START_ADDRESS="0x0"
MEM_DEPTH="0x8000"

riscv32-unknown-elf-gcc bootstrap.S tcas_mod3.c -O0 -o tcas.out -Ttext $START_ADDRESS -fpic -march=rv32i -mabi=ilp32 -nostartfiles
riscv32-unknown-elf-objdump -D tcas.out > tcas.dump
riscv32-unknown-elf-objcopy -O binary --pad-to=$MEM_DEPTH tcas.out tcas.bin
hexdump -v -e '1/4 "%08X\n"' tcas.bin > tcas.HEX