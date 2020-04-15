source common_setup_st.tcl

#################################################################################
# Design Compiler Top-Down Reference Methodology Setup
# Script: dc_setup.tcl
# Version: B-2008.09-SP1 (Nov. 10, 2008)
# Copyright (C) 2007, 2008 Synopsys All rights reserved.
#################################################################################
## Avoiding too many messages
set_message_info -id PSYN-650 -limit 5 ;# Default orientation of cells
set_message_info -id PSYN-651 -limit 5 ;# Default orientation of cells
set_message_info -id PSYN-025 -limit 1  ;# No Logic info cells
set_message_info -id PSYN-040 -limit 5 ;# Dont_touch for fixed cells
set_message_info -id PSYN-087 -limit 5 ;# Port inherits its location from pad pin
set_message_info -id LINT-8   -limit 5 ;# input port is unloaded
set_message_info -id LINT-2   -limit 10 ;# port has no load

#################################################################################
# Setup Variables
#
# Modify settings in this section to customize your DC-RM run.
#################################################################################

# Portions of dc_setup.tcl may be used by other tools so do check for DC only commands
if {$synopsys_program_name == "dc_shell"}  {

  # Change alib_library_analysis_path to point to a central cache of analyzed libraries
  # to save some runtime and disk space.  The following setting only reflects the
  # the default value and should be changed to a central location for best results.

  set alib_library_analysis_path .

  # Add any additional DC variables needed here
}

# set RTL_SRC_FILES_2 ""  ;# Enter the list of source RTL files if reading from RTL

#set RTL_SRC_FILES   "/import/lab/users/deutschmann/SCAM/example/RISCV/RTL/SCAM_Model_types.vhd \  
set RTL_SRC_FILES   "/import/lab/users/deutschmann/SCAM/example/RISCV/RTL/cpath.vhd \
		     /import/lab/users/deutschmann/SCAM/example/RISCV/RTL/Decoder.vhd \
		     /import/lab/users/deutschmann/SCAM/example/RISCV/RTL/ALU.vhd \
		     /import/lab/users/deutschmann/SCAM/example/RISCV/RTL/regs.vhd \ 
		     /import/lab/users/deutschmann/SCAM/example/RISCV/RTL/CPU.vhd" ;# Enter the list of source RTL files if reading from RTL ## <- Update (Source files)


# set RTL_SRC_FILES    "/users/udupi/prop_master/instrumented.vhd";
 #set RTL_SRC_FILES   "/import/home/udupi/work/PG/PG_DMA/3./dma.mapped.vhd"
# Set clock gating and cell if needed - if not set -gate_clock in compile_ultra is using default settings
# Only enable DC_CLOCK_GATING (set to 1) if you want to tune it:

set DC_CLOCK_GATING     0
set CLOCK_GATING_CELL   integrated:CLOCK65LPSVT/HS65_LSP_CNHLSX21 

# The following variables are used by scripts in dc_scripts to direct the location
# of the output files

set REPORTS_DIR "REPORTS"
set RESULTS_DIR "RESULTS"

file mkdir ${REPORTS_DIR}
file mkdir ${RESULTS_DIR}

#################################################################################
# Library Setup
#
# This section is designed to work with the settings from common_setup.tcl
# without any additional modification.
#################################################################################

# Define all the library variables shared by all the front-end tools

set search_path ". ${ADDITIONAL_SEARCH_PATH} $search_path"

# Milkyway variable settings

# Make sure to define the following Milkyway library variables
# mw_logic1_net, mw_logic0_net and mw_design_library are needed by write_milkyway

set mw_logic1_net ${MW_POWER_NET}
set mw_logic0_net ${MW_GROUND_NET}

set mw_reference_library ${MW_REFERENCE_LIB_DIRS}
set mw_design_library ${DESIGN_NAME}_LIB

set mw_site_name_mapping {{CORE unit} {COREHD unit} {COREHV unit}}

# The remainder of the setup below should only be performed in Design Compiler
if {$synopsys_program_name == "dc_shell"}  {

  # Include all libraries for multi-Vth leakage power optimization
  set target_library ${TARGET_LIBRARY_FILES}
  set synthetic_library dw_foundation.sldb
  set link_library "* $target_library $ADDITIONAL_LINK_LIB_FILES $synthetic_library"

  # Set min libraries if they exist
  foreach {max_library min_library} $MIN_LIBRARY_FILES {
    set_min_library $max_library -min_version $min_library
  }

  if {[shell_is_in_topographical_mode]} {

    # Only create new Milkyway design library if it doesn't already exist
    if {![file isdirectory $mw_design_library ]} {
      create_mw_lib   -technology $TECH_FILE \
                      -mw_reference_library $mw_reference_library \
                      $mw_design_library
    } else {
      # If Milkyway design library already exists, ensure that it is consistent with specified Milkyway reference libraries
      set_mw_lib_reference $mw_design_library -mw_reference_library $mw_reference_library
    }

    open_mw_lib     $mw_design_library

    check_library

    set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
                       -min_tluplus $TLUPLUS_MIN_FILE \
                       -tech2itf_map $MAP_FILE

    check_tlu_plus_files

  }
}
#############################################################################
# Variables in order to align SYNTHESIS and ICC environments                #
#############################################################################
set derive_default_routing_layer_direction true
set case_analysis_with_logic_constants true
#
set timing_enable_multiple_clocks_per_reg true
set enable_recovery_removal_arcs true
set power_keep_tns true



## Section from Technokit
# Trip-point values in Synopsys libraries
set lib_thresholds_per_lib false
set rc_input_threshold_pct_fall 60
set rc_input_threshold_pct_rise 40
set rc_output_threshold_pct_fall 60
set rc_output_threshold_pct_rise 40
set rc_slew_lower_threshold_pct_fall 20
set rc_slew_lower_threshold_pct_rise 20
set rc_slew_upper_threshold_pct_fall 80
set rc_slew_upper_threshold_pct_rise 80

set timing_use_enhanced_capacitance_modeling true


## End section from Technokit


if {$synopsys_program_name == "dc_shell"}  {


############### excluded cells ################
source $LIBRARY_DONT_USE_FILE 
# 
}
