#/**************************************************/
#/* Power Estimate using *.saif activity file      */
#/**************************************************/

#set outname "synth1"

source dc_common_vars.tcl
source dc_set_library.tcl

remove_design -designs

saif_map -start

read_ddc $RESULTS_DIR/$outname/${my_toplevel}_${experiments_name}.ddc
read_saif -auto_map_names -input $RESULTS_DIR/$outname/activity.saif -instance_name $my_saif_instance_name -verbose

#/* Save power estimation results */
redirect $RESULTS_DIR/$outname/$REPORTS_DIR/power_saif_${outname}.rep { report_power -analysis_effort high }

#quit
