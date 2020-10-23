#/**************************************************/
#/* Power Estimate using *.saif activity file      */
#/**************************************************/
source ../dc_set_common_vars.tcl
source ../dc_set_library.tcl

remove_design -designs

saif_map -start

read_ddc results/netlist/[getenv "netlistname"].ddc
read_saif -auto_map_names -input results/activity/[getenv "saifname"].saif -instance_name $my_saif_instance_name -verbose

#/* Save power estimation results */
redirect results/reports/power_[getenv "saifname"].rep { report_power -analysis_effort high }

exit
