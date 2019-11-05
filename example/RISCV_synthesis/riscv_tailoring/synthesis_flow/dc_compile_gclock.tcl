remove_design -designs
source ../dc_set_library.tcl
source ../dc_set_common_vars.tcl
read_ddc results/dc_elaborate/[getenv "progname"].ddc
saif_map -start

ungroup -all
compile_ultra -gate_clock

source ../dc_save_results.tcl

exit

