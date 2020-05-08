#!/bin/bash
riscv64-unknown-elf-gcc -static -fpic -fvisibility=hidden -nostdlib -nostartfiles -std=gnu99 -O0 dummy.S
riscv64-unknown-elf-objcopy -O binary a.out file.bin
