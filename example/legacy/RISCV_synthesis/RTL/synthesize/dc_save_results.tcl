#/* Save results */

file mkdir $RESULTS_DIR/$outname/$REPORTS_DIR

check_design
report_constraint

ungroup -all
write -f verilog -hierarchy -output $RESULTS_DIR/$outname/${my_toplevel}_${outname}.v
write_file -f ddc -hierarchy -output $RESULTS_DIR/$outname/${my_toplevel}_${outname}.ddc

redirect $RESULTS_DIR/$outname/$REPORTS_DIR/timing_${outname}.rep { report_timing }
redirect $RESULTS_DIR/$outname/$REPORTS_DIR/cell_${outname}.rep { report_cell }
redirect $RESULTS_DIR/$outname/$REPORTS_DIR/area_${outname}.rep { report_area }
redirect $RESULTS_DIR/$outname/$REPORTS_DIR/power_${outname}.rep { report_power -analysis_effort high }
