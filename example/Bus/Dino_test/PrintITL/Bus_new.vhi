-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: req_trans_type = SINGLE_READ;
	 at t: resp_ack = OK;
	 at t: resp_data = resize(0,32);
	 at t: master_in_notify = true;
	 at t: master_out_notify = false;
	 at t: slave_in0_notify = false;
	 at t: slave_in1_notify = false;
	 at t: slave_in2_notify = false;
	 at t: slave_in3_notify = false;
	 at t: slave_out0_notify = false;
	 at t: slave_out1_notify = false;
	 at t: slave_out2_notify = false;
	 at t: slave_out3_notify = false;
end property;


property cycle_0 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_2 = t+1,
	t_state_3 = t_state_2+1,
	t_state_4 = t_state_3+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in0_sig_ack_at_t_state_3 = slave_in0_sig_ack@t_state_3;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(0,32));
	at t_state_1: (master_in_sig_addr <= resize(7,32));
	at t_state_2: state_2;
	at t_state_2: slave_out0_sync;
	at t_state_3: state_3;
	at t_state_3: slave_in0_sync;
	at t_state_3: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_2: state_2;
	at t_state_2: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_2: slave_out0_sig_addr = master_in_sig_addr_at_t_state_1;
	at t_state_2: slave_out0_sig_data = 0;
	at t_state_2: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_3: state_3;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_1 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_2 = t+1,
	t_state_3 = t_state_2+1,
	t_state_4 = t_state_3+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in0_sig_ack_at_t_state_3 = slave_in0_sig_ack@t_state_3,
	slave_in0_sig_data_at_t_state_3 = slave_in0_sig_data@t_state_3;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(0,32));
	at t_state_1: (master_in_sig_addr <= resize(7,32));
	at t_state_2: state_2;
	at t_state_2: slave_out0_sync;
	at t_state_3: state_3;
	at t_state_3: slave_in0_sync;
	at t_state_3: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_2: state_2;
	at t_state_2: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_2: slave_out0_sig_addr = master_in_sig_addr_at_t_state_1;
	at t_state_2: slave_out0_sig_data = 0;
	at t_state_2: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_3: state_3;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: master_out_sig_data = slave_in0_sig_data_at_t_state_3;
	at t_state_4: resp_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: resp_data = slave_in0_sig_data_at_t_state_3;
	at t_end: state_1;
end property;


property cycle_10 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_2 = t+1,
	t_state_3 = t_state_2+1,
	t_state_4 = t_state_3+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in0_sig_ack_at_t_state_3 = slave_in0_sig_ack@t_state_3,
	slave_in0_sig_data_at_t_state_3 = slave_in0_sig_data@t_state_3;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(0,32));
	at t_state_1: (master_in_sig_addr <= resize(7,32));
	at t_state_2: state_2;
	at t_state_2: slave_out0_sync;
	at t_state_3: state_3;
	at t_state_3: slave_in0_sync;
	at t_state_3: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_2: state_2;
	at t_state_2: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_2: slave_out0_sig_addr = master_in_sig_addr_at_t_state_1;
	at t_state_2: slave_out0_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_2: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_3: state_3;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: master_out_sig_data = slave_in0_sig_data_at_t_state_3;
	at t_state_4: resp_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: resp_data = slave_in0_sig_data_at_t_state_3;
	at t_end: state_1;
end property;


property cycle_11 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_5 = t+1,
	t_state_6 = t_state_5+1,
	t_state_4 = t_state_6+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in1_sig_ack_at_t_state_6 = slave_in1_sig_ack@t_state_6;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(8,32));
	at t_state_1: (master_in_sig_addr <= resize(15,32));
	at t_state_5: state_5;
	at t_state_5: slave_out1_sync;
	at t_state_6: state_6;
	at t_state_6: slave_in1_sync;
	at t_state_6: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_5: state_5;
	at t_state_5: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_5: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_5: slave_out1_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_5: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_6: state_6;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_12 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_5 = t+1,
	t_state_6 = t_state_5+1,
	t_state_4 = t_state_6+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in1_sig_ack_at_t_state_6 = slave_in1_sig_ack@t_state_6,
	slave_in1_sig_data_at_t_state_6 = slave_in1_sig_data@t_state_6;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(8,32));
	at t_state_1: (master_in_sig_addr <= resize(15,32));
	at t_state_5: state_5;
	at t_state_5: slave_out1_sync;
	at t_state_6: state_6;
	at t_state_6: slave_in1_sync;
	at t_state_6: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_5: state_5;
	at t_state_5: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_5: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_5: slave_out1_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_5: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_6: state_6;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: master_out_sig_data = slave_in1_sig_data_at_t_state_6;
	at t_state_4: resp_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: resp_data = slave_in1_sig_data_at_t_state_6;
	at t_end: state_1;
