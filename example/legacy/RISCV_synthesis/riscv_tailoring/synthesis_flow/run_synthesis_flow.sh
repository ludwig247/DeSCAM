#!/bin/bash

export RISCV_SYNTH_DIR=$SCAM_HOME/example/RISCV_synthesis
export SCRIPT_DIR=$RISCV_SYNTH_DIR/riscv_tailoring/synthesis_flow
BREG_DIR=$SCAM_HOME/example/RISCV_synthesis/riscv_tailoring/BREG

echo -e "\e[30;48;5;82mRunning RISC-V top-down synthesis flow\e[0m"

# Setting up working directory ##########################################
if !(cd $SCRIPT_DIR) then
	echo -e "\e[41mError!\e[0m"
	exit 1
fi
cd $SCRIPT_DIR

# Create working directory to keep root directory clean
if !(mkdir -p work && cd work) then
	echo -e "\e[41mError!\e[0m"
	exit 1
fi
cd work

# Delete previous contents in case exists
#rm -rf *

#########################################################################

function power_estimate()
{
	echo -e "\e[30;48;5;82mCopying simulation files and the program to be simulated\e[0m"
	mkdir -p simulation_files/
	rm -rf simulation_files/*
	if !(cp $SCRIPT_DIR/work/results/netlist/gscl45nm.v $SCRIPT_DIR/work/simulation_files &&
		cp $SCRIPT_DIR/work/results/netlist/${netlistname}.v $SCRIPT_DIR/work/simulation_files &&
		cp $progpath $SCRIPT_DIR/work/program.hex) then 
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi

	if !(python3 $SCRIPT_DIR/tclgen.py -o $SCRIPT_DIR/work -c \
		"open_saif ../results/activity/${saifname}.saif" \
		"log_saif [get_object /Core_tb/Core_unwrapper_inst/Core_wrapper_inst/*]" \
		"run 100000000ns" \
		"close_saif" \
		"exit" \
		) then
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi

	echo -e "\e[30;48;5;82mPerforming simulation to get activity file using Vivado\e[0m"
	if !(source $SCRIPT_DIR/vivado_simulate.sh) then
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi

	echo -e "\e[30;48;5;82mEstimating power using *.saif file\e[0m"
	if !(dc_shell -f $SCRIPT_DIR/dc_power_estimate.tcl) then
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi
}

############################################################################################################
# Generate ESL implementation
for progpath in generatedfull generatedlight $SCRIPT_DIR/analysis_programs/compiled_files/*.asm
do
	prognamefull=${progpath##*/}
	export progname=${prognamefull%.asm}
	if [ $progpath = "generatedfull" ]; then
		echo -e "\e[30;48;5;82mGenerating full RISC-V ESL\e[0m"
		if !(python3 $BREG_DIR/BREG.py -o $SCRIPT_DIR/work/results/ESL/${progname} -m $BREG_DIR/modules -ortl $SCRIPT_DIR/work/results/RTL/${progname}) then
			echo -e "\e[41mError!\e[0m"
			exit 1
		fi
	elif [ $progpath = "generatedlight" ]; then
		echo -e "\e[30;48;5;82mGenerating light RISC-V ESL\e[0m"
		if !(python3 $BREG_DIR/BREG.py -o $SCRIPT_DIR/work/results/ESL/${progname} -m $BREG_DIR/modules -nocsr -ortl $SCRIPT_DIR/work/results/RTL/${progname}) then
			echo -e "\e[41mError!\e[0m"
			exit 1
		fi
	else
		echo -e "\e[30;48;5;82mGenerating bespoke RISC-V ESL for:\e[0m"$progpath
		if !(python3 $BREG_DIR/BREG.py -f $progpath -o $SCRIPT_DIR/work/results/ESL/${progname} -m $BREG_DIR/modules -ortl $SCRIPT_DIR/work/results/RTL/${progname}) then
			echo -e "\e[41mError!\e[0m"
			exit 1
		fi
	fi
done

