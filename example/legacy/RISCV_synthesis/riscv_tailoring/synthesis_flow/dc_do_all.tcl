#/* Remove previous desings         			   */
remove_design -designs

source ../dc_set_library.tcl
source ../dc_set_common_vars.tcl

#/* Included HDL files         */
set my_vhdl_types [glob -directory [getenv "SCRIPT_DIR"]/work/results/RTL/[getenv "progname"]/ "*_types.vhd"]
set my_vhdl_files [glob -directory [getenv "SCRIPT_DIR"]/work/results/RTL/[getenv "progname"]/ "*.vhd"]

set verilogout_show_unconnected_pins "true"

################################################################################
# Setup SAIF Name Mapping Database
#
# Include an RTL SAIF for better power optimization and analysis.
#
# saif_map should be issued prior to RTL elaboration to create a name mapping
# database for better annotation.
################################################################################

analyze -f vhdl $my_vhdl_types
analyze -f vhdl $my_vhdl_files

saif_map -start
read_saif -auto_map_names -input results/activity_rtl/[getenv "saifname"].saif -instance_name $my_saif_instance_name -verbose

elaborate $my_toplevel

current_design $my_toplevel

set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

#/* Save elaboration results */
link
uniquify
ungroup -all
file mkdir results/dc_elaborate
write_file -f ddc -hierarchy -output results/dc_elaborate/[getenv "progname"].ddc

compile_ultra -gate_clock

file mkdir results/reports
file mkdir results/netlist

check_design
report_constraint

ungroup -all
write -f verilog -hierarchy -output results/netlist/[getenv "progname"]_[getenv "compname"].v
write_file -f ddc -hierarchy -output results/netlist/[getenv "progname"]_[getenv "compname"].ddc

redirect results/reports/timing_[getenv "progname"]_[getenv "compname"].rep { report_timing }
redirect results/reports/cell_[getenv "progname"]_[getenv "compname"].rep { report_cell }
redirect results/reports/area_[getenv "progname"]_[getenv "compname"].rep { report_area }
redirect results/reports/power_[getenv "progname"]_[getenv "compname"].rep { report_power -analysis_effort high }
#/* Save power estimation results */
redirect results/reports/gclock_[getenv "saifname"].rep { report_clock_gating -ungated }


exit






