##########################################################################################
# Local value setup
##########################################################################################

set hdlin_auto_save_templates true
set high_fanout_net_pin_capacitance 0.005

set sh_new_variable_message false
set sh_continue_on_error false

##########################################################################################
# Variables common to all RM scripts
# Script: common_setup.tcl
# Version: B-2008.09-SP1 (Nov. 10, 2008)
# Copyright (C) 2007, 2008 Synopsys All rights reserved.
##########################################################################################

set DESIGN_NAME                   "CPU"  ;#  The name of the top-level design      ## <- Update                 

set DESIGN_REF_DATA_PATH          "/import/lab/users/deutschmann/Desktop/PowerEstimation/NangateOpenCellLibrary_PDKv1_3_v2010_12/"  ; ## <- Update (Library path)
				   #  Absolute path prefix variable for library/design data.
                                   #  Use this variable to prefix the common absolute path to 
                                   #  the common variables defined below.
                                   #  Absolute paths are mandatory for hierarchical RM flow.

##########################################################################################
# Library Setup Variables
##########################################################################################

# For the following variables, use a blank space to separate multiple entries
# Example: set TARGET_LIBRARY_FILES "lib1.db lib2.db lib3.db"

set ADDITIONAL_SEARCH_PATH        "${DESIGN_REF_DATA_PATH}/Front_End/Liberty/NLDM/  \
				   ${DESIGN_REF_DATA_PATH}/Low_Power/Front_End/Liberty/NLDM/  "  ;#  Additional search path to be added to the default search path

set TARGET_LIBRARY_FILES          "${DESIGN_REF_DATA_PATH}/Front_End/Liberty/NLDM/NangateOpenCellLibrary_typical.db  "
				     ;#  Target technology logical libraries

set ADDITIONAL_LINK_LIB_FILES      "${DESIGN_REF_DATA_PATH}/Front_End/Liberty/NLDM/NangateOpenCellLibrary_typical.db  \
				    ${DESIGN_REF_DATA_PATH}/Low_Power/Front_End/Liberty/NLDM/LowPowerOpenCellLibrary_typical.db " ;#  Extra link logical libraries not included in TARGET_LIBRARY_FILES

set TARGET_NOM_LIB_FILES          "${DESIGN_REF_DATA_PATH}/Front_End/Liberty/NLDM/NangateOpenCellLibrary_typical.db  \
				   ${DESIGN_REF_DATA_PATH}/Low_Power/Front_End/Liberty/NLDM/LowPowerOpenCellLibrary_typical.db  "  ;#  Target technology logical libraries

set TARGET_MIN_LIB_FILES          "${DESIGN_REF_DATA_PATH}/Front_End/Liberty/NLDM/NangateOpenCellLibrary_typical.db 
				    "  ;#  Target technology logical libraries

set MIN_LIBRARY_FILES             "LowPowerOpenCellLibrary_slow.db LowPowerOpenCellLibrary_fast.db \
				   LowPowerOpenCellLibrary_worst_low.db LowPowerOpenCellLibrary_low_temp.db \
				    NangateOpenCellLibrary_slow.db NangateOpenCellLibrary_fast.db \
				    NangateOpenCellLibrary_worst_low.db NangateOpenCellLibrary_fast.db" ;#  List of max min library pairs "max1 min1 max2 min2 max3 min3"...

set MW_REFERENCE_LIB_DIRS         "../TECH/UnitTile/unitTile_STD ${DESIGN_REF_DATA_PATH}/CORE65LPSVT_5.1/SYNOPSYS/PR/CORE65LPSVT \
                                   ${DESIGN_REF_DATA_PATH}/CLOCK65LPSVT_3.1/SYNOPSYS/PR/CLOCK65LPSVT \
                                   ${DESIGN_REF_DATA_PATH}/ESWITCH65LPSVTHVT_1V2_50A_7.0/SYNOPSYS/PR/ESWITCH65LPSVTHVT_1V2_50A \
				   ${DESIGN_REF_DATA_PATH}/CORI65LPSVT_2.2/SYNOPSYS/PR/CORI65LPSVT" ;#  Milkyway reference libraries (include IC Compiler ILMs here)

set TECH_FILE                     "../TECH/tech.tf"  ;#  Milkyway technology file
set MAP_FILE                      "../TECH/mapfile"  ;#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "../TECH/tluplus_rcmax"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "../TECH/tluplus_rcmin"  ;#  Min TLUplus file


set MW_POWER_NET                "vdd" ;#
set MW_POWER_PORT               "vdd" ;#
set MW_GROUND_NET               "gnd" ;#
set MW_GROUND_PORT              "gnd" ;#

set MIN_ROUTING_LAYER            "M1"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M7"   ;# Max routing layer

set LIBRARY_DONT_USE_FILE        "dont_use_st.tcl"   ;# Tcl file with library modifications for dont_use


##########################################################################################
# Multi-Voltage Common Variables
#
# Define the following MV common variables for the RM scripts for multi-voltage flows.
# Use as few or as many of the following definitions as needed by your design.
##########################################################################################
#
#set PD1                          ""           ;# Name of power domain/voltage area  1
#set PD1_CELLS                    ""           ;# Instances to include in power domain/voltage area 1
#set VA1_COORDINATES              {}           ;# Coordinates for voltage area 1
#set MW_POWER_NET1                "VDD1"       ;# Power net for voltage area 1
#set MW_POWER_PORT1               "VDD"        ;# Power port for voltage area 1
#
#set PD2                          ""           ;# Name of power domain/voltage area  2
#set PD2_CELLS                    ""           ;# Instances to include in power domain/voltage area 2
#set VA2_COORDINATES              {}           ;# Coordinates for voltage area 2
#set MW_POWER_NET2                "VDD2"       ;# Power net for voltage area 2
#set MW_POWER_PORT2               "VDD"        ;# Power port for voltage area 2
#
#set PD3                          ""           ;# Name of power domain/voltage area  3
#set PD3_CELLS                    ""           ;# Instances to include in power domain/voltage area 3
#set VA3_COORDINATES              {}           ;# Coordinates for voltage area 3
#set MW_POWER_NET3                "VDD3"       ;# Power net for voltage area 3
#set MW_POWER_PORT3               "VDD"        ;# Power port for voltage area 3
#
#set PD4                          ""           ;# Name of power domain/voltage area  4
#set PD4_CELLS                    ""           ;# Instances to include in power domain/voltage area 4
#set VA4_COORDINATES              {}           ;# Coordinates for voltage area 4
#set MW_POWER_NET4                "VDD4"       ;# Power net for voltage area 4
#set MW_POWER_PORT4               "VDD"        ;# Power port for voltage area 4
