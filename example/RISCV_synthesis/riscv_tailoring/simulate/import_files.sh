#!/bin/bash

# Define the root directory of Xilinx that contains bin and data folders e.g. "/import/public/common/Xilinx/Vivado/2018.2/"
XILINX_ROOT_DIR="/import/public/common/Xilinx/Vivado/2018.2"

# Define testbench files (data types has to be imported first). If no testbench files are defined contents from testbench_files folder will be read.
TESTBENCH_FILES_VHDL=""
TESTBENCH_FILES_VLOG=""

# Define design files (data types has to be imported first). If no design files are defined contents from design_files folder will be read.
DESIGN_FILES_VHDL=""
DESIGN_FILES_VLOG=""

# Define the top module in the simulation
TOP_MODULE="Core_tb"

# Define the timescale of the simulation (needed when source files don't have the timescale specified or it does not match)
TIMESCALE="1ns/10ps"

# NOTE: all netlist files in the netlist folder are imported automatically

# Create working directory to keep root directory clean
mkdir -p work
cd work

# Delete previous contents in case exists
rm -rf *

# Remove previous activity file
rm -f ../design_files/activity.saif

$XILINX_ROOT_DIR/bin/xvlog $XILINX_ROOT_DIR/data/verilog/src/glbl.v

# Importing data types from testbench_files
shopt -s nullglob # enable (prevents execution if no matching files are found)
if [[ $TESTBENCH_FILES_VHDL != *[!\ ]* && $TESTBENCH_FILES_VLOG != *[!\ ]* ]]; then
	echo "SCRIPT INFO: No testbench files defined, contents will be loaded from testbench folder."
	for file in ./../testbench_files/*_types.vhd
	do
		$XILINX_ROOT_DIR/bin/xvhdl $file
	done
	for file in ./../testbench_files/*_types.v
	do
		$XILINX_ROOT_DIR/bin/xvlog $file
	done
fi

# Importing data types from design
if [[ $DESIGN_FILES_VHDL != *[!\ ]* && $DESIGN_FILES_VLOG != *[!\ ]* ]]; then
	echo "SCRIPT INFO: No design files defined, contents will be loaded from design folder."
	for file in ./../design_files/*_types.vhd
	do
		$XILINX_ROOT_DIR/bin/xvhdl $file
	done
	for file in ./../design_files/*_types.v
	do
		$XILINX_ROOT_DIR/bin/xvlog $file
	done
fi

# Importing testbench files
if [[ $TESTBENCH_FILES_VHDL = *[!\ ]* || $TESTBENCH_FILES_VLOG = *[!\ ]* ]]; then
	if [[ $TESTBENCH_FILES_VHDL = *[!\ ]* ]]; then
		$XILINX_ROOT_DIR/bin/xvhdl $TESTBENCH_FILES_VHDL
	fi
	if [[ $TESTBENCH_FILES_VLOG = *[!\ ]* ]]; then
		$XILINX_ROOT_DIR/bin/xvlog $TESTBENCH_FILES_VLOG
	fi
else
	for file in ./../testbench_files/*.vhd
	do
		$XILINX_ROOT_DIR/bin/xvhdl $file
	done
	for file in ./../testbench_files/*.v
	do
		$XILINX_ROOT_DIR/bin/xvlog $file
	done
fi

# Importing design files
if [[ $DESIGN_FILES_VHDL = *[!\ ]* || $DESIGN_FILES_VLOG = *[!\ ]* ]]; then
	if [[ $DESIGN_FILES_VHDL = *[!\ ]* ]]; then
		$XILINX_ROOT_DIR/bin/xvhdl $DESIGN_FILES_VHDL
	fi
	if [[ $DESIGN_FILES_VLOG = *[!\ ]* ]]; then
		$XILINX_ROOT_DIR/bin/xvlog $DESIGN_FILES_VLOG
	fi
else
	for file in ./../design_files/*.vhd
	do
		$XILINX_ROOT_DIR/bin/xvhdl $file
	done
	for file in ./../design_files/*.v
	do
		$XILINX_ROOT_DIR/bin/xvlog $file
	done
fi
shopt -u nullglob # disable

# Elaborate design
xelab -debug typical -s top_sim -timescale $TIMESCALE $TOP_MODULE glbl








