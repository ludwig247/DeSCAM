#/* Top-level Module                               */
set my_toplevel ISA

#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk

#/* Target frequency in MHz for optimization       */
set my_clk_freq_MHz 10

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.1

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0.1

#/* Instance name used for power estimation using saif file   */
set my_saif_instance_name "Core_tb/Core_unwrapper_inst/Core_wrapper_inst"


#/* Directory names where results and reports are put   */
set RESULTS_DIR results
set REPORTS_DIR reports
