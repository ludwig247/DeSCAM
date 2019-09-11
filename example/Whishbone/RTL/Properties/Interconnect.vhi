
-- DP SIGNALS --
macro master_input_sig_addr : int := master_in.addr end macro;
macro master_input_sig_cyc : bool := master_in.cyc end macro;
macro master_input_sig_data : int := master_in.data end macro;
macro master_input_sig_stb : bool := master_in.stb end macro;
macro master_input_sig_we : bool := master_in.we end macro;

macro master_output_sig_ack : bool := master_out.ack end macro;
macro master_output_sig_data : int := master_out.data end macro;
macro master_output_sig_err : bool := master_out.err end macro;

macro slave_in0_sig_ack : bool := slave_in0.ack end macro;
macro slave_in0_sig_data : int := slave_in0.data end macro;
macro slave_in0_sig_err : bool := slave_in0.err end macro;
macro slave_out0_sig_addr : int := slave_out0.addr end macro;
macro slave_out0_sig_cyc : bool := slave_out0.cyc end macro;
macro slave_out0_sig_data : int := slave_out0.data end macro;
macro slave_out0_sig_stb : bool := slave_out0.stb end macro;
macro slave_out0_sig_we : bool := slave_out0.we end macro;

macro slave_in1_sig_ack : bool := slave_in1.ack end macro;
macro slave_in1_sig_data : int := slave_in1.data end macro;
macro slave_in1_sig_err : bool := slave_in1.err end macro;
macro slave_out1_sig_addr : int := slave_out1.addr end macro;
macro slave_out1_sig_cyc : bool := slave_out1.cyc end macro;
macro slave_out1_sig_data : int := slave_out1.data end macro;
macro slave_out1_sig_stb : bool := slave_out1.stb end macro;
macro slave_out1_sig_we : bool := slave_out1.we end macro;

macro slave_in2_sig_ack : bool := slave_in2.ack end macro;
macro slave_in2_sig_data : int := slave_in2.data end macro;
macro slave_in2_sig_err : bool := slave_in2.err end macro;
macro slave_out2_sig_addr : int := slave_out2.addr end macro;
macro slave_out2_sig_cyc : bool := slave_out2.cyc end macro;
macro slave_out2_sig_data : int := slave_out2.data end macro;
macro slave_out2_sig_stb : bool := slave_out2.stb end macro;
macro slave_out2_sig_we : bool := slave_out2.we end macro;

macro slave_in3_sig_ack : bool := slave_in3.ack end macro;
macro slave_in3_sig_data : int := slave_in3.data end macro;
macro slave_in3_sig_err : bool := slave_in3.err end macro;
macro slave_out3_sig_addr : int := slave_out3.addr end macro;
macro slave_out3_sig_cyc : bool := slave_out3.cyc end macro;
macro slave_out3_sig_data : int := slave_out3.data end macro;
macro slave_out3_sig_stb : bool := slave_out3.stb end macro;
macro slave_out3_sig_we : bool := slave_out3.we end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro from_master_addr : int := from_master_signal.addr end macro;
macro from_master_cyc : bool := from_master_signal.cyc end macro;
macro from_master_data : int := from_master_signal.data end macro;
macro from_master_stb : bool := from_master_signal.stb end macro;
macro from_master_we : bool := from_master_signal.we end macro;
macro to_master_ack : bool := to_master_signal.ack end macro;
macro to_master_data : int := to_master_signal.data end macro;
macro to_master_err : bool := to_master_signal.err end macro;
macro slave_number : int := slave_number_signal end macro;



-- STATES --
macro DONE_0 : boolean := section = DONE and helper = 0 end macro;
macro IDLE_1 : boolean := section = IDLE end macro;
macro TRANSMITTING_2 : boolean := section = TRANSMITTING and helper = 0 end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_1;
	 at t: from_master_addr = 0;
	 at t: from_master_cyc = false;
	 at t: from_master_data = 0;
	 at t: from_master_stb = false;
	 at t: from_master_we = false;
	 at t: master_output_sig_ack = false;
	 at t: master_output_sig_data = 0;
	 at t: master_output_sig_err = false;
	 at t: slave_number = 0;
	 at t: slave_out0_sig_addr = 0;
	 at t: slave_out0_sig_cyc = false;
	 at t: slave_out0_sig_data = 0;
	 at t: slave_out0_sig_stb = false;
	 at t: slave_out0_sig_we = false;
	 at t: slave_out1_sig_addr = 0;
	 at t: slave_out1_sig_cyc = false;
	 at t: slave_out1_sig_data = 0;
	 at t: slave_out1_sig_stb = false;
	 at t: slave_out1_sig_we = false;
	 at t: slave_out2_sig_addr = 0;
	 at t: slave_out2_sig_cyc = false;
	 at t: slave_out2_sig_data = 0;
	 at t: slave_out2_sig_stb = false;
	 at t: slave_out2_sig_we = false;
	 at t: slave_out3_sig_addr = 0;
	 at t: slave_out3_sig_cyc = false;
	 at t: slave_out3_sig_data = 0;
	 at t: slave_out3_sig_stb = false;
	 at t: slave_out3_sig_we = false;
	 at t: to_master_ack = false;
	 at t: to_master_data = 0;
	 at t: to_master_err = false;
