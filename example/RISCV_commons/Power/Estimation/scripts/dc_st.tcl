source dc_setup_st.tcl

#################################################################################
# Design Compiler Reference Methodology Script for Top-Down Flow
# Script: dc.tcl
# Version: B-2008.09-SP1 (Nov. 10, 2008)
# Copyright (C) 2007, 2008 Synopsys All rights reserved.
#################################################################################

#################################################################################
# Additional Variables
#
# Add any additional variables needed for your flow here.
#################################################################################
set power_preserve_rtl_hier_names true

# No additional flow variables are being recommended

#################################################################################
# Setup for Formality verification
#
# SVF should always be written to allow Formality verification
# for advanced optimizations.
#################################################################################

set_svf ${RESULTS_DIR}/${DESIGN_NAME}.mapped.svf

#################################################################################
# Setup SAIF Name Mapping Database
#
# Include an RTL SAIF for better power optimization and analysis.
#
# saif_map should be issued prior to RTL elaboration to create a name mapping
# database for better annotation.
################################################################################

saif_map -start

#################################################################################
# Read in the RTL Design
#
# Read in the RTL source files or read in the elaborated design (DDC).
# Use the -format option to specify: verilog, sverilog, or vhdl as needed.
#################################################################################

analyze  -format vhdl ${RTL_SRC_FILES}
# analyze -format sverilog ${RTL_SRC_FILES_2}
elaborate ${DESIGN_NAME} 
write -hierarchy -format ddc -output ${RESULTS_DIR}/${DESIGN_NAME}.elab.ddc

# rtl2saif -output SAIF/rtl_saif_forward_${DESIGN_NAME}.saif


# OR

# You can read an elaborated design from the same release.
# Using an elaborated design from an older release will not give the best results.

#### read_ddc  ${RESULTS_DIR}/${DESIGN_NAME}.elab.ddc

current_design ${DESIGN_NAME}

link


#################################################################################
# Apply Logical Design Constraints
#################################################################################

source ${DESIGN_NAME}.constraints.tcl

# You can enable analysis and optimization for multiple clocks per register.
# To use this, you must constrain to remove false interactions between mutually exclusive
# clocks.  This is needed to prevent unnecessary analysis that can result in
# a significant runtime increase with this feature enabled.
#
# set_clock_groups -physically_exclusive | -logically_exclusive | -asynchronous \
#                  -group {CLKA, CLKB} -group {CLKC, CLKD} 
#
# set timing_enable_multiple_clocks_per_reg true

#################################################################################
# Apply The Operating Conditions
#################################################################################

# Set operating condition on top level
# Comment out if these are already set in your constraints file.
# set_operating_conditions -library CORE65LPSVT_wc_1.10V_125C_10y.db:CORE65LPSVT -max wc_1.10V_125C_10y -min bc_1.30V_m40C_10y
# set_operating_conditions -library CLOCK65LPSVT_wc_1.10V_125C_10y.db:CLOCK65LPSVT -max wc_1.10V_125C_10y -min bc_1.30V_m40C_10y
set_operating_conditions -library NangateOpenCellLibrary_typical.db:NangateOpenCellLibrary
###set_operating_conditions -max <max_opcond> -min <min_opcond>

#################################################################################
# Create Default Path Groups
#
# Separating these paths can help improve optimization.
# Remove these path group settings if user path groups have already been defined.
#################################################################################

set ports_clock_root [get_ports [all_fanout -flat -clock_tree -level 0]] 
group_path -name REGOUT -to [all_outputs] 
group_path -name REGIN -from [remove_from_collection [all_inputs] $ports_clock_root] 
group_path -name FEEDTHROUGH -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]

