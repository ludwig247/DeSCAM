#!/bin/bash
START_ADDRESS="0x0"
MEM_DEPTH="0xFFFF"

WORK_DIR=$SCAM_HOME/example/RISCV_synthesis/synthesis_flow/analysis_programs

shopt -s nullglob # enable (prevents execution if no matching files are found)
for filepath in $WORK_DIR/*.cpp
do
	filename=${filepath##*/}
	filenamenoext=${filename%.cpp}
	filedir=${filepath%/*}
	if !(riscv32-unknown-elf-gcc $filedir/bootstrap.S "$filepath" -o "$WORK_DIR/compiled_files/${filenamenoext}.elf" -Ttext $START_ADDRESS -O0 -march=rv32i -mabi=ilp32 -nostartfiles &&
		riscv32-unknown-elf-objdump -S "$WORK_DIR/compiled_files/${filenamenoext}.elf" > "$WORK_DIR/compiled_files/${filenamenoext}.asm" &&
		riscv32-unknown-elf-objcopy -O binary --pad-to=$MEM_DEPTH "$WORK_DIR/compiled_files/${filenamenoext}.elf" "$WORK_DIR/compiled_files/${filenamenoext}.bin" &&
		hexdump -v -e '1/4 "%08X" "\n"' "$WORK_DIR/compiled_files/${filenamenoext}.bin" > "$WORK_DIR/compiled_files/${filenamenoext}.hex" &&
		rm $WORK_DIR/compiled_files/${filenamenoext}.bin) then
 		echo -e "\e[41mError while compiling:\e[0m\n"$filename"\n"
		break
	fi
	printf "${filenamenoext} .elf, .asm and .hex created.\n"
done

for dirpath in $WORK_DIR/*
do
    if [ -d "$dirpath" ]; then
		dirname=${dirpath##*/}
		for filepath in $dirpath/*.cpp
		do
			filename=${filepath##*/}
			filenamenoext=${filename%.cpp}
			filedir=${filepath%/*}
			if !(riscv32-unknown-elf-gcc $filedir/bootstrap.S "$filepath" -o "$WORK_DIR/compiled_files/${filenamenoext}.elf" -Ttext $START_ADDRESS -O0 -march=rv32i -mabi=ilp32 -nostartfiles &&
				riscv32-unknown-elf-objdump -S "$WORK_DIR/compiled_files/${filenamenoext}.elf" > "$WORK_DIR/compiled_files/${filenamenoext}.asm" &&
				riscv32-unknown-elf-objcopy -O binary --pad-to=$MEM_DEPTH "$WORK_DIR/compiled_files/${filenamenoext}.elf" "$WORK_DIR/compiled_files/${filenamenoext}.bin" &&
				hexdump -v -e '1/4 "%08X" "\n"' "$WORK_DIR/compiled_files/${filenamenoext}.bin" > "$WORK_DIR/compiled_files/${filenamenoext}.hex" &&
				rm $WORK_DIR/compiled_files/${filenamenoext}.bin) then
		 		echo -e "\e[41mError while compiling:\e[0m\n"$filename"\n"
				break
			fi
			printf "${filenamenoext} .elf, .asm and .hex created.\n"
		done
    fi
done
shopt -u nullglob # disable

echo -e "\e[30;48;5;82mCompilation of programs finished\n\e[0m"