end property;


property DONE_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	slave_number_at_t = slave_number@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: DONE_0;
	 at t: not((not(master_input_sig_cyc) and not(master_input_sig_stb)));
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = master_input_sig_addr_at_t;
	 at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	 at t_end: from_master_data = master_input_sig_data_at_t;
	 at t_end: from_master_stb = master_input_sig_stb_at_t;
	 at t_end: from_master_we = master_input_sig_we_at_t;
	 at t_end: master_output_sig_ack = to_master_ack_at_t;
	 at t_end: master_output_sig_data = to_master_data_at_t;
	 at t_end: master_output_sig_err = to_master_err_at_t;
	 at t_end: slave_number = slave_number_at_t;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property DONE_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+3;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	slave_number_at_t = slave_number@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: DONE_0;
	 at t: not(master_input_sig_cyc);
	 at t: not(master_input_sig_stb);
prove:
	 at t_end: IDLE_1;
	 at t_end: from_master_addr = master_input_sig_addr_at_t;
	 at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	 at t_end: from_master_data = master_input_sig_data_at_t;
	 at t_end: from_master_stb = master_input_sig_stb_at_t;
	 at t_end: from_master_we = master_input_sig_we_at_t;
	 at t_end: master_output_sig_ack = false;
	 at t_end: master_output_sig_data = 0;
	 at t_end: master_output_sig_err = false;
	 at t_end: slave_number = slave_number_at_t;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = false;
	 at t_end: to_master_data = 0;
	 at t_end: to_master_err = false;
end property;

property IDLE_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	slave_number_at_t = slave_number@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: IDLE_1;
	 at t: master_input_sig_cyc;
	 at t: master_input_sig_stb;
	 at t: not(((master_input_sig_addr >= 0) and not((8 <= master_input_sig_addr))));
	 at t: not(((master_input_sig_addr >= 8) and not((16 <= master_input_sig_addr))));
	 at t: not(((master_input_sig_addr >= 16) and not((24 <= master_input_sig_addr))));
	 at t: not(((master_input_sig_addr >= 24) and not((32 <= master_input_sig_addr))));
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = master_input_sig_addr_at_t;
	 at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	 at t_end: from_master_data = master_input_sig_data_at_t;
	 at t_end: from_master_stb = master_input_sig_stb_at_t;
	 at t_end: from_master_we = master_input_sig_we_at_t;
	 at t_end: master_output_sig_ack = true;
	 at t_end: master_output_sig_data = 0;
	 at t_end: master_output_sig_err = false;
	 at t_end: slave_number = slave_number_at_t;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = true;
	 at t_end: to_master_data = 0;
	 at t_end: to_master_err = false;
end property;

property IDLE_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_number_at_t = slave_number@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: IDLE_1;
	 at t: not((master_input_sig_cyc and master_input_sig_stb));
prove:
	 at t_end: IDLE_1;
	 at t_end: from_master_addr = master_input_sig_addr_at_t;
	 at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	 at t_end: from_master_data = master_input_sig_data_at_t;
	 at t_end: from_master_stb = master_input_sig_stb_at_t;
	 at t_end: from_master_we = master_input_sig_we_at_t;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = slave_number_at_t;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property IDLE_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: IDLE_1;
	 at t: master_input_sig_cyc;
	 at t: master_input_sig_stb;
	 at t: (master_input_sig_addr >= 0);
	 at t: (master_input_sig_addr <= 7);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 0;
	 at t_end: slave_out0_sig_addr = master_input_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = master_input_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = master_input_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = master_input_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = master_input_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property IDLE_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: IDLE_1;
	 at t: master_input_sig_cyc;
	 at t: master_input_sig_stb;
	 at t: (master_input_sig_addr >= 8);
	 at t: (master_input_sig_addr <= 15);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 1;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = (-8 + master_input_sig_addr_at_t);
	 at t_end: slave_out1_sig_cyc = master_input_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = master_input_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = master_input_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = master_input_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property IDLE_1_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: IDLE_1;
	 at t: master_input_sig_cyc;
	 at t: master_input_sig_stb;
	 at t: (master_input_sig_addr >= 16);
	 at t: (master_input_sig_addr <= 23);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 2;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = (-16 + master_input_sig_addr_at_t);
	 at t_end: slave_out2_sig_cyc = master_input_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = master_input_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = master_input_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = master_input_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property IDLE_1_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	to_master_ack_at_t = to_master_ack@t,
	to_master_data_at_t = to_master_data@t,
	to_master_err_at_t = to_master_err@t;