#################################################################################
# Power Optimization Section
#################################################################################
set_clock_gating_style -minimum_bitwidth 3
    #############################################################################
    # Clock Gating Setup
    #############################################################################
    ####   old setup for clock gating insertion 
    if { $DC_CLOCK_GATING } {
     	if { [info exist CLOCK_GATING_CELL] } {
         set_clock_gating_style -sequential_cell latch -minimum_bitwidth 3 \
                               -positive_edge_logic "$CLOCK_GATING_CELL" \
                               -control_point before \
                               -control_signal TEST_MODE \
                               -max_fanout 32
    #    insert_clock_gating -global
    #    propagate_constraints -gate_clock
    #    report_clock_gating -nosplit > ./REPORTS/rtl_clock_gate_${TOP}.rpt
        } 
    #else {
    #       echo "\nError: The variable CLOCK_GATING_CELL has not been set."
    #       echo "       Please, set it in the \"Design_variables.tcl\" file"
    #       echo "\n"
    #       exit
    #	}

    }


    # Default clock_gating_style suits most designs.  Change only if necessary.
    # set_clock_gating_style ...

    # Clock gate insertion is now performed during compile_ultra -gate_clock
    # so insert_clock_gating is no longer recommended at this step.

    # For better timing optimization of enable logic, clock latency for 
    # clock gating cells can be optionally specified.

    # set_clock_gate_latency -clock <clock_name> -stage <stage_num> \
    #         -fanout_latency {fo_range1 latency_val1 fo_range2 latency_val2 ...}

    #############################################################################
    # Apply Power Optimization Constraints
    #############################################################################

    # Include a SAIF file, if possible, for power optimization.  If a SAIF file
    # is not provided, the default toggle rate of 0.1 will be used for propagating
    # switching activity.

    # read_saif -auto_map_names -input ${DESIGN_NAME}.saif -instance < DESIGN_INSTANCE > -verbose
    # read_saif -auto_map_names -input SAIF/rtl_saif_backward_${DESIGN_NAME}.saif -instance_name tb_dma_reset/DUT -verbose

    # Remove set_max_total_power power optimization constraint from scripts in 2008.09
    # Enable both of the following settings for total power optimization

    #set_max_leakage_power 0
    #set_max_dynamic_power 0

    if {[shell_is_in_topographical_mode]} {
      # Setting power constraints will automatically enable power prediction using clock tree estimation.
      # If you are not setting any power constraints and you still want to report
      # correlated power, you can use the following command to turn on power prediction.

      set_power_prediction true
    }

if {[shell_is_in_topographical_mode]} {

  ##################################################################################
  # Apply Physical Design Constraints
  #
  # Optional: Floorplan information can be read in here if available.
  # This is highly recommended for irregular floorplans.
  #
  # Floorplan constraints can be extracted from DEF files using
  # extract_physical_constraints OR provided from Tcl commands.
  #
  # DEF is the recommended input format to maximize the use of the latest
  # floorplan read capabilities of Design Compiler topographical mode.
  #
  ##################################################################################

  # Specify ignored layers for routing to improve correlation
  # Use the same ignored layers that will be used during place and route

  if { ${MIN_ROUTING_LAYER} != ""} {
    set_ignored_layers -min_routing_layer ${MIN_ROUTING_LAYER}
  }
  if { ${MAX_ROUTING_LAYER} != ""} {
    set_ignored_layers -max_routing_layer ${MAX_ROUTING_LAYER}
  }

  report_ignored_layers

  # If the macro names change after mapping and writing out the design due to
  # ungrouping or Verilog change_names renaming, it may be necessary to translate 
  # the names to correspond to the cell names that exist before compile.

  # During DEF constraint extraction, extract_physical_constraints automatically
  # matches DEF names back to precompile names in memory using standard matching rules.

  # Modify fuzzy_query_options if other characters are used for hierarchy separators
  # or bus names. 

  # set_fuzzy_query_options -hierarchical_separators {/ _ .} \
  #                         -bus_name_notations {[] __ ()} \
  #                         -class {cell pin port net} \
  #                         -show

  # Note:  The -site_row or -pre_route options are not needed to extract this info
  #        from the DEF file.  These are extracted automatically and saved in DDC.
  #        Only use these options if you want this info to be included in the
  #        ASCII output from "extract_physical_constraints -output".

  # --- extract_physical_constraints ${DESIGN_NAME}.def
  
  # OR

  # For Tcl constraints, the name matching feature must be explicitly enabled
  # and will also use the set_fuzzy_query_options setttings.  This should 
  # be turned off after the constraint read in order to minimize runtime.

  # set fuzzy_matching_enabled true 
  # source -echo -verbose ${DESIGN_NAME}.physical_constraints.tcl
  # set fuzzy_matching_enabled false 



  # Note: Include the -site_row or -pre_route options with either
  # write_physical_constraints or report_physical_constraints if you also
  # want to include these in the ASCII output files.  Site rows and pre-routes
  # are automatically extracted from the DEF and saved in the DDC even if these
  # options are not specified.

  # You can save the extracted constraints for fast loading next time.
  # write_physical_constraints -output ${DESIGN_NAME}.physical_constraints.tcl

  # Verify that all the desired physical constraints have been applied
  report_physical_constraints > ${REPORTS_DIR}/${DESIGN_NAME}.physical_constraints.rpt
}