end property;


property cycle_13 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t+1,
	t_state_8 = t_state_7+1,
	t_state_4 = t_state_8+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in2_sig_ack_at_t_state_8 = slave_in2_sig_ack@t_state_8;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(16,32));
	at t_state_1: (master_in_sig_addr <= resize(23,32));
	at t_state_7: state_7;
	at t_state_7: slave_out2_sync;
	at t_state_8: state_8;
	at t_state_8: slave_in2_sync;
	at t_state_8: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_7: state_7;
	at t_state_7: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_7: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_7: slave_out2_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_7: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_8: state_8;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_14 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t+1,
	t_state_8 = t_state_7+1,
	t_state_4 = t_state_8+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in2_sig_ack_at_t_state_8 = slave_in2_sig_ack@t_state_8,
	slave_in2_sig_data_at_t_state_8 = slave_in2_sig_data@t_state_8;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(16,32));
	at t_state_1: (master_in_sig_addr <= resize(23,32));
	at t_state_7: state_7;
	at t_state_7: slave_out2_sync;
	at t_state_8: state_8;
	at t_state_8: slave_in2_sync;
	at t_state_8: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_7: state_7;
	at t_state_7: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_7: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_7: slave_out2_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_7: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_8: state_8;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: master_out_sig_data = slave_in2_sig_data_at_t_state_8;
	at t_state_4: resp_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: resp_data = slave_in2_sig_data_at_t_state_8;
	at t_end: state_1;
end property;


property cycle_15 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_9 = t+1,
	t_state_10 = t_state_9+1,
	t_state_4 = t_state_10+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in3_sig_ack_at_t_state_10 = slave_in3_sig_ack@t_state_10;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(24,32));
	at t_state_1: (master_in_sig_addr <= resize(31,32));
	at t_state_9: state_9;
	at t_state_9: slave_out3_sync;
	at t_state_10: state_10;
	at t_state_10: slave_in3_sync;
	at t_state_10: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_9: state_9;
	at t_state_9: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_9: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_9: slave_out3_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_9: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_10: state_10;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_16 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_9 = t+1,
	t_state_10 = t_state_9+1,
	t_state_4 = t_state_10+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in3_sig_ack_at_t_state_10 = slave_in3_sig_ack@t_state_10,
	slave_in3_sig_data_at_t_state_10 = slave_in3_sig_data@t_state_10;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(24,32));
	at t_state_1: (master_in_sig_addr <= resize(31,32));
	at t_state_9: state_9;
	at t_state_9: slave_out3_sync;
	at t_state_10: state_10;
	at t_state_10: slave_in3_sync;
	at t_state_10: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_9: state_9;
	at t_state_9: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_9: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_9: slave_out3_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_9: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_10: state_10;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: master_out_sig_data = slave_in3_sig_data_at_t_state_10;
	at t_state_4: resp_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: resp_data = slave_in3_sig_data_at_t_state_10;
	at t_end: state_1;
end property;


