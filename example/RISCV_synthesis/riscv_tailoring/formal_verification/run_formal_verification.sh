#!/bin/bash

SCRIPT_DIR=$SCAM_HOME/example/RISCV_synthesis/riscv_tailoring/formal_verification
BREG_DIR=$SCAM_HOME/example/RISCV_synthesis/riscv_tailoring/BREG

echo -e "\e[30;48;5;82mTesting SCAM PintVHDL and PrintITL functionality using bespoke RISC-V ESL implementations\e[0m"

if !(cd $SCRIPT_DIR) then
	echo -e "\e[41mError while accesign SCRIPT_DIR\e[0m\n"
	exit
fi
cd $SCRIPT_DIR

# Create working directory to keep root directory clean
if !(mkdir -p work && cd work) then
	echo -e "\e[41mError while creating work dir\e[0m\n"
	exit
fi
cd work

# Delete previous contents in case exists
rm -rf *

mkdir -p RTL
mkdir -p ESL

for pathtofile in  fullriscv $BREG_DIR/test_programs/*.asm $BREG_DIR/analysis_programs/*.asm $BREG_DIR/test_programs_complex/*.asm 
do
	filename=${pathtofile##*/}
	filenamenoext=${filename%.asm}
	if [ $pathtofile = "fullriscv" ]; then
		echo -e "\e[30;48;5;82m\nGenerating full RISC-V ESL\e[0m\n"
		if !(python3 $BREG_DIR/BREG.py -o $SCRIPT_DIR/work/ESL -m $BREG_DIR/modules) then
			echo -e "\e[41mError while generating full RISC-V ESL\e[0m\n"
			exit
		fi
	else
		echo -e "\e[30;48;5;82m\nGenerating bespoke RISC-V ESL for:\e[0m\n"$pathtofile"\n"
		if !(python3 $BREG_DIR/BREG.py -f $pathtofile -o $SCRIPT_DIR/work/ESL -m $BREG_DIR/modules) then
			echo -e "\e[41mError while generating bespoke RISC-V ESL for:\e[0m\n"$pathtofile"\n"
			exit
		fi
	fi
	echo -e "\e[30;48;5;82m\nGenerating RISC-V RTL\e[0m\n"
	if !($SCAM_HOME/bin/SCAM -f $SCRIPT_DIR/work/ESL/modules.h -o $SCRIPT_DIR/work/RTL/ -PrintVHDL -PrintITL --adjustmacros) then
		echo -e "\e[41mError while generating RISC-V RTL for:\e[0m\n"$pathtofile"\n"
		exit
	fi
	if !(python3 $SCRIPT_DIR/tclgen.py -o $SCRIPT_DIR/work -c "set suffix ${filenamenoext}" "set design_name ISA" "source ../verify_design.tcl" "exit") then
		echo -e "\e[41mError while generating TCL script\e[0m\n"
		exit
	fi
	echo -e "\e[30;48;5;82m\nVerifying ISA.h with OneSpin\e[0m\n"
	if !(onespin --gui=no $SCRIPT_DIR/work/bootscript.tcl) then
		echo -e "\e[41mError while verifying design in OneSpin\e[0m\n"
		exit
	fi
	if !(python3 $SCRIPT_DIR/tclgen.py -o $SCRIPT_DIR/work -c "set suffix ${filenamenoext}" "set design_name Regs" "source ../verify_design.tcl" "exit") then
		echo -e "\e[41mError while generating TCL script\e[0m\n"
		exit
	fi
	echo -e "\e[30;48;5;82m\nVerifying Regs.h with OneSpin\e[0m\n"
	if !(onespin --gui=no $SCRIPT_DIR/work/bootscript.tcl) then
		echo -e "\e[41mEror while verifying design in OneSpin\e[0m\n"
		exit
	fi
done

echo -e "\e[30;48;5;82m\nAnalyzing OneSpin *.log files\e[0m\n"
if !(python3 $SCRIPT_DIR/analize_log_files.py -i $SCRIPT_DIR/work/onespin_logs) then
	echo -e "\e[41mError while checking OneSpin *.log files\e[0m\n"
	exit
fi

echo -e "\e[30;48;5;82mSCAM PintVHDL and PrintITL functionality testing finished\e[0m"


