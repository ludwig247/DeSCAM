#!/bin/bash

BREG_DIR=${SCAM_HOME}/example/RISCV_synthesis/riscv_tailoring/BREG

echo -e "\e[30;48;5;82mTesting bespoke RISC-V ESL generator (BREG)\n\e[0m"

if !(cd $BREG_DIR) then
	echo -e "\e[41mError while accesign BREG_DIR\e[0m\n"
	exit
fi
cd $BREG_DIR

# Create working directory to keep root directory clean
if !(mkdir -p work && cd work) then
	echo -e "\e[41mError while creating work dir\e[0m\n"
	exit
fi
cd work

# Delete previous contents in case exists
#rm -rf *

export SYSTEMC_DISABLE_COPYRIGHT_MESSAGE=1

echo -e "\e[30;48;5;82m\nGenerating full RISC-V ESL\e[0m\n"
if !(python3 $BREG_DIR/BREG.py -o $BREG_DIR/work/generated -nosyscall -m $BREG_DIR/modules) then
	echo -e "\e[41mError while generating full RISC-V ESL\e[0m\n"
	exit
fi
echo -e "\e[30;48;5;82mBuilding full RISC-V ESL\n\e[0m"
if !(cmake3 $BREG_DIR/ &&
	make clean &&
	make RISCV_elf_test  &&
	echo -e "\e[30;48;5;82mBuilding complete\e[0m") then
	echo -e "\e[41mError while building full RISC-V ESL\e[0m\n"
	exit
fi
for asmfile in $BREG_DIR/test_programs/*.asm #$BREG_DIR/test_programs_complex/*.asm
do
	elffile=`echo $asmfile | sed s/".asm"/".elf"/g`
	echo -e "\e[30;48;5;82mRunning full RISC-V ESL test for:\e[0m\n"$elffile"\n"
	if !($BREG_DIR/work/bin/RISCV_elf_test $elffile &&
		echo -e "\e[30;48;5;82mTest passed\e[0m") then
		echo -e "\e[41mTest failed for:\e[0m\n"$elffile"\n"
		exit
	fi
done

for asmfile in $BREG_DIR/test_programs/*.asm #$BREG_DIR/test_programs_complex/*.asm
do
	echo -e "\e[30;48;5;82m\nGenerating bespoke RISC-V ESL for:\e[0m\n"$asmfile"\n"
	if !(python3 $BREG_DIR/BREG.py -f $asmfile -o $BREG_DIR/work/generated -m $BREG_DIR/modules) then
		echo -e "\e[41mError while generating bespoke RISC-V ESL for:\e[0m\n"$asmfile"\n"
		exit
	fi
	echo -e "\e[30;48;5;82mBuilding bespoke RISC-V ESL\n\e[0m"
	if !(cmake3 $BREG_DIR/ &&
		make clean &&
		make RISCV_elf_test  &&
		echo -e "\e[30;48;5;82mBuilding complete\e[0m") then
 		echo -e "\e[41mError while building bespoke RISC-V ESL for:\e[0m\n"$asmfile"\n"
		exit
	fi

	elffile=`echo $asmfile | sed s/".asm"/".elf"/g`
	echo -e "\e[30;48;5;82mRunning bespoke RISC-V ESL test for:\e[0m\n"$elffile"\n"
	if !($BREG_DIR/work/bin/RISCV_elf_test $elffile &&
		echo -e "\e[30;48;5;82mTest passed\e[0m") then
		echo -e "\e[41mTest failed for:\e[0m\n"$elffile"\n"
		exit
	fi
done

echo -e "\e[30;48;5;82mFinished testing of bespoke RISC-V ESL generator (BREG)\e[0m"