property cycle_17 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_4 = t+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	resp_ack_at_t_state_1 = resp_ack@t_state_1;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not(((master_in_sig_addr >= resize(0,32)) and not((resize(8,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(8,32)) and not((resize(16,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(16,32)) and not((resize(24,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(24,32)) and not((resize(32,32) <= master_in_sig_addr))));
	at t_state_1: (SINGLE_WRITE = master_in_sig_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = resp_ack_at_t_state_1;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_2 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_5 = t+1,
	t_state_6 = t_state_5+1,
	t_state_4 = t_state_6+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in1_sig_ack_at_t_state_6 = slave_in1_sig_ack@t_state_6;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(8,32));
	at t_state_1: (master_in_sig_addr <= resize(15,32));
	at t_state_5: state_5;
	at t_state_5: slave_out1_sync;
	at t_state_6: state_6;
	at t_state_6: slave_in1_sync;
	at t_state_6: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_5: state_5;
	at t_state_5: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_5: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_5: slave_out1_sig_data = 0;
	at t_state_5: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_6: state_6;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_3 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_5 = t+1,
	t_state_6 = t_state_5+1,
	t_state_4 = t_state_6+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in1_sig_ack_at_t_state_6 = slave_in1_sig_ack@t_state_6,
	slave_in1_sig_data_at_t_state_6 = slave_in1_sig_data@t_state_6;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(8,32));
	at t_state_1: (master_in_sig_addr <= resize(15,32));
	at t_state_5: state_5;
	at t_state_5: slave_out1_sync;
	at t_state_6: state_6;
	at t_state_6: slave_in1_sync;
	at t_state_6: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_5: state_5;
	at t_state_5: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_5: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_5: slave_out1_sig_data = 0;
	at t_state_5: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_6: state_6;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: master_out_sig_data = slave_in1_sig_data_at_t_state_6;
	at t_state_4: resp_ack = slave_in1_sig_ack_at_t_state_6;
	at t_state_4: resp_data = slave_in1_sig_data_at_t_state_6;
	at t_end: state_1;
end property;


property cycle_4 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t+1,
	t_state_8 = t_state_7+1,
	t_state_4 = t_state_8+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in2_sig_ack_at_t_state_8 = slave_in2_sig_ack@t_state_8;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(16,32));
	at t_state_1: (master_in_sig_addr <= resize(23,32));
	at t_state_7: state_7;
	at t_state_7: slave_out2_sync;
	at t_state_8: state_8;
	at t_state_8: slave_in2_sync;
	at t_state_8: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_7: state_7;
	at t_state_7: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_7: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_7: slave_out2_sig_data = 0;
	at t_state_7: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_8: state_8;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_5 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t+1,
	t_state_8 = t_state_7+1,
	t_state_4 = t_state_8+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in2_sig_ack_at_t_state_8 = slave_in2_sig_ack@t_state_8,
	slave_in2_sig_data_at_t_state_8 = slave_in2_sig_data@t_state_8;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(16,32));
	at t_state_1: (master_in_sig_addr <= resize(23,32));
	at t_state_7: state_7;
	at t_state_7: slave_out2_sync;
	at t_state_8: state_8;
	at t_state_8: slave_in2_sync;
	at t_state_8: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_7: state_7;
	at t_state_7: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_7: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_7: slave_out2_sig_data = 0;
	at t_state_7: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_8: state_8;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: master_out_sig_data = slave_in2_sig_data_at_t_state_8;
	at t_state_4: resp_ack = slave_in2_sig_ack_at_t_state_8;
	at t_state_4: resp_data = slave_in2_sig_data_at_t_state_8;
	at t_end: state_1;
end property;


property cycle_6 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_9 = t+1,
	t_state_10 = t_state_9+1,
	t_state_4 = t_state_10+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in3_sig_ack_at_t_state_10 = slave_in3_sig_ack@t_state_10;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(24,32));
	at t_state_1: (master_in_sig_addr <= resize(31,32));
	at t_state_9: state_9;
	at t_state_9: slave_out3_sync;
	at t_state_10: state_10;
	at t_state_10: slave_in3_sync;
	at t_state_10: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_9: state_9;
	at t_state_9: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_9: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_9: slave_out3_sig_data = 0;
	at t_state_9: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_10: state_10;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property cycle_7 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_9 = t+1,
	t_state_10 = t_state_9+1,
	t_state_4 = t_state_10+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in3_sig_ack_at_t_state_10 = slave_in3_sig_ack@t_state_10,
	slave_in3_sig_data_at_t_state_10 = slave_in3_sig_data@t_state_10;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: (master_in_sig_addr >= resize(24,32));
	at t_state_1: (master_in_sig_addr <= resize(31,32));
	at t_state_9: state_9;
	at t_state_9: slave_out3_sync;
	at t_state_10: state_10;
	at t_state_10: slave_in3_sync;
	at t_state_10: not((SINGLE_WRITE = req_trans_type));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_9: state_9;
	at t_state_9: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_9: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t_state_1)(31 downto 0);
	at t_state_9: slave_out3_sig_data = 0;
	at t_state_9: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_10: state_10;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: master_out_sig_data = slave_in3_sig_data_at_t_state_10;
	at t_state_4: resp_ack = slave_in3_sig_ack_at_t_state_10;
	at t_state_4: resp_data = slave_in3_sig_data_at_t_state_10;
	at t_end: state_1;
end property;


property cycle_8 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_4 = t+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	resp_ack_at_t_state_1 = resp_ack@t_state_1,
	resp_data_at_t_state_1 = resp_data@t_state_1;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: (SINGLE_READ = master_in_sig_trans_type);
	at t_state_1: not(((master_in_sig_addr >= resize(0,32)) and not((resize(8,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(8,32)) and not((resize(16,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(16,32)) and not((resize(24,32) <= master_in_sig_addr))));
	at t_state_1: not(((master_in_sig_addr >= resize(24,32)) and not((resize(32,32) <= master_in_sig_addr))));
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = resp_ack_at_t_state_1;
	at t_state_4: master_out_sig_data = resp_data_at_t_state_1;
	at t_state_4: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_end: state_1;
end property;


property cycle_9 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_2 = t+1,
	t_state_3 = t_state_2+1,
	t_state_4 = t_state_3+1,
	t_end = t_state_4+1;
freeze:
	master_in_sig_addr_at_t_state_1 = master_in_sig_addr@t_state_1,
	master_in_sig_data_at_t_state_1 = master_in_sig_data@t_state_1,
	master_in_sig_trans_type_at_t_state_1 = master_in_sig_trans_type@t_state_1,
	slave_in0_sig_ack_at_t_state_3 = slave_in0_sig_ack@t_state_3;
assume:
	at t_state_1: state_1;
	at t_state_1: master_in_sync;
	at t_state_1: not((SINGLE_READ = master_in_sig_trans_type));
	at t_state_1: (master_in_sig_addr >= resize(0,32));
	at t_state_1: (master_in_sig_addr <= resize(7,32));
	at t_state_2: state_2;
	at t_state_2: slave_out0_sync;
	at t_state_3: state_3;
	at t_state_3: slave_in0_sync;
	at t_state_3: (SINGLE_WRITE = req_trans_type);
	at t_state_4: state_4;
	at t_state_4: master_out_sync;
prove:
	at t_state_2: state_2;
	at t_state_2: req_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_2: slave_out0_sig_addr = master_in_sig_addr_at_t_state_1;
	at t_state_2: slave_out0_sig_data = master_in_sig_data_at_t_state_1;
	at t_state_2: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t_state_1;
	at t_state_3: state_3;
	at t_state_4: state_4;
	at t_state_4: master_out_sig_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: master_out_sig_data = 0;
	at t_state_4: resp_ack = slave_in0_sig_ack_at_t_state_3;
	at t_state_4: resp_data = 0;
	at t_end: state_1;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_1;
	at t: not(master_in_sync);
prove:
	at t+1: state_1;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = true;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_10 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_10;
	at t: not(slave_in3_sync);
prove:
	at t+1: state_10;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = true;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_out0_sig_at_t = slave_out0_sig@t;
assume:
	at t: state_2;
	at t: not(slave_out0_sync);
prove:
	at t+1: state_2;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: slave_out0_sig = slave_out0_sig_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = true;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_3;
	at t: not(slave_in0_sync);
prove:
	at t+1: state_3;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = true;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	master_out_sig_at_t = master_out_sig@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_4;
	at t: not(master_out_sync);
prove:
	at t+1: state_4;
	at t+1: master_out_sig = master_out_sig_at_t;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = true;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_5 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_out1_sig_at_t = slave_out1_sig@t;
assume:
	at t: state_5;
	at t: not(slave_out1_sync);
prove:
	at t+1: state_5;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: slave_out1_sig = slave_out1_sig_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = true;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_6 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_6;
	at t: not(slave_in1_sync);
prove:
	at t+1: state_6;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = true;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_7 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_out2_sig_at_t = slave_out2_sig@t;
assume:
	at t: state_7;
	at t: not(slave_out2_sync);
prove:
	at t+1: state_7;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: slave_out2_sig = slave_out2_sig_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = true;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_8 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	at t: state_8;
	at t: not(slave_in2_sync);
prove:
	at t+1: state_8;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = true;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = false;
end property;


property wait_state_9 is
dependencies: no_reset;
freeze:
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_out3_sig_at_t = slave_out3_sig@t;
assume:
	at t: state_9;
	at t: not(slave_out3_sync);
prove:
	at t+1: state_9;
	at t+1: req_trans_type = req_trans_type_at_t;
	at t+1: resp_ack = resp_ack_at_t;
	at t+1: resp_data = resp_data_at_t;
	at t+1: slave_out3_sig = slave_out3_sig_at_t;
	at t+1: master_in_notify = false;
	at t+1: master_out_notify = false;
	at t+1: slave_in0_notify = false;
	at t+1: slave_in1_notify = false;
	at t+1: slave_in2_notify = false;
	at t+1: slave_in3_notify = false;
	at t+1: slave_out0_notify = false;
	at t+1: slave_out1_notify = false;
	at t+1: slave_out2_notify = false;
	at t+1: slave_out3_notify = true;
end property;


