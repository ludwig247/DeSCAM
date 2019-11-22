#!/bin/bash

SCAM_BIN="$HOME/SCAM/bin/SCAM"
VIVADO_HLS="/opt/Xilinx/Vivado/2019.1/bin/vivado_hls"
ONESPIN=""

OUTPUT_DIR="VHDLwithHLS"

RED="\e[41m"
BLUE="\e[44m"
GREEN="\e[30;48;5;82m"
DEFAULT="\e[0m"


files=''
output=''

print_usage() {
	echo "-------- SCAM Tool with Vivado HLS --------"
	echo " "
	echo "Usage: run_vhdl_with_hls [FILE] [OPTIONS]"
	echo " "
	echo "FILE:"
	echo "-f				Source File"
	echo ""
	echo "Options:"
	echo "-o				Output directory (default: current directory)"
	echo "-h                show brief help"
}

while getopts 'f:h' flag; do
  case "${flag}" in
    f) 	files="${OPTARG}" ;;
    h) 	print_usage
	 	exit 0 ;;
    *) 	print_usage
       	exit 1 ;;
  esac
done

if [ -z "$files" ]
then
	echo "Source file is required"
	echo "Run with -h for more information"
	exit 1
fi

if [ -z $output ]
then
	output="."
fi

# Remove old files
if [ -d PrintHLS ]; then rm -Rf PrintHLS; fi
if [ -d PrintVHDL ]; then rm -Rf PrintVHDL; fi
if [ -d PrintITL ]; then rm -Rf PrintITL; fi
if [ -d VHDLwithHLS ]; then rm -Rf VHDLwithHLS; fi

# Start SCAM tool and generated files for HLS and Properties
echo -e "${BLUE}Generating High Level Synthesis and ITL files${DEFAULT}"
# shellcheck disable=SC2086
($SCAM_BIN -f $files -o $output -PrintHLS -PrintVHDL --hls -PrintITL --hls && echo -e "${GREEN}Generated High Level Synthesis and ITL files${DEFAULT}") || (echo -e "${RED}Error generating High Level Synthesis and ITL files${DEFAULT}" && exit 1) ;

# Create directory for RTL and Properties and HLS
mkdir $OUTPUT_DIR
mkdir $OUTPUT_DIR/RTL
mkdir $OUTPUT_DIR/Properties
mkdir $OUTPUT_DIR/HLS

# Copy all VHDL files in RTL directory
cp PrintVHDL/*.vhd $OUTPUT_DIR/RTL

# Copy all HLS files to HLS directory
cp PrintHLS/*.cpp $OUTPUT_DIR/HLS
cp PrintHLS/*.h $OUTPUT_DIR/HLS
cp PrintHLS/*.tcl $OUTPUT_DIR/HLS

# Copy all ITL files in Properties directory
cp PrintITL/* $OUTPUT_DIR/Properties

# Start High Level Synthesis
cd $OUTPUT_DIR/HLS || (echo -e "${RED}Directory $OUTPUT_DIR/HLS does not exist${DEFAULT}" && exit 1)
mkdir directives
mv *directives.tcl directives
mkdir hls_script
mv *.tcl hls_script

echo -e "${BLUE}Start High Level Synthesis${DEFAULT}"
($VIVADO_HLS -f hls_script/run_hls.tcl && cp synthesis/*/syn/vhdl/*.vhd ../RTL && cat synthesis/*/syn/report/*.rpt && echo -e "${GREEN}High Level Synthesis finished${DEFAULT}") || (echo -e "${RED}High Level Synthesis failed${DEFAULT}" && exit 1) ; 

#echo -e "${BLUE}Start High Level Synthesis${DEFAULT}"
#(for i in *.tcl; do
#	TOP_FUNCTION=$(echo "$i" | cut -f 1 -d '.') || break
#	mkdir $TOP_FUNCTION
#	mv $i $TOP_FUNCTION/$i
#	vivado_hls -f $TOP_FUNCTION/$i
#
#	# Copy all VHDL files from High Level Synthesis to RTL directory 
#	cp $TOP_FUNCTION/synthesis/*/syn/vhdl/*.vhd ../RTL
#
#	# Print report of High Level Synthesis
#	cat $TOP_FUNCTION/synthesis/*/syn/report/*.rpt
#done && echo -e "${GREEN}High Level Synthesis finished${DEFAULT}") || (echo -e "${RED}High Level Synthesis failed${DEFAULT}" && exit 1) ;

# Create script for onespin
cd ..
cat <<EOF >Onespin_Script.tcl
read_vhdl RTL/*.vhd
elaborate
compile
set_mode mv
read_itl Properties/*vhi
check -all [get_checks]
EOF

#$ONESPIN -i Onespin_Script.tcl