#################################################################################
# Apply Additional Optimization Constraints
#################################################################################

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants

#################################################################################
# Compile the Design
#
# Recommended Options:
#
#     -scan
#     -gate_clock
#     -retime
#     -timing_high_effort_script
#     -area_high_effort_script
#     -congestion
#     -num_cpus
#
# Use compile_ultra as your starting point. For test-ready compile, include
# the -scan option with the first compile and any subsequent compiles.
#
# Use -gate_clock to insert clock-gating logic during optimization.  This
# is now the recommended methodology for clock gating.
#
# Use -retime to enable adapative retiming optimization for further timing
# benefit without any runtime or memory overhead.
#
# The -timing_high_effort_script or the -area_high_effort_script option
# may also be used to try and improve the optimization results at the tradeoff
# of some additional runtime.
#
# The -congestion option (topographical mode only) enables specialized optimizations that
# reduce routing related congestion during synthesis.
# This option requires a license for Design Compiler Graphical.
#
# Use -num_cpus to enable multi-core optimization to improve runtime.  Note
# that this feature has special usage and license requirements.  See the following
# article for more info: https://solvnet.synopsys.com/retrieve/024947.html
#
#################################################################################

# Before running topographical mode synthesis for the first time, run
# "compile_ultra -check_only" to verify that your libraries and design
# will not fail during optimization in topographical mode.

check_design

# compile_ultra -check_only
# quit
set_cost_priority -delay
ungroup -all
#compile_ultra -scan -gate_clock

compile_ultra -gate_clock 

### ## <- Update (SAIF file path and instance name)
read_saif -auto_map_names -input /import/lab/users/deutschmann/Desktop/PowerEstimation/v3/v3_fibonacci.saif -instance_name cpu_tb/IF_CPU -verbose
#read_saif -auto_map_names -input SAIF/rtl_saif_backward_${DESIGN_NAME}.saif -instance_name tb_euclid_reset/DUT -verbose

set_max_leakage_power 0
set_max_dynamic_power 0

compile_ultra -incremental 

uniquify


#################################################################################
# Save Design after First Compile
#################################################################################

write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.compile_ultra.ddc

