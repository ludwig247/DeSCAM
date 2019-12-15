-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro clk_sig : boolean := end macro;
macro master_input_sig_addr : signed := end macro;
macro master_input_sig_cyc : boolean := end macro;
macro master_input_sig_data : signed := end macro;
macro master_input_sig_stb : boolean := end macro;
macro master_input_sig_we : boolean := end macro;
macro master_output_sig_ack : boolean := end macro;
macro master_output_sig_data : signed := end macro;
macro master_output_sig_err : boolean := end macro;
macro slave_in0_sig_ack : boolean := end macro;
macro slave_in0_sig_data : signed := end macro;
macro slave_in0_sig_err : boolean := end macro;
macro slave_in1_sig_ack : boolean := end macro;
macro slave_in1_sig_data : signed := end macro;
macro slave_in1_sig_err : boolean := end macro;
macro slave_in2_sig_ack : boolean := end macro;
macro slave_in2_sig_data : signed := end macro;
macro slave_in2_sig_err : boolean := end macro;
macro slave_in3_sig_ack : boolean := end macro;
macro slave_in3_sig_data : signed := end macro;
macro slave_in3_sig_err : boolean := end macro;
macro slave_out0_sig_addr : signed := end macro;
macro slave_out0_sig_cyc : boolean := end macro;
macro slave_out0_sig_data : signed := end macro;
macro slave_out0_sig_stb : boolean := end macro;
macro slave_out0_sig_we : boolean := end macro;
macro slave_out1_sig_addr : signed := end macro;
macro slave_out1_sig_cyc : boolean := end macro;
macro slave_out1_sig_data : signed := end macro;
macro slave_out1_sig_stb : boolean := end macro;
macro slave_out1_sig_we : boolean := end macro;
macro slave_out2_sig_addr : signed := end macro;
macro slave_out2_sig_cyc : boolean := end macro;
macro slave_out2_sig_data : signed := end macro;
macro slave_out2_sig_stb : boolean := end macro;
macro slave_out2_sig_we : boolean := end macro;
macro slave_out3_sig_addr : signed := end macro;
macro slave_out3_sig_cyc : boolean := end macro;
macro slave_out3_sig_data : signed := end macro;
macro slave_out3_sig_stb : boolean := end macro;
macro slave_out3_sig_we : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro from_master_addr : signed := end macro;
macro from_master_cyc : boolean := end macro;
macro from_master_data : signed := end macro;
macro from_master_stb : boolean := end macro;
macro from_master_we : boolean := end macro;
macro nextphase : Phases := end macro;
macro slave_number : signed := end macro;
macro to_master_ack : boolean := end macro;
macro to_master_data : signed := end macro;
macro to_master_err : boolean := end macro;


-- STATES --
macro state_3 : boolean := true end macro;
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_3;
	 at t: from_master_addr = resize(0,32);
	 at t: from_master_cyc = false;
	 at t: from_master_data = resize(0,32);
	 at t: from_master_stb = false;
	 at t: from_master_we = false;
	 at t: master_output_sig_ack = false;
	 at t: master_output_sig_data = resize(0,32);
	 at t: master_output_sig_err = false;
	 at t: nextphase = IDLE;
	 at t: slave_number = resize(0,32);
	 at t: slave_out0_sig_addr = resize(0,32);
	 at t: slave_out0_sig_cyc = false;
	 at t: slave_out0_sig_data = resize(0,32);
	 at t: slave_out0_sig_stb = false;
	 at t: slave_out0_sig_we = false;
	 at t: slave_out1_sig_addr = resize(0,32);
	 at t: slave_out1_sig_cyc = false;
	 at t: slave_out1_sig_data = resize(0,32);
	 at t: slave_out1_sig_stb = false;
	 at t: slave_out1_sig_we = false;
	 at t: slave_out2_sig_addr = resize(0,32);
	 at t: slave_out2_sig_cyc = false;
	 at t: slave_out2_sig_data = resize(0,32);
	 at t: slave_out2_sig_stb = false;
	 at t: slave_out2_sig_we = false;
	 at t: slave_out3_sig_addr = resize(0,32);
	 at t: slave_out3_sig_cyc = false;
	 at t: slave_out3_sig_data = resize(0,32);
	 at t: slave_out3_sig_stb = false;
	 at t: slave_out3_sig_we = false;
	 at t: to_master_ack = false;
	 at t: to_master_data = resize(0,32);
	 at t: to_master_err = false;
end property;


