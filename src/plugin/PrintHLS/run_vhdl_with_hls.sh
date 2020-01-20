#!/bin/bash

DESCAM_BIN="$HOME/DeSCAM/bin/DESCAM"
VIVADO_HLS="/import/software/Xilinx/Vivado/2018.2/bin/vivado_hls"
ONESPIN="/import/software/onespin/OneSpin360_2019.2.2/bin/onespin"
PYTHON3="python3"

OUTPUT_DIR="VHDLwithHLS"

RED="\e[41m"
BLUE="\e[44m"
GREEN="\e[30;48;5;82m"
DEFAULT="\e[0m"

output=''
input=''

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
	echo "-h				show brief help"
}

while getopts 'f:o:h' flag; do
  case "${flag}" in
    f) 	input="${OPTARG}" ;;
	o)  output="${OPTARG}" && mkdir ${OPTARG};;
    h) 	print_usage
	 	exit 0 ;;
    *) 	print_usage
       	exit 1 ;;
  esac
done

if [ -z "$input" ]
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
if [ -d $output/PrintHLS ]; then rm -Rf $output/PrintHLS; fi
if [ -d $output/PrintVHDL ]; then rm -Rf $output/PrintVHDL; fi
if [ -d $output/PrintITL ]; then rm -Rf $output/PrintITL; fi
if [ -d $output/VHDLwithHLS ]; then rm -Rf $output/VHDLwithHLS; fi

# Start SCAM tool and generated files for HLS and Properties
echo -e "${BLUE}Generating High Level Synthesis and ITL files${DEFAULT}"
($DESCAM_BIN -f $input -o $output -PrintHLS -PrintVHDL --hls -PrintITL --hls && echo -e "${GREEN}Generated High Level Synthesis and ITL files${DEFAULT}") || (echo -e "${RED}Error generating High Level Synthesis and ITL files${DEFAULT}" && exit 1) ;

# Create directory for RTL and Properties and HLS
mkdir $output/$OUTPUT_DIR
mkdir $output/$OUTPUT_DIR/RTL
mkdir $output/$OUTPUT_DIR/Properties
mkdir $output/$OUTPUT_DIR/HLS

# Copy all VHDL files in RTL directory
cp $output/PrintVHDL/*.vhd $output/$OUTPUT_DIR/RTL

# Copy all HLS files to HLS directory
cp $output/PrintHLS/*.cpp $output/$OUTPUT_DIR/HLS
cp $output/PrintHLS/*.h $output/$OUTPUT_DIR/HLS
cp $output/PrintHLS/*.tcl $output/$OUTPUT_DIR/HLS

# Copy all ITL files in Properties directory
cp $output/PrintITL/* $output/$OUTPUT_DIR/Properties

# Start High Level Synthesis
cp test.py $output/$OUTPUT_DIR 
cd $output/$OUTPUT_DIR/HLS || (echo -e "${RED}Directory $output/$OUTPUT_DIR/HLS does not exist${DEFAULT}" && exit 1)
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

# Use Python Script
cd ..
FILE_NAME=$(echo ${input##*/} | cut -d'.' -f1)
$PYTHON3 test.py -f $FILE_NAME

# Create script for onespin
cat <<EOF >Onespin_Script.tcl
read_vhdl RTL/*.vhd
elaborate
compile
set_mode mv
read_itl Properties/*vhi
check -all [get_checks]
EOF

$ONESPIN -i Onespin_Script.tcl

# Remove redundant directories
rm -Rf ../PrintHLS
rm -Rf ../PrintVHDL
rm -Rf ../PrintITL

