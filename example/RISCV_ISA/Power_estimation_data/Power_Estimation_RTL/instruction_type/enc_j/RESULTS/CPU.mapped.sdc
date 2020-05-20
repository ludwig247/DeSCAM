###################################################################

# Created by write_sdc on Fri May 8 12:25:52 2020

###################################################################
set sdc_version 2.0

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_max_transition 2 [current_design]
create_clock [get_ports clk]  -period 20  -waveform {0 10}
set_clock_latency -max 0.8  [get_clocks clk]
set_clock_latency -min 0.4  [get_clocks clk]
set_clock_uncertainty -setup 0.2  [get_clocks clk]
set_clock_uncertainty -hold 0.1  [get_clocks clk]
set_clock_transition -min -fall 1 [get_clocks clk]
set_clock_transition -min -rise 1 [get_clocks clk]
set_clock_transition -max -fall 1 [get_clocks clk]
set_clock_transition -max -rise 1 [get_clocks clk]
group_path -name FEEDTHROUGH  -from [list [get_ports rst] [get_ports MemToCtl_port(31)] [get_ports MemToCtl_port(30)] [get_ports MemToCtl_port(29)] [get_ports MemToCtl_port(28)] [get_ports MemToCtl_port(27)] [get_ports MemToCtl_port(26)] [get_ports MemToCtl_port(25)] [get_ports MemToCtl_port(24)] [get_ports MemToCtl_port(23)] [get_ports MemToCtl_port(22)] [get_ports MemToCtl_port(21)] [get_ports MemToCtl_port(20)] [get_ports MemToCtl_port(19)] [get_ports MemToCtl_port(18)] [get_ports MemToCtl_port(17)] [get_ports MemToCtl_port(16)] [get_ports MemToCtl_port(15)] [get_ports MemToCtl_port(14)] [get_ports MemToCtl_port(13)] [get_ports MemToCtl_port(12)] [get_ports MemToCtl_port(11)] [get_ports MemToCtl_port(10)] [get_ports MemToCtl_port(9)] [get_ports MemToCtl_port(8)] [get_ports MemToCtl_port(7)] [get_ports MemToCtl_port(6)] [get_ports MemToCtl_port(5)] [get_ports MemToCtl_port(4)] [get_ports MemToCtl_port(3)] [get_ports MemToCtl_port(2)] [get_ports MemToCtl_port(1)] [get_ports MemToCtl_port(0)] [get_ports MemToCtl_port_sync] [get_ports CtlToMem_port_sync]]  -to [list [get_ports MemToCtl_port_notify] [get_ports CtlToMem_port_addrIn(31)] [get_ports CtlToMem_port_addrIn(30)] [get_ports CtlToMem_port_addrIn(29)] [get_ports CtlToMem_port_addrIn(28)] [get_ports CtlToMem_port_addrIn(27)] [get_ports CtlToMem_port_addrIn(26)] [get_ports CtlToMem_port_addrIn(25)] [get_ports CtlToMem_port_addrIn(24)] [get_ports CtlToMem_port_addrIn(23)] [get_ports CtlToMem_port_addrIn(22)] [get_ports CtlToMem_port_addrIn(21)] [get_ports CtlToMem_port_addrIn(20)] [get_ports CtlToMem_port_addrIn(19)] [get_ports CtlToMem_port_addrIn(18)] [get_ports CtlToMem_port_addrIn(17)] [get_ports CtlToMem_port_addrIn(16)] [get_ports CtlToMem_port_addrIn(15)] [get_ports CtlToMem_port_addrIn(14)] [get_ports CtlToMem_port_addrIn(13)] [get_ports CtlToMem_port_addrIn(12)] [get_ports CtlToMem_port_addrIn(11)] [get_ports CtlToMem_port_addrIn(10)] [get_ports CtlToMem_port_addrIn(9)] [get_ports CtlToMem_port_addrIn(8)] [get_ports CtlToMem_port_addrIn(7)] [get_ports CtlToMem_port_addrIn(6)] [get_ports CtlToMem_port_addrIn(5)] [get_ports CtlToMem_port_addrIn(4)] [get_ports CtlToMem_port_addrIn(3)] [get_ports CtlToMem_port_addrIn(2)] [get_ports CtlToMem_port_addrIn(1)] [get_ports CtlToMem_port_addrIn(0)] [get_ports CtlToMem_port_dataIn(31)] [get_ports CtlToMem_port_dataIn(30)] [get_ports CtlToMem_port_dataIn(29)] [get_ports CtlToMem_port_dataIn(28)] [get_ports CtlToMem_port_dataIn(27)] [get_ports CtlToMem_port_dataIn(26)] [get_ports CtlToMem_port_dataIn(25)] [get_ports CtlToMem_port_dataIn(24)] [get_ports CtlToMem_port_dataIn(23)] [get_ports CtlToMem_port_dataIn(22)] [get_ports CtlToMem_port_dataIn(21)] [get_ports CtlToMem_port_dataIn(20)] [get_ports CtlToMem_port_dataIn(19)] [get_ports CtlToMem_port_dataIn(18)] [get_ports CtlToMem_port_dataIn(17)] [get_ports CtlToMem_port_dataIn(16)] [get_ports CtlToMem_port_dataIn(15)] [get_ports CtlToMem_port_dataIn(14)] [get_ports CtlToMem_port_dataIn(13)] [get_ports CtlToMem_port_dataIn(12)] [get_ports CtlToMem_port_dataIn(11)] [get_ports CtlToMem_port_dataIn(10)] [get_ports CtlToMem_port_dataIn(9)] [get_ports CtlToMem_port_dataIn(8)] [get_ports CtlToMem_port_dataIn(7)] [get_ports CtlToMem_port_dataIn(6)] [get_ports CtlToMem_port_dataIn(5)] [get_ports CtlToMem_port_dataIn(4)] [get_ports CtlToMem_port_dataIn(3)] [get_ports CtlToMem_port_dataIn(2)] [get_ports CtlToMem_port_dataIn(1)] [get_ports CtlToMem_port_dataIn(0)] [get_ports CtlToMem_port_mask(2)] [get_ports CtlToMem_port_mask(1)] [get_ports CtlToMem_port_mask(0)] [get_ports CtlToMem_port_req] [get_ports CtlToMem_port_notify]]
group_path -name REGIN  -from [list [get_ports rst] [get_ports MemToCtl_port(31)] [get_ports MemToCtl_port(30)] [get_ports MemToCtl_port(29)] [get_ports MemToCtl_port(28)] [get_ports MemToCtl_port(27)] [get_ports MemToCtl_port(26)] [get_ports MemToCtl_port(25)] [get_ports MemToCtl_port(24)] [get_ports MemToCtl_port(23)] [get_ports MemToCtl_port(22)] [get_ports MemToCtl_port(21)] [get_ports MemToCtl_port(20)] [get_ports MemToCtl_port(19)] [get_ports MemToCtl_port(18)] [get_ports MemToCtl_port(17)] [get_ports MemToCtl_port(16)] [get_ports MemToCtl_port(15)] [get_ports MemToCtl_port(14)] [get_ports MemToCtl_port(13)] [get_ports MemToCtl_port(12)] [get_ports MemToCtl_port(11)] [get_ports MemToCtl_port(10)] [get_ports MemToCtl_port(9)] [get_ports MemToCtl_port(8)] [get_ports MemToCtl_port(7)] [get_ports MemToCtl_port(6)] [get_ports MemToCtl_port(5)] [get_ports MemToCtl_port(4)] [get_ports MemToCtl_port(3)] [get_ports MemToCtl_port(2)] [get_ports MemToCtl_port(1)] [get_ports MemToCtl_port(0)] [get_ports MemToCtl_port_sync] [get_ports CtlToMem_port_sync]]
group_path -name REGOUT  -to [list [get_ports MemToCtl_port_notify] [get_ports CtlToMem_port_addrIn(31)] [get_ports CtlToMem_port_addrIn(30)] [get_ports CtlToMem_port_addrIn(29)] [get_ports CtlToMem_port_addrIn(28)] [get_ports CtlToMem_port_addrIn(27)] [get_ports CtlToMem_port_addrIn(26)] [get_ports CtlToMem_port_addrIn(25)] [get_ports CtlToMem_port_addrIn(24)] [get_ports CtlToMem_port_addrIn(23)] [get_ports CtlToMem_port_addrIn(22)] [get_ports CtlToMem_port_addrIn(21)] [get_ports CtlToMem_port_addrIn(20)] [get_ports CtlToMem_port_addrIn(19)] [get_ports CtlToMem_port_addrIn(18)] [get_ports CtlToMem_port_addrIn(17)] [get_ports CtlToMem_port_addrIn(16)] [get_ports CtlToMem_port_addrIn(15)] [get_ports CtlToMem_port_addrIn(14)] [get_ports CtlToMem_port_addrIn(13)] [get_ports CtlToMem_port_addrIn(12)] [get_ports CtlToMem_port_addrIn(11)] [get_ports CtlToMem_port_addrIn(10)] [get_ports CtlToMem_port_addrIn(9)] [get_ports CtlToMem_port_addrIn(8)] [get_ports CtlToMem_port_addrIn(7)] [get_ports CtlToMem_port_addrIn(6)] [get_ports CtlToMem_port_addrIn(5)] [get_ports CtlToMem_port_addrIn(4)] [get_ports CtlToMem_port_addrIn(3)] [get_ports CtlToMem_port_addrIn(2)] [get_ports CtlToMem_port_addrIn(1)] [get_ports CtlToMem_port_addrIn(0)] [get_ports CtlToMem_port_dataIn(31)] [get_ports CtlToMem_port_dataIn(30)] [get_ports CtlToMem_port_dataIn(29)] [get_ports CtlToMem_port_dataIn(28)] [get_ports CtlToMem_port_dataIn(27)] [get_ports CtlToMem_port_dataIn(26)] [get_ports CtlToMem_port_dataIn(25)] [get_ports CtlToMem_port_dataIn(24)] [get_ports CtlToMem_port_dataIn(23)] [get_ports CtlToMem_port_dataIn(22)] [get_ports CtlToMem_port_dataIn(21)] [get_ports CtlToMem_port_dataIn(20)] [get_ports CtlToMem_port_dataIn(19)] [get_ports CtlToMem_port_dataIn(18)] [get_ports CtlToMem_port_dataIn(17)] [get_ports CtlToMem_port_dataIn(16)] [get_ports CtlToMem_port_dataIn(15)] [get_ports CtlToMem_port_dataIn(14)] [get_ports CtlToMem_port_dataIn(13)] [get_ports CtlToMem_port_dataIn(12)] [get_ports CtlToMem_port_dataIn(11)] [get_ports CtlToMem_port_dataIn(10)] [get_ports CtlToMem_port_dataIn(9)] [get_ports CtlToMem_port_dataIn(8)] [get_ports CtlToMem_port_dataIn(7)] [get_ports CtlToMem_port_dataIn(6)] [get_ports CtlToMem_port_dataIn(5)] [get_ports CtlToMem_port_dataIn(4)] [get_ports CtlToMem_port_dataIn(3)] [get_ports CtlToMem_port_dataIn(2)] [get_ports CtlToMem_port_dataIn(1)] [get_ports CtlToMem_port_dataIn(0)] [get_ports CtlToMem_port_mask(2)] [get_ports CtlToMem_port_mask(1)] [get_ports CtlToMem_port_mask(0)] [get_ports CtlToMem_port_req] [get_ports CtlToMem_port_notify]]
set_false_path   -from [get_ports rst]  -to [get_clocks clk]
set_input_delay -clock clk  5  [get_ports clk]
set_input_delay -clock clk  5  [get_ports rst]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(31)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(30)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(29)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(28)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(27)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(26)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(25)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(24)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(23)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(22)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(21)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(20)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(19)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(18)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(17)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(16)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(15)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(14)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(13)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(12)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(11)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(10)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(9)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(8)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(7)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(6)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(5)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(4)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(3)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(2)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(1)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port(0)]
set_input_delay -clock clk  5  [get_ports MemToCtl_port_sync]
set_input_delay -clock clk  5  [get_ports CtlToMem_port_sync]
set_output_delay -clock clk  5  [get_ports MemToCtl_port_notify]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(31)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(30)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(29)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(28)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(27)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(26)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(25)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(24)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(23)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(22)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(21)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(20)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(19)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(18)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(17)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(16)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(15)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(14)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(13)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(12)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(11)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(10)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(9)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(8)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(7)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(6)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(5)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(4)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(3)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(2)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(1)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_addrIn(0)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(31)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(30)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(29)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(28)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(27)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(26)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(25)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(24)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(23)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(22)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(21)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(20)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(19)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(18)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(17)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(16)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(15)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(14)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(13)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(12)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(11)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(10)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(9)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(8)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(7)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(6)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(5)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(4)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(3)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(2)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(1)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_dataIn(0)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_mask(2)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_mask(1)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_mask(0)]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_req]
set_output_delay -clock clk  5  [get_ports CtlToMem_port_notify]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_RegsxRegsToCtl_port_contents2_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_RegsxRegsToCtl_port_contents2_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_RegsxRegsToCtl_port_contents2_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_RegsxRegsToCtl_port_contents2_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx1x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx1x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx1x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx1x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx2x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx2x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx2x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx2x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx3x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx3x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx3x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx3x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx4x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx4x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx4x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx4x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx5x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx5x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx5x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx5x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx6x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx6x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx6x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx6x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx7x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx7x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx7x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx7x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx8x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx8x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx8x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx8x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx9x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx9x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx9x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx9x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx10x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx10x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx10x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx10x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx11x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx11x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx11x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx11x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx12x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx12x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx12x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx12x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx13x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx13x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx13x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx13x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx14x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx14x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx14x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx14x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx15x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx15x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx15x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx15x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx16x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx16x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx16x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx16x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx17x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx17x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx17x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx17x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx18x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx18x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx18x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx18x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx19x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx19x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx19x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx19x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx20x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx20x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx20x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx20x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx21x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx21x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx21x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx21x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx22x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx22x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx22x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx22x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx23x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx23x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx23x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx23x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx24x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx24x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx24x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx24x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx25x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx25x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx25x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx25x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx26x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx26x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx26x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx26x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx27x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx27x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx27x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx27x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx28x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx28x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx28x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx28x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx29x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx29x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx29x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx29x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx30x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx30x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx30x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx30x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx31x/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_Regsxreg_file_regx31x/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx31x/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_Regsxreg_file_regx31x/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_imm_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_imm_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_imm_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_imm_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_rs2_addr_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_rs2_addr_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_rs2_addr_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_DecoderxDecToCtl_port_rs2_addr_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxsection_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxsection_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxsection_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxsection_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_alu_fun_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_alu_fun_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_alu_fun_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_alu_fun_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_op2_sel_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_op2_sel_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_op2_sel_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_data_signal_op2_sel_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_reg2_contents_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_reg2_contents_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_reg2_contents_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_reg2_contents_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_dst_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_dst_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_dst_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_dst_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_dst_data_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_dst_data_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_dst_data_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_dst_data_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_req_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_req_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_req_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_req_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_src2_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_src2_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_src2_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_data_signal_src2_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxRegsToCtl_data_signal_contents2_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxRegsToCtl_data_signal_contents2_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxRegsToCtl_data_signal_contents2_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxRegsToCtl_data_signal_contents2_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxDecToCtl_data_signal_rd_addr_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxDecToCtl_data_signal_rd_addr_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxDecToCtl_data_signal_rd_addr_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxDecToCtl_data_signal_rd_addr_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxMemToCtl_data_signal_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxMemToCtl_data_signal_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxMemToCtl_data_signal_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxMemToCtl_data_signal_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxmemoryAccess_signal_mask_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxmemoryAccess_signal_mask_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxmemoryAccess_signal_mask_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxmemoryAccess_signal_mask_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxpc_next_signal_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxpc_next_signal_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxpc_next_signal_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxpc_next_signal_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxpc_reg_signal_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxpc_reg_signal_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxpc_reg_signal_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxpc_reg_signal_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxwb_sel_signal_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxwb_sel_signal_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxwb_sel_signal_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxwb_sel_signal_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToMem_port_req_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToMem_port_req_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToMem_port_req_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToMem_port_req_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToDec_port_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToDec_port_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToDec_port_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToDec_port_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_src2_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_src2_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_src2_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToRegs_port_src2_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_op2_sel_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_op2_sel_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_op2_sel_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_CPathxCtlToALU_port_op2_sel_reg/main_gate]
set_clock_gating_check -rise -setup 0 [get_cells clk_gate_IF_ALUxALUtoCtl_port_reg/main_gate]
set_clock_gating_check -fall -setup 0 [get_cells clk_gate_IF_ALUxALUtoCtl_port_reg/main_gate]
set_clock_gating_check -rise -hold 0 [get_cells clk_gate_IF_ALUxALUtoCtl_port_reg/main_gate]
set_clock_gating_check -fall -hold 0 [get_cells clk_gate_IF_ALUxALUtoCtl_port_reg/main_gate]
