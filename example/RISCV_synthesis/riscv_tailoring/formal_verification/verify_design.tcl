# CPU HDL files
read_vhdl -golden -version 93 "./RTL/PrintVHDL/SCAM_Model_types.vhd"
read_vhdl -golden -version 93 "./RTL/PrintVHDL/${design_name}.vhd" 

elaborate -golden
compile -golden

set_mode mv

read_itl "./RTL/PrintITL/${design_name}.vhi"
read_itl "./RTL/PrintITL/${design_name}_functions.vhi"

# allow multiple processes running simultaneously
set_check_option -local_processes 4

# Go through and run the properties, export results to log file
start_message_log -force ./onespin_logs/${design_name}_results_${suffix}.log
check  -all [get_checks]
stop_message_log
