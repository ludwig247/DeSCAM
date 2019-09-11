open_saif ../design_files/activity.saif
# Define signals for activity tracking
log_saif [get_object /Core_tb/Core_unwrapper_inst/Core_wrapper_inst/*]
# Define length of the simulation
run 25000ns
close_saif
exit