assume:
	 at t: IDLE_1;
	 at t: master_input_sig_cyc;
	 at t: master_input_sig_stb;
	 at t: (master_input_sig_addr >= 24);
	 at t: (master_input_sig_addr <= 31);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 3;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = (-24 + master_input_sig_addr_at_t);
	 at t_end: slave_out3_sig_cyc = master_input_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = master_input_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = master_input_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = master_input_sig_we_at_t;
	 at t_end: to_master_ack = to_master_ack_at_t;
	 at t_end: to_master_data = to_master_data_at_t;
	 at t_end: to_master_err = to_master_err_at_t;
end property;

property TRANSMITTING_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	from_master_addr_at_t = from_master_addr@t,
	from_master_cyc_at_t = from_master_cyc@t,
	from_master_data_at_t = from_master_data@t,
	from_master_stb_at_t = from_master_stb@t,
	from_master_we_at_t = from_master_we@t,
	slave_in0_sig_ack_at_t = slave_in0_sig_ack@t,
	slave_in0_sig_data_at_t = slave_in0_sig_data@t,
	slave_in0_sig_err_at_t = slave_in0_sig_err@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: slave_in0_sig_ack;
	 at t: (slave_number = 0);
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = from_master_addr_at_t;
	 at t_end: from_master_cyc = from_master_cyc_at_t;
	 at t_end: from_master_data = from_master_data_at_t;
	 at t_end: from_master_stb = from_master_stb_at_t;
	 at t_end: from_master_we = from_master_we_at_t;
	 at t_end: master_output_sig_ack = slave_in0_sig_ack_at_t;
	 at t_end: master_output_sig_data = slave_in0_sig_data_at_t;
	 at t_end: master_output_sig_err = slave_in0_sig_err_at_t;
	 at t_end: slave_number = 0;
	 at t_end: slave_out0_sig_addr = from_master_addr_at_t;
	 at t_end: slave_out0_sig_cyc = from_master_cyc_at_t;
	 at t_end: slave_out0_sig_data = from_master_data_at_t;
	 at t_end: slave_out0_sig_stb = from_master_stb_at_t;
	 at t_end: slave_out0_sig_we = from_master_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in0_sig_ack_at_t;
	 at t_end: to_master_data = slave_in0_sig_data_at_t;
	 at t_end: to_master_err = slave_in0_sig_err_at_t;
end property;

property TRANSMITTING_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	from_master_addr_at_t = from_master_addr@t,
	from_master_cyc_at_t = from_master_cyc@t,
	from_master_data_at_t = from_master_data@t,
	from_master_stb_at_t = from_master_stb@t,
	from_master_we_at_t = from_master_we@t,
	slave_in1_sig_ack_at_t = slave_in1_sig_ack@t,
	slave_in1_sig_data_at_t = slave_in1_sig_data@t,
	slave_in1_sig_err_at_t = slave_in1_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: slave_in1_sig_ack;
	 at t: (slave_number = 1);
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = from_master_addr_at_t;
	 at t_end: from_master_cyc = from_master_cyc_at_t;
	 at t_end: from_master_data = from_master_data_at_t;
	 at t_end: from_master_stb = from_master_stb_at_t;
	 at t_end: from_master_we = from_master_we_at_t;
	 at t_end: master_output_sig_ack = slave_in1_sig_ack_at_t;
	 at t_end: master_output_sig_data = slave_in1_sig_data_at_t;
	 at t_end: master_output_sig_err = slave_in1_sig_err_at_t;
	 at t_end: slave_number = 1;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = from_master_addr_at_t;
	 at t_end: slave_out1_sig_cyc = from_master_cyc_at_t;
	 at t_end: slave_out1_sig_data = from_master_data_at_t;
	 at t_end: slave_out1_sig_stb = from_master_stb_at_t;
	 at t_end: slave_out1_sig_we = from_master_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in1_sig_ack_at_t;
	 at t_end: to_master_data = slave_in1_sig_data_at_t;
	 at t_end: to_master_err = slave_in1_sig_err_at_t;
end property;

