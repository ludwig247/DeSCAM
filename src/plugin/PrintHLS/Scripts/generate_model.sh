#!/bin/bash

DESCAM_BIN="$HOME/DeSCAM/bin/DESCAM"
VIVADO_HLS="/opt/Xilinx/Vivado/2019.1/bin/vivado_hls"
ONESPIN="/import/software/onespin/OneSpin360_2019.2.2/bin/onespin"
PYTHON3="python3"

RED="\e[41m"
BLUE="\e[44m"
GREEN="\e[30;48;5;82m"
DEFAULT="\e[0m"

output=''
input=''
hls_option=''
use_vivado_hls=0
use_onespin=0

print_usage() {
	echo ""
	echo "------------------------ Generate VHDL Model with DeSCAM and Vivado HLS ------------------------"
	echo ""
	echo "File and HLS Option must be set!"
	echo ""
	echo "Usage: run_vhdl_with_hls -f [FILE] -t [HLS Option] [OPTIONS]"
	echo ""
	echo "FILE:"
	echo "-f                      Source File"
	echo ""
	echo "-t                      Set HLS Option (sco = Single Cycle Operations, mco = Multi Cycle Operations)"
	echo ""
	echo "Options:"
	echo "-s, --vivado_hls        Use Vivado HLS for High Level Synthesis"
	echo "-p, --onespin           Use Onespin for Formal Verification"
	echo "-o                      Output directory (default: current directory)"
	echo "-h, --help              show brief help"
}

for arg in "$@"; do
  shift
  case "$arg" in
    "--help") 			set -- "$@" "-h" ;;
    "--onespin") 		set -- "$@" "-p" ;;
    "--vivado_hls")   	set -- "$@" "-s" ;;
    *)        			set -- "$@" "$arg"
  esac
done

while getopts 'f:o:t:psh' flag; do
  case "${flag}" in
    f) 	input="${OPTARG}" ;;
	o)  output="${OPTARG}" ;;
	t)  hls_option="${OPTARG}" ;;
	s)	use_vivado_hls=1 ;;
	p)  use_onespin=1 ;;
    h) 	print_usage
	 	exit 0 ;;
    *)  echo ""  
		echo "         Invalid Argument" 	
		echo ""
		print_usage
       	exit 1 ;;
  esac
done

if [ -z "$input" ]
then
	echo "Source file is required"
	echo "Run with -h or --help for more information"
	exit 1
fi

if [ -z $output ]
then
	output="."
fi

if [ -z $hls_option ]
then
	echo -e "${RED}A HLS Option must be set (sco or mco). For more information use -h or --help${DEFAULT}"
	exit 1
fi

if [[ "$hls_option" != "sco" && "$hls_option" != "mco" ]]
then
	echo -e "${RED}Only 'sco' or 'mco' are allowed HLS Options . For more information use -h or --help${DEFAULT}"
	exit 1
fi

# Remove old files
if [ -d $output/PrintHLS ]; then rm -Rf $output/PrintHLS; fi
if [ -d $output/PrintITL ]; then rm -Rf $output/PrintITL; fi
if [ -d $output/VHDLwithHLS ]; then rm -Rf $output/VHDLwithHLS; fi

mkdir -p $output

# Start SCAM tool and generated files for HLS and Properties
echo -e "${BLUE}Generating High Level Synthesis and ITL files${DEFAULT}"
($DESCAM_BIN -f $input -o $output -PrintHLS --$hls_option -PrintITL --hls-$hls_option && echo -e "${GREEN}Generated High Level Synthesis and ITL files${DEFAULT}") || (echo -e "${RED}Error generating High Level Synthesis and ITL files${DEFAULT}" && exit 1) ;

current_working_dir=$PWD

modules="${output}/PrintHLS/.module_names.txt"

# reading each line to get the module names
while read line; do
	cd $current_working_dir

	# Remove old files
	if [ -d $output/$line ]; then rm -Rf $output/$line; fi

	# Create directory for RTL and Properties and HLS
	mkdir -p $output/$line/RTL
	mkdir -p $output/$line/Properties
	mkdir -p $output/$line/HLS

	# Copy all VHDL files in RTL directory
	cp $output/PrintHLS/$line*.vhd $output/$line/RTL

	# Copy all HLS files to HLS directory
	cp $output/PrintHLS/$line*.cpp $output/$line/HLS
	cp $output/PrintHLS/$line*.h $output/$line/HLS
	cp $output/PrintHLS/$line*.tcl $output/$line/HLS

	# Copy all ITL files in Properties directory
	cp $output/PrintITL/$line* $output/$line/Properties



	# Start High Level Synthesis
	if [[ $use_vivado_hls -eq 1 ]]; then
		cd $output/$line/HLS || (echo -e "${RED}Directory $output/HLS does not exist${DEFAULT}" && exit 1)
		mkdir -p directives
		mv *directives.tcl directives
		mkdir -p hls_script
		mv *.tcl hls_script

		echo -e "${BLUE}Start High Level Synthesis for Module ${line}${DEFAULT}"
		($VIVADO_HLS -f hls_script/"${line}_run_hls.tcl" && cp synthesis/*/syn/vhdl/*.vhd ../RTL && cat synthesis/*/syn/report/*.rpt && echo -e "${GREEN}High Level Synthesis finished${DEFAULT}") || (echo -e "${RED}High Level Synthesis failed${DEFAULT}" && exit 1) ; 


		# Use Python Script
		cd ..
		#FILE_NAME=$(echo ${input##*/} | cut -d'.' -f1)
		$PYTHON3 $current_working_dir/check_hls_output.py -f $line -t $hls_option
	fi	

# Create script for onespin
if [[ $use_vivado_hls -eq 1 && $use_onespin -eq 1 ]]; then
cat <<EOF >Onespin_Script.tcl
read_vhdl RTL/*.vhd
elaborate
compile
set_mode mv
read_itl Properties/*vhi
check -all [get_checks]
#exit -force
EOF
echo -e "${BLUE}Start Property Checking${DEFAULT}"
$ONESPIN -i Onespin_Script.tcl
fi

done < $modules

cd $current_working_dir

# Remove redundant directories
mv $modules .
rm -Rf $output/PrintHLS
rm -Rf $output/PrintITL


