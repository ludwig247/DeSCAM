source dc_set_library.tcl
source dc_common_vars.tcl
remove_design -designs
read_ddc $RESULTS_DIR/elaborate/${my_toplevel}_elaborate.ddc
saif_map -start

#set outname "basic"
ungroup -all
compile_ultra

source dc_save_results.tcl