#################################################################################
# DFT Compiler Optimization Section
#################################################################################

    #############################################################################
    # DFT Signal Type Definitions
    #
    # These are design-specific settings that should be modified.
    # The following are only examples and should not be used.
    #############################################################################

    # It is recommended that top-level test ports be defined as a part of the
    # RTL design and included in the netlist for floorplanning.

    # If you create test ports here and they are not in your floorplan, you should
    # set_port_location for these additional test ports for topographical mode synthesis.

    # create_port ScanPortName ... (repeat for each new test port)

    #if {[shell_is_in_topographical_mode]} {
      # set_port_location -coordinate {x y} ScanPortName ... (repeat for each new test port)
    #}

    #set_dft_signal -type ScanDataOut -port SO -view spec
    #set_dft_signal -type ScanDataIn -port SI -view spec
    #set_dft_signal -type ScanEnable -port SCAN_ENABLE  -view spec
    #set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port [list CLK]
    #set_dft_signal -view existing_dft -type Reset -port RESET -active 0

    #############################################################################
    # DFT for Clock Gating
    #
    # This section includes variables and commands used only when clock-gating
    # has been performed in the design.
    #############################################################################

    # Modify the following as needed to initialize clock gating cells for test
    #set_dft_drc_configuration -clock_gating_init_cycles 1

    # Specify which TestMode signals should be used for clock-gating
    # with the "-usage clock_gating" option for set_dft_signal

    # set_dft_signal -type TestMode -port test_mode -view spec -usage clock_gating

    # You can specify the clock-gating connectivity of the ScanEnable/TestMode signals
    # after they are predefined with set_dft_signal -usage clock_gating

    # set_dft_connect <LABEL> -source <DFT signal> -type clock_gating_control [-target ...]

    # Note: hookup_testports functionality is fully integrated into insert_dft
    #       in B-2008.09-SP1.  We recommend that you remove hookup_testports
    #       from your scripts.


    #############################################################################
    # DFT Configuration
    #############################################################################

    #set_dft_insertion_configuration -preserve_design_name true

    # Do not run incremental compile as a part of insert_dft
    #set_dft_insertion_configuration -synthesis_optimization none

    ## DFT Clock Mixing Specification
    # For a hierarchical flow, don't mix clocks at the block-level:
    # set_scan_configuration -clock_mixing no_mix

    # For top-down methodology clock mixing is recommended, if possible:
    #set_scan_configuration -clock_mixing mix_clocks

    # Use the following to enable ADAPTIVE SCAN
    # set_dft_configuration -scan_compression enable

    # Use the following to define the test-mode to be used for ADAPTIVE SCAN
    # Ensure that that test mode signals to be used for clock-gating have
    # been configured with set_dft_signal -usage clock_gating.

    # set_dft_signal -type TestMode -view spec -port scan_compression_enable

    # Add any additional design-specific DFT constraints here

    # Starting with 2008.09, we recommend the use of"-capture_procedure multi_clock"
    # for the create_test_protocol command. 
    # As early as 2008.09-SP2 release, "-capture_procedure multi_clock" will be default. 
    # If necessary, you can use the "-capture_procedure single_clock" option. 

    #create_test_protocol -capture_procedure multi_clock

    #############################################################################
    # DFT Scan Chain Insertion
    #############################################################################

    # Use the -verbose option of dft_drc to assist in debugging if necessary
    
    #dft_drc                                > ${REPORTS_DIR}/${DESIGN_NAME}.dft_drc_configured.rpt
    #report_scan_configuration              > ${REPORTS_DIR}/${DESIGN_NAME}.scan_config.rpt
    #report_dft_insertion_configuration     > ${REPORTS_DIR}/${DESIGN_NAME}.report_dft_insertion_config.preview_dft.rpt

    # Use the -show all option to preview_dft for more detailed report
    #preview_dft                            > ${REPORTS_DIR}/${DESIGN_NAME}.preview_dft.rpt

    #insert_dft

    #################################################################################
    # DFT Incremental Compile
    #
    # Only required if scan chain insertion has been performed.
    #################################################################################

    #compile_ultra -incremental -scan

#################################################################################
# Write Out Final Design and Reports
#
#        .ddc:   Recommended binary format used for subsequent Design Compiler sessions
#    Milkyway:   Recommended binary format for IC Compiler
#        .v  :   Verilog netlist for ASCII flow (Formality, PrimeTime, VCS)
#       .spef:   Topographical mode parasitics for PrimeTime
#        .sdf:   SDF backannotated topographical mode timing for PrimeTime
#        .sdc:   SDC constraints for ASCII flow
#
#################################################################################