property TRANSMITTING_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	from_master_addr_at_t = from_master_addr@t,
	from_master_cyc_at_t = from_master_cyc@t,
	from_master_data_at_t = from_master_data@t,
	from_master_stb_at_t = from_master_stb@t,
	from_master_we_at_t = from_master_we@t,
	slave_in2_sig_ack_at_t = slave_in2_sig_ack@t,
	slave_in2_sig_data_at_t = slave_in2_sig_data@t,
	slave_in2_sig_err_at_t = slave_in2_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: slave_in2_sig_ack;
	 at t: (slave_number = 2);
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = from_master_addr_at_t;
	 at t_end: from_master_cyc = from_master_cyc_at_t;
	 at t_end: from_master_data = from_master_data_at_t;
	 at t_end: from_master_stb = from_master_stb_at_t;
	 at t_end: from_master_we = from_master_we_at_t;
	 at t_end: master_output_sig_ack = slave_in2_sig_ack_at_t;
	 at t_end: master_output_sig_data = slave_in2_sig_data_at_t;
	 at t_end: master_output_sig_err = slave_in2_sig_err_at_t;
	 at t_end: slave_number = 2;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = from_master_addr_at_t;
	 at t_end: slave_out2_sig_cyc = from_master_cyc_at_t;
	 at t_end: slave_out2_sig_data = from_master_data_at_t;
	 at t_end: slave_out2_sig_stb = from_master_stb_at_t;
	 at t_end: slave_out2_sig_we = from_master_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in2_sig_ack_at_t;
	 at t_end: to_master_data = slave_in2_sig_data_at_t;
	 at t_end: to_master_err = slave_in2_sig_err_at_t;
end property;

property TRANSMITTING_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	from_master_addr_at_t = from_master_addr@t,
	from_master_cyc_at_t = from_master_cyc@t,
	from_master_data_at_t = from_master_data@t,
	from_master_stb_at_t = from_master_stb@t,
	from_master_we_at_t = from_master_we@t,
	slave_in3_sig_ack_at_t = slave_in3_sig_ack@t,
	slave_in3_sig_data_at_t = slave_in3_sig_data@t,
	slave_in3_sig_err_at_t = slave_in3_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: not((slave_number = 0));
	 at t: not((slave_number = 1));
	 at t: not((slave_number = 2));
	 at t: slave_in3_sig_ack;
prove:
	 at t_end: DONE_0;
	 at t_end: from_master_addr = from_master_addr_at_t;
	 at t_end: from_master_cyc = from_master_cyc_at_t;
	 at t_end: from_master_data = from_master_data_at_t;
	 at t_end: from_master_stb = from_master_stb_at_t;
	 at t_end: from_master_we = from_master_we_at_t;
	 at t_end: master_output_sig_ack = slave_in3_sig_ack_at_t;
	 at t_end: master_output_sig_data = slave_in3_sig_data_at_t;
	 at t_end: master_output_sig_err = slave_in3_sig_err_at_t;
	 at t_end: slave_number = 3;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = from_master_addr_at_t;
	 at t_end: slave_out3_sig_cyc = from_master_cyc_at_t;
	 at t_end: slave_out3_sig_data = from_master_data_at_t;
	 at t_end: slave_out3_sig_stb = from_master_stb_at_t;
	 at t_end: slave_out3_sig_we = from_master_we_at_t;
	 at t_end: to_master_ack = slave_in3_sig_ack_at_t;
	 at t_end: to_master_data = slave_in3_sig_data_at_t;
	 at t_end: to_master_err = slave_in3_sig_err_at_t;
end property;

property TRANSMITTING_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_in0_sig_ack_at_t = slave_in0_sig_ack@t,
	slave_in0_sig_data_at_t = slave_in0_sig_data@t,
	slave_in0_sig_err_at_t = slave_in0_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: not(slave_in0_sig_ack);
	 at t: (slave_number = 0);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 0;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in0_sig_ack_at_t;
	 at t_end: to_master_data = slave_in0_sig_data_at_t;
	 at t_end: to_master_err = slave_in0_sig_err_at_t;
end property;

property TRANSMITTING_2_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_in1_sig_ack_at_t = slave_in1_sig_ack@t,
	slave_in1_sig_data_at_t = slave_in1_sig_data@t,
	slave_in1_sig_err_at_t = slave_in1_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: not(slave_in1_sig_ack);
	 at t: (slave_number = 1);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 1;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in1_sig_ack_at_t;
	 at t_end: to_master_data = slave_in1_sig_data_at_t;
	 at t_end: to_master_err = slave_in1_sig_err_at_t;
end property;