property state_3_11 is
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
	at t: state_3;
	at t: master_input_sig_cyc;
	at t: master_input_sig_stb;
	at t: (master_input_sig_addr >= resize(0,32));
	at t: (master_input_sig_addr <= resize(7,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = TRANSMITTING;
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


property state_3_12 is
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
	at t: state_3;
	at t: master_input_sig_cyc;
	at t: master_input_sig_stb;
	at t: (master_input_sig_addr >= resize(8,32));
	at t: (master_input_sig_addr <= resize(15,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = TRANSMITTING;
	at t_end: slave_number = 1;
	at t_end: slave_out0_sig_addr = slave_out0_sig_addr_at_t;
	at t_end: slave_out0_sig_cyc = slave_out0_sig_cyc_at_t;
	at t_end: slave_out0_sig_data = slave_out0_sig_data_at_t;
	at t_end: slave_out0_sig_stb = slave_out0_sig_stb_at_t;
	at t_end: slave_out0_sig_we = slave_out0_sig_we_at_t;
	at t_end: slave_out1_sig_addr = (-8 + master_input_sig_addr_at_t)(31 downto 0);
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


property state_3_13 is
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
	at t: state_3;
	at t: master_input_sig_cyc;
	at t: master_input_sig_stb;
	at t: (master_input_sig_addr >= resize(16,32));
	at t: (master_input_sig_addr <= resize(23,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = TRANSMITTING;
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
	at t_end: slave_out2_sig_addr = (-16 + master_input_sig_addr_at_t)(31 downto 0);
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


property state_3_14 is
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
	at t: state_3;
	at t: master_input_sig_cyc;
	at t: master_input_sig_stb;
	at t: (master_input_sig_addr >= resize(24,32));
	at t: (master_input_sig_addr <= resize(31,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = TRANSMITTING;
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
	at t_end: slave_out3_sig_addr = (-24 + master_input_sig_addr_at_t)(31 downto 0);
	at t_end: slave_out3_sig_cyc = master_input_sig_cyc_at_t;
	at t_end: slave_out3_sig_data = master_input_sig_data_at_t;
	at t_end: slave_out3_sig_stb = master_input_sig_stb_at_t;
	at t_end: slave_out3_sig_we = master_input_sig_we_at_t;
	at t_end: to_master_ack = to_master_ack_at_t;
	at t_end: to_master_data = to_master_data_at_t;
	at t_end: to_master_err = to_master_err_at_t;
end property;


property state_3_15 is
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
	at t: state_3;
	at t: master_input_sig_cyc;
	at t: master_input_sig_stb;
	at t: not(((master_input_sig_addr >= resize(0,32)) and not((resize(8,32) <= master_input_sig_addr))));
	at t: not(((master_input_sig_addr >= resize(8,32)) and not((resize(16,32) <= master_input_sig_addr))));
	at t: not(((master_input_sig_addr >= resize(16,32)) and not((resize(24,32) <= master_input_sig_addr))));
	at t: not(((master_input_sig_addr >= resize(24,32)) and not((resize(32,32) <= master_input_sig_addr))));
prove:
	at t_end: state_2;
	at t_end: from_master_addr = master_input_sig_addr_at_t;
	at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	at t_end: from_master_data = master_input_sig_data_at_t;
	at t_end: from_master_stb = master_input_sig_stb_at_t;
	at t_end: from_master_we = master_input_sig_we_at_t;
	at t_end: master_output_sig_ack = true;
	at t_end: master_output_sig_data = 0;
	at t_end: master_output_sig_err = false;
	at t_end: nextphase = DONE;
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


property state_3_16 is
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
	nextphase_at_t = nextphase@t,
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
	at t: state_3;
	at t: not((master_input_sig_cyc and master_input_sig_stb));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_3;
	at t_end: from_master_addr = master_input_sig_addr_at_t;
	at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	at t_end: from_master_data = master_input_sig_data_at_t;
	at t_end: from_master_stb = master_input_sig_stb_at_t;
	at t_end: from_master_we = master_input_sig_we_at_t;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_1;
	at t: slave_in0_sig_ack;
	at t: (slave_number = resize(0,32));
prove:
	at t_end: state_2;
	at t_end: from_master_addr = from_master_addr_at_t;
	at t_end: from_master_cyc = from_master_cyc_at_t;
	at t_end: from_master_data = from_master_data_at_t;
	at t_end: from_master_stb = from_master_stb_at_t;
	at t_end: from_master_we = from_master_we_at_t;
	at t_end: master_output_sig_ack = slave_in0_sig_ack_at_t;
	at t_end: master_output_sig_data = slave_in0_sig_data_at_t;
	at t_end: master_output_sig_err = slave_in0_sig_err_at_t;
	at t_end: nextphase = DONE;
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


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	nextphase_at_t = nextphase@t,
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
	at t: state_1;
	at t: not(slave_in0_sig_ack);
	at t: (nextphase = TRANSMITTING);
	at t: (slave_number = resize(0,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_1;
	at t: slave_in1_sig_ack;
	at t: (slave_number = resize(1,32));
prove:
	at t_end: state_2;
	at t_end: from_master_addr = from_master_addr_at_t;
	at t_end: from_master_cyc = from_master_cyc_at_t;
	at t_end: from_master_data = from_master_data_at_t;
	at t_end: from_master_stb = from_master_stb_at_t;
	at t_end: from_master_we = from_master_we_at_t;
	at t_end: master_output_sig_ack = slave_in1_sig_ack_at_t;
	at t_end: master_output_sig_data = slave_in1_sig_data_at_t;
	at t_end: master_output_sig_err = slave_in1_sig_err_at_t;
	at t_end: nextphase = DONE;
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


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	nextphase_at_t = nextphase@t,
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
	at t: state_1;
	at t: not(slave_in1_sig_ack);
	at t: (nextphase = TRANSMITTING);
	at t: (slave_number = resize(1,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_1;
	at t: slave_in2_sig_ack;
	at t: (slave_number = resize(2,32));
prove:
	at t_end: state_2;
	at t_end: from_master_addr = from_master_addr_at_t;
	at t_end: from_master_cyc = from_master_cyc_at_t;
	at t_end: from_master_data = from_master_data_at_t;
	at t_end: from_master_stb = from_master_stb_at_t;
	at t_end: from_master_we = from_master_we_at_t;
	at t_end: master_output_sig_ack = slave_in2_sig_ack_at_t;
	at t_end: master_output_sig_data = slave_in2_sig_data_at_t;
	at t_end: master_output_sig_err = slave_in2_sig_err_at_t;
	at t_end: nextphase = DONE;
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


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	nextphase_at_t = nextphase@t,
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
	at t: state_1;
	at t: not(slave_in2_sig_ack);
	at t: (nextphase = TRANSMITTING);
	at t: (slave_number = resize(2,32));
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_1;
	at t: not((slave_number = resize(0,32)));
	at t: not((slave_number = resize(1,32)));
	at t: not((slave_number = resize(2,32)));
	at t: slave_in3_sig_ack;
prove:
	at t_end: state_2;
	at t_end: from_master_addr = from_master_addr_at_t;
	at t_end: from_master_cyc = from_master_cyc_at_t;
	at t_end: from_master_data = from_master_data_at_t;
	at t_end: from_master_stb = from_master_stb_at_t;
	at t_end: from_master_we = from_master_we_at_t;
	at t_end: master_output_sig_ack = slave_in3_sig_ack_at_t;
	at t_end: master_output_sig_data = slave_in3_sig_data_at_t;
	at t_end: master_output_sig_err = slave_in3_sig_err_at_t;
	at t_end: nextphase = DONE;
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


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_output_sig_ack_at_t = master_output_sig_ack@t,
	master_output_sig_data_at_t = master_output_sig_data@t,
	master_output_sig_err_at_t = master_output_sig_err@t,
	nextphase_at_t = nextphase@t,
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
	at t: state_1;
	at t: not((slave_number = resize(0,32)));
	at t: not((slave_number = resize(1,32)));
	at t: not((slave_number = resize(2,32)));
	at t: not(slave_in3_sig_ack);
	at t: (nextphase = TRANSMITTING);
prove:
	at t_end: state_1;
	at t_end: from_master_addr = 0;
	at t_end: from_master_cyc = false;
	at t_end: from_master_data = 0;
	at t_end: from_master_stb = false;
	at t_end: from_master_we = false;
	at t_end: master_output_sig_ack = master_output_sig_ack_at_t;
	at t_end: master_output_sig_data = master_output_sig_data_at_t;
	at t_end: master_output_sig_err = master_output_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


property state_2_9 is
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
	at t: state_2;
	at t: not(master_input_sig_cyc);
	at t: not(master_input_sig_stb);
prove:
	at t_end: state_3;
	at t_end: from_master_addr = master_input_sig_addr_at_t;
	at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	at t_end: from_master_data = master_input_sig_data_at_t;
	at t_end: from_master_stb = master_input_sig_stb_at_t;
	at t_end: from_master_we = master_input_sig_we_at_t;
	at t_end: master_output_sig_ack = false;
	at t_end: master_output_sig_data = 0;
	at t_end: master_output_sig_err = false;
	at t_end: nextphase = IDLE;
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


property state_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_input_sig_addr_at_t = master_input_sig_addr@t,
	master_input_sig_cyc_at_t = master_input_sig_cyc@t,
	master_input_sig_data_at_t = master_input_sig_data@t,
	master_input_sig_stb_at_t = master_input_sig_stb@t,
	master_input_sig_we_at_t = master_input_sig_we@t,
	nextphase_at_t = nextphase@t,
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
	at t: state_2;
	at t: not((not(master_input_sig_cyc) and not(master_input_sig_stb)));
	at t: (nextphase = DONE);
prove:
	at t_end: state_2;
	at t_end: from_master_addr = master_input_sig_addr_at_t;
	at t_end: from_master_cyc = master_input_sig_cyc_at_t;
	at t_end: from_master_data = master_input_sig_data_at_t;
	at t_end: from_master_stb = master_input_sig_stb_at_t;
	at t_end: from_master_we = master_input_sig_we_at_t;
	at t_end: master_output_sig_ack = to_master_ack_at_t;
	at t_end: master_output_sig_data = to_master_data_at_t;
	at t_end: master_output_sig_err = to_master_err_at_t;
	at t_end: nextphase = nextphase_at_t;
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