change_names -rules vhdl -hierarchy

    #############################################################################
    # DFT Write out Test Protocols and Reports
    #############################################################################

    # write_scan_def adds SCANDEF info to the design database in memory so this
    # must be performed prior to writing out the design for binary SCANDEF.

    #write_scan_def -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.scandef
    #check_scan_def > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.check_scan_def.rpt
    #write_test_model -format ctl -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.ctl

    #report_dft_signal > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.dft_signals.rpt

    # If NOT using ADAPTIVE SCAN
    #write_test_protocol -names verilog -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.scan.spf
    #dft_drc > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.dft_drc_inserted.rpt
    #report_scan_path > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.scanpath.rpt

    # OR

    # If using ADAPTIVE SCAN
    # write_test_protocol -test_mode Internal_scan -names verilog -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.scan.spf
    # write_test_protocol -test_mode ScanCompression_mode -names verilog -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.scancompress.spf
    # current_test_mode Internal_scan
    # dft_drc > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.dft_drc_inserted.rpt
    # current_test_mode ScanCompression_mode
    # dft_drc > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.dft_drc_inserted.scan_compression.rpt
    # report_scan_path > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.scanpath.scan_compression.rpt

#################################################################################
# Write out Design
#################################################################################

# Write and close SVF file and make it available for immediate use
set_svf -off

write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.ddc
write -f verilog -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.v
write -f vhdl -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.vhd

#################################################################################
# Generate Final Reports 1/2
#################################################################################

report_qor > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.qor.rpt
report_timing -transition_time -nets -attributes -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.timing.rpt

if {[shell_is_in_topographical_mode]} {
report_area -physical -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.area.rpt
} else {
report_area -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.area.rpt
}

#################################################################################
# Write out Design Data
#################################################################################

if {[shell_is_in_topographical_mode]} {

  # Note: Include the -site_row or -pre_route options with write_physical_constraints
  # if you also want to include these in the ASCII output files.  Site rows and pre-routes
  # are automatically extracted from the DEF and saved in the DDC even if these
  # options are not specified.

  write_physical_constraints -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.physical_constraints.tcl

  # Write parasitics data from DCT placement for static timing analysis
  write_parasitics -output ${RESULTS_DIR}/${DESIGN_NAME}.mapped.spef

  # Write SDF backannotation data from DCT placement for static timing analysis
  write_sdf ${RESULTS_DIR}/${DESIGN_NAME}.mapped.sdf

  # Do not write out net RC info into SDC
  set write_sdc_output_lumped_net_capacitance false
  set write_sdc_output_net_resistance false
}

write_sdc -nosplit ${RESULTS_DIR}/${DESIGN_NAME}.mapped.sdc

# If SAIF is used, write out SAIF name mapping file for PrimeTime-PX
saif_map -type ptpx -write_map ${RESULTS_DIR}/${DESIGN_NAME}.mapped.SAIF.namemap

#################################################################################
# Generate Final Reports 2/2
#################################################################################

if {[shell_is_in_topographical_mode]} {
  # report_congestion (topographical mode only) reports estimated routing related congestion
  # after topographical mode synthesis.
  # This command requires a license for Design Compiler Graphical.

  report_congestion > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.congestion.rpt
}

# Use SAIF file for power analysis
# read_saif -auto_map_names -input ${DESIGN_NAME}.saif -instance < DESIGN_INSTANCE > -verbose
#  ## <- Update 
read_saif -auto_map_names -input /import/lab/users/deutschmann/Desktop/PowerEstimation/v3/v3_fibonacci.saif -instance_name cpu_tb/IF_CPU -verbose
#read_saif -auto_map_names -input SAIF/rtl_saif_backward_${DESIGN_NAME}.saif -instance_name tb_euclid_reset/DUT -verbose

report_power -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.power.rpt
report_clock_gating -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.clock_gating.rpt
report_reference -nosplit > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.references.rpt

#################################################################################
# Write out Milkyway Design for Top-Down Flow
#
# This should be the last step in the script
#################################################################################

if {[shell_is_in_topographical_mode]} {
  # write_milkyway uses: mw_logic1_net, mw_logic0_net and mw_design_library variables from dc_setup.tcl
  write_milkyway -overwrite -output ${DESIGN_NAME}_DCT
}