property TRANSMITTING_2_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_in2_sig_ack_at_t = slave_in2_sig_ack@t,
	slave_in2_sig_data_at_t = slave_in2_sig_data@t,
	slave_in2_sig_err_at_t = slave_in2_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: not(slave_in2_sig_ack);
	 at t: (slave_number = 2);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 2;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in2_sig_ack_at_t;
	 at t_end: to_master_data = slave_in2_sig_data_at_t;
	 at t_end: to_master_err = slave_in2_sig_err_at_t;
end property;

property TRANSMITTING_2_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	slave_in3_sig_ack_at_t = slave_in3_sig_ack@t,
	slave_in3_sig_data_at_t = slave_in3_sig_data@t,
	slave_in3_sig_err_at_t = slave_in3_sig_err@t,
	slave_out0_sig_addr_at_t = slave_out0_sig_addr@t,
	slave_out0_sig_cyc_at_t = slave_out0_sig_cyc@t,
	slave_out0_sig_data_at_t = slave_out0_sig_data@t,
	slave_out0_sig_stb_at_t = slave_out0_sig_stb@t,
	slave_out0_sig_we_at_t = slave_out0_sig_we@t,
	slave_out1_sig_addr_at_t = slave_out1_sig_addr@t,
	slave_out1_sig_cyc_at_t = slave_out1_sig_cyc@t,
	slave_out1_sig_data_at_t = slave_out1_sig_data@t,
	slave_out1_sig_stb_at_t = slave_out1_sig_stb@t,
	slave_out1_sig_we_at_t = slave_out1_sig_we@t,
	slave_out2_sig_addr_at_t = slave_out2_sig_addr@t,
	slave_out2_sig_cyc_at_t = slave_out2_sig_cyc@t,
	slave_out2_sig_data_at_t = slave_out2_sig_data@t,
	slave_out2_sig_stb_at_t = slave_out2_sig_stb@t,
	slave_out2_sig_we_at_t = slave_out2_sig_we@t,
	slave_out3_sig_addr_at_t = slave_out3_sig_addr@t,
	slave_out3_sig_cyc_at_t = slave_out3_sig_cyc@t,
	slave_out3_sig_data_at_t = slave_out3_sig_data@t,
	slave_out3_sig_stb_at_t = slave_out3_sig_stb@t,
	slave_out3_sig_we_at_t = slave_out3_sig_we@t;
assume:
	 at t: TRANSMITTING_2;
	 at t: not((slave_number = 0));
	 at t: not((slave_number = 1));
	 at t: not((slave_number = 2));
	 at t: not(slave_in3_sig_ack);
prove:
	 at t_end: TRANSMITTING_2;
	 at t_end: from_master_addr = 0;
	 at t_end: from_master_cyc = false;
	 at t_end: from_master_data = 0;
	 at t_end: from_master_stb = false;
	 at t_end: from_master_we = false;
	 at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	 at t_end: master_output_sig_data = master_output_sig_data_at_t;
	 at t_end: master_output_sig_err = master_output_sig_err_at_t;
	 at t_end: slave_number = 3;
	 at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	 at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	 at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	 at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	 at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	 at t_end: slave_out1_sig_addr = slave_out1_sig_addr_at_t;
	 at t_end: slave_out1_sig_cyc = slave_out1_sig_cyc_at_t;
	 at t_end: slave_out1_sig_data = slave_out1_sig_data_at_t;
	 at t_end: slave_out1_sig_stb = slave_out1_sig_stb_at_t;
	 at t_end: slave_out1_sig_we = slave_out1_sig_we_at_t;
	 at t_end: slave_out2_sig_addr = slave_out2_sig_addr_at_t;
	 at t_end: slave_out2_sig_cyc = slave_out2_sig_cyc_at_t;
	 at t_end: slave_out2_sig_data = slave_out2_sig_data_at_t;
	 at t_end: slave_out2_sig_stb = slave_out2_sig_stb_at_t;
	 at t_end: slave_out2_sig_we = slave_out2_sig_we_at_t;
	 at t_end: slave_out3_sig_addr = slave_out3_sig_addr_at_t;
	 at t_end: slave_out3_sig_cyc = slave_out3_sig_cyc_at_t;
	 at t_end: slave_out3_sig_data = slave_out3_sig_data_at_t;
	 at t_end: slave_out3_sig_stb = slave_out3_sig_stb_at_t;
	 at t_end: slave_out3_sig_we = slave_out3_sig_we_at_t;
	 at t_end: to_master_ack = slave_in3_sig_ack_at_t;
	 at t_end: to_master_data = slave_in3_sig_data_at_t;
	 at t_end: to_master_err = slave_in3_sig_err_at_t;
end property;