############################################################################################################
# Generate RTL implementation
for progpath in generatedfull generatedlight $SCRIPT_DIR/analysis_programs/compiled_files/*.asm
do
	prognamefull=${progpath##*/}
	progname=${prognamefull%.asm}
	echo -e "\e[30;48;5;82mGenerating RISC-V RTL\e[0m"
	if !($SCAM_HOME/bin/SCAM -f $SCRIPT_DIR/work/results/ESL/${progname}/modules.h -o $SCRIPT_DIR/work/ -PrintVHDL &&
		mkdir -p $SCRIPT_DIR/work/results/RTL/${progname} &&
		cp $SCRIPT_DIR/work/PrintVHDL/* $SCRIPT_DIR/work/results/RTL/${progname}/ &&
		cp $RISCV_SYNTH_DIR/RTL/wrappers/remove_records_enums_boolean_unsigned/Core_wrapper.vhd $SCRIPT_DIR/work/results/RTL/${progname}/) then
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi
done

############################################################################################################
# Copy other manual implementations of RISC-V
manualdesignlist=""
for dirpath in $SCRIPT_DIR/handwritten_designs/*
do
    if [ -d "$dirpath" ]; then
		dirname=${dirpath##*/}
		if !(mkdir -p $SCRIPT_DIR/work/results/RTL/$dirname &&
			rm -rf $SCRIPT_DIR/work/results/RTL/$dirname/*
			cp -r $SCRIPT_DIR/handwritten_designs/$dirname/* $SCRIPT_DIR/work/results/RTL/$dirname/) then 
			echo -e "\e[41mError!\e[0m"
			exit 1
		fi
		manualdesignlist+="$dirname "
    fi
done

############################################################################################################
# Elaborate RTL implementation with Design Compiler
for progpath in $manualdesignlist generatedfull generatedlight $SCRIPT_DIR/analysis_programs/compiled_files/*.asm
do
	prognamefull=${progpath##*/}
	export progname=${prognamefull%.asm}

	rm -rf dc_work
	echo -e "\e[30;48;5;82mElaborating RISC-V RTL using Design Compiler\e[0m"
	if !(dc_shell -f $SCRIPT_DIR/dc_elaborate.tcl) then
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi
done

for compname in basic gclock
do
	############################################################################################################
	# Synthesize Gate-Level netlist with Design Compiler
	for progpath in $manualdesignlist generatedfull generatedlight $manualdesignlist $SCRIPT_DIR/analysis_programs/compiled_files/*.asm
	do
		prognamefull=${progpath##*/}
		export progname=${prognamefull%.asm}
		export compname=$compname

		echo -e "\e[30;48;5;82mSynthesizing RISC-V Gate-Level netlist using Design Compiler\e[0m"
		if !(dc_shell -f $SCRIPT_DIR/dc_compile_${compname}.tcl) then
			echo -e "\e[41mError!\e[0m"
			exit 1
		fi
	done
	if !(cp $SCAM_HOME/example/StandardCellLibraries/FreePDK45/osu_soc/lib/files/gscl45nm.v $SCRIPT_DIR/work/results/netlist) then 
		echo -e "\e[41mError!\e[0m"
		exit 1
	fi
done

for compname in basic gclock
do
	############################################################################################################
	# Perform simulation with vivado to get activity file
	mkdir -p results/activity
	for progpath in $SCRIPT_DIR/analysis_programs/compiled_files/*.hex
	do
		prognamefull=${progpath##*/}
		progname=${prognamefull%.hex}

		for fulldesign in $manualdesignlist generatedfull generatedlight
		do
			export netlistname=${fulldesign}_${compname}
			export saifname=${netlistname}_${progname}

			power_estimate
		done

		export netlistname=${progname}_${compname}
		export saifname=${netlistname}
		
		power_estimate
	done
done

############################################################################################################
# Analyze report files
if !(python3 $SCRIPT_DIR/analize_report_files.py -i $SCRIPT_DIR/work/results/reports -o $SCRIPT_DIR/reports) then
	echo -e "\e[41mError!\e[0m"
	exit 1
fi

echo -e "\e[30;48;5;82mRISC-V top-down synthesis flow finished\e[0m"


