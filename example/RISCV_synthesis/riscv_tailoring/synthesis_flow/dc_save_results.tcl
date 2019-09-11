#/* Save results */

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
