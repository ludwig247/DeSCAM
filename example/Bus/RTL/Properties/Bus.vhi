
-- DP SIGNALS --
macro master_in_sig_addr : int := master_in.addr end macro;
macro master_in_sig_data : int := master_in.data end macro;
macro master_in_sig_trans_type: trans_t := master_in.trans_type end macro;
macro master_out_sig_ack: ack_t := master_out.ack end macro;
macro master_out_sig_data: int := master_out.data end macro;
macro slave_in0_sig_ack: ack_t := slave_in0.ack end macro;
macro slave_in0_sig_data: int := slave_in0.data end macro;
macro slave_in1_sig_ack: ack_t := slave_in1.ack end macro;
macro slave_in1_sig_data: int := slave_in1.data end macro;
macro slave_in2_sig_ack: ack_t := slave_in2.ack end macro;
macro slave_in2_sig_data: int := slave_in2.data end macro;
macro slave_in3_sig_ack: ack_t := slave_in3.ack end macro;
macro slave_in3_sig_data: int :=  slave_in3.data end macro;
macro slave_out0_sig_addr: int := slave_out0.addr end macro;
macro slave_out0_sig_data: int := slave_out0.data end macro;
macro slave_out0_sig_trans_type: trans_t := slave_out0.trans_type end macro;
macro slave_out1_sig_addr: int := slave_out1.addr end macro;
macro slave_out1_sig_data: int := slave_out1.data end macro;
macro slave_out1_sig_trans_type: trans_t := slave_out1.trans_type end macro;
macro slave_out2_sig_addr: int := slave_out2.addr end macro;
macro slave_out2_sig_data: int := slave_out2.data end macro;
macro slave_out2_sig_trans_type: trans_t := slave_out2.trans_type end macro;
macro slave_out3_sig_addr: int := slave_out3.addr end macro;
macro slave_out3_sig_data: int := slave_out3.data end macro;
macro slave_out3_sig_trans_type: trans_t := slave_out3.trans_type end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro req_addr : int := req_signal.addr end macro;
macro req_data : int := req_signal.data end macro;
macro req_trans_type : trans_t := req_signal.trans_type end macro;
macro resp_ack : ack_t := resp_signal.ack end macro;
macro resp_data : int := resp_signal.data end macro;


-- STATES --
macro run_0 : boolean :=
	section=run and
	master_in_notify = true and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false

end macro;
macro run_1 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = true and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false

end macro;
macro run_2 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = true and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false
end macro;
macro run_3 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = true and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false
end macro;
macro run_4 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = true and
	slave_out2_notify = false and
	slave_out3_notify = false

end macro;
macro run_5 : boolean :=
	section=run  and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = true and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false
end macro;
macro run_6 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = true and
	slave_out3_notify = false
end macro;
macro run_7 : boolean :=
	section=run  and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = true and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false
end macro;
macro run_8 : boolean :=
	section=run and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = false and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = true
end macro;
macro run_9 : boolean :=
	section=run  and
	master_in_notify = false and
	master_out_notify = false and
	slave_in0_notify = false and
	slave_in1_notify = false and
	slave_in2_notify = false and
	slave_in3_notify = true and
	slave_out0_notify = false and
	slave_out1_notify = false and
	slave_out2_notify = false and
	slave_out3_notify = false
end macro;
--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: req_addr = 0;
	 at t: req_data = 0;
	 at t: req_trans_type = SINGLE_READ;
	 at t: resp_ack = ERR;
	 at t: resp_data = 0;
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


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_data_at_t = master_in_sig_data@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_sig_trans_type));
	 at t: (master_in_sig_addr >= 0);
	 at t: (master_in_sig_addr <= 7);
	 at t: master_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out0_sig_addr = master_in_sig_addr_at_t;
	 at t_end: slave_out0_sig_data = master_in_sig_data_at_t;
	 at t_end: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end-1]: slave_out0_notify = false;
	 at t_end: slave_out0_notify = true;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_sig_trans_type);
	 at t: (master_in_sig_addr >= 0);
	 at t: (master_in_sig_addr <= 7);
	 at t: master_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out0_sig_addr = master_in_sig_addr_at_t;
	 at t_end: slave_out0_sig_data = 0;
	 at t_end: slave_out0_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end-1]: slave_out0_notify = false;
	 at t_end: slave_out0_notify = true;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_sig_trans_type);
	 at t: not(((master_in_sig_addr >= 0) and not((8 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 8) and not((16 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 16) and not((24 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 24) and not((32 <= master_in_sig_addr))));
	 at t: master_in_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = resp_ack_at_t;
	 at t_end: master_out_sig_data = resp_data_at_t;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_data_at_t = master_in_sig_data@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t;
assume:
	 at t: run_0;
	 at t: not(((master_in_sig_addr >= 0) and not((8 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 8) and not((16 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 16) and not((24 <= master_in_sig_addr))));
	 at t: not(((master_in_sig_addr >= 24) and not((32 <= master_in_sig_addr))));
	 at t: (SINGLE_WRITE = master_in_sig_trans_type);
	 at t: master_in_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = resp_ack_at_t;
	 at t_end: master_out_sig_data = 0;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_data_at_t = master_in_sig_data@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_sig_trans_type));
	 at t: (master_in_sig_addr >= 8);
	 at t: (master_in_sig_addr <= 15);
	 at t: master_in_sync;
prove:
	 at t_end: run_4;
	 at t_end: req_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: slave_out1_sig_data = master_in_sig_data_at_t;
	 at t_end: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end-1]: slave_out1_notify = false;
	 at t_end: slave_out1_notify = true;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_sig_trans_type);
	 at t: (master_in_sig_addr >= 8);
	 at t: (master_in_sig_addr <= 15);
	 at t: master_in_sync;
prove:
	 at t_end: run_4;
	 at t_end: req_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out1_sig_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: slave_out1_sig_data = 0;
	 at t_end: slave_out1_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end-1]: slave_out1_notify = false;
	 at t_end: slave_out1_notify = true;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_data_at_t = master_in_sig_data@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_sig_trans_type));
	 at t: (master_in_sig_addr >= 16);
	 at t: (master_in_sig_addr <= 23);
	 at t: master_in_sync;
prove:
	 at t_end: run_6;
	 at t_end: req_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: slave_out2_sig_data = master_in_sig_data_at_t;
	 at t_end: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end-1]: slave_out2_notify = false;
	 at t_end: slave_out2_notify = true;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_sig_trans_type);
	 at t: (master_in_sig_addr >= 16);
	 at t: (master_in_sig_addr <= 23);
	 at t: master_in_sync;
prove:
	 at t_end: run_6;
	 at t_end: req_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out2_sig_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: slave_out2_sig_data = 0;
	 at t_end: slave_out2_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end-1]: slave_out2_notify = false;
	 at t_end: slave_out2_notify = true;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_0_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_data_at_t = master_in_sig_data@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_sig_trans_type));
	 at t: (master_in_sig_addr >= 24);
	 at t: (master_in_sig_addr <= 31);
	 at t: master_in_sync;
prove:
	 at t_end: run_8;
	 at t_end: req_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: slave_out3_sig_data = master_in_sig_data_at_t;
	 at t_end: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end-1]: slave_out3_notify = false;
	 at t_end: slave_out3_notify = true;
end property;

property run_0_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_in_sig_addr_at_t = master_in_sig_addr@t,
	master_in_sig_trans_type_at_t = master_in_sig_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_sig_trans_type);
	 at t: (master_in_sig_addr >= 24);
	 at t: (master_in_sig_addr <= 31);
	 at t: master_in_sync;
prove:
	 at t_end: run_8;
	 at t_end: req_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 at t_end: slave_out3_sig_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: slave_out3_sig_data = 0;
	 at t_end: slave_out3_sig_trans_type = master_in_sig_trans_type_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end-1]: slave_out3_notify = false;
	 at t_end: slave_out3_notify = true;
end property;

property run_1_write_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_1;
	 at t: slave_out0_sync;
prove:
	 at t_end: run_2;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end-1]: slave_in0_notify = false;
	 at t_end: slave_in0_notify = true;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in0_sig_ack_at_t = slave_in0_sig_ack@t,
	slave_in0_sig_data_at_t = slave_in0_sig_data@t;
assume:
	 at t: run_2;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: slave_in0_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in0_sig_ack_at_t;
	 at t_end: master_out_sig_data = slave_in0_sig_data_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in0_sig_ack_at_t;
	 at t_end: resp_data = slave_in0_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in0_sig_ack_at_t = slave_in0_sig_ack@t;
assume:
	 at t: run_2;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: slave_in0_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in0_sig_ack_at_t;
	 at t_end: master_out_sig_data = 0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in0_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_3_write_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_3;
	 at t: master_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end-1]: master_in_notify = false;
	 at t_end: master_in_notify = true;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_4_write_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_4;
	 at t: slave_out1_sync;
prove:
	 at t_end: run_5;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end-1]: slave_in1_notify = false;
	 at t_end: slave_in1_notify = true;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_5_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in1_sig_ack_at_t = slave_in1_sig_ack@t,
	slave_in1_sig_data_at_t = slave_in1_sig_data@t;
assume:
	 at t: run_5;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: slave_in1_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in1_sig_ack_at_t;
	 at t_end: master_out_sig_data = slave_in1_sig_data_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in1_sig_ack_at_t;
	 at t_end: resp_data = slave_in1_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_5_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in1_sig_ack_at_t = slave_in1_sig_ack@t;
assume:
	 at t: run_5;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: slave_in1_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in1_sig_ack_at_t;
	 at t_end: master_out_sig_data = 0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in1_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_6_write_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_6;
	 at t: slave_out2_sync;
prove:
	 at t_end: run_7;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end-1]: slave_in2_notify = false;
	 at t_end: slave_in2_notify = true;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_7_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in2_sig_ack_at_t = slave_in2_sig_ack@t,
	slave_in2_sig_data_at_t = slave_in2_sig_data@t;
assume:
	 at t: run_7;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: slave_in2_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in2_sig_ack_at_t;
	 at t_end: master_out_sig_data = slave_in2_sig_data_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in2_sig_ack_at_t;
	 at t_end: resp_data = slave_in2_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_7_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in2_sig_ack_at_t = slave_in2_sig_ack@t;
assume:
	 at t: run_7;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: slave_in2_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in2_sig_ack_at_t;
	 at t_end: master_out_sig_data = 0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in2_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_8_write_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_8;
	 at t: slave_out3_sync;
prove:
	 at t_end: run_9;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end-1]: slave_in3_notify = false;
	 at t_end: slave_in3_notify = true;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_9_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in3_sig_ack_at_t = slave_in3_sig_ack@t,
	slave_in3_sig_data_at_t = slave_in3_sig_data@t;
assume:
	 at t: run_9;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: slave_in3_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in3_sig_ack_at_t;
	 at t_end: master_out_sig_data = slave_in3_sig_data_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in3_sig_ack_at_t;
	 at t_end: resp_data = slave_in3_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property run_9_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	slave_in3_sig_ack_at_t = slave_in3_sig_ack@t;
assume:
	 at t: run_9;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: slave_in3_sync;
prove:
	 at t_end: run_3;
	 at t_end: master_out_sig_ack = slave_in3_sig_ack_at_t;
	 at t_end: master_out_sig_data = 0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in3_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 at t_end: master_out_notify = true;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: not(master_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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

property wait_run_1 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_1;
	 at t: not(slave_out0_sync);
prove:
	 at t+1: run_1;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
	 at t+1: req_trans_type = req_trans_type_at_t;
	 at t+1: resp_ack = resp_ack_at_t;
	 at t+1: resp_data = resp_data_at_t;
	 at t+1: slave_out0_sig_addr = req_addr_at_t;
	 at t+1: slave_out0_sig_data = req_data_at_t;
	 at t+1: slave_out0_sig_trans_type = req_trans_type_at_t;
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

property wait_run_2 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_2;
	 at t: not(slave_in0_sync);
prove:
	 at t+1: run_2;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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

property wait_run_3 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_3;
	 at t: not(master_out_sync);
prove:
	 at t+1: run_3;
	 at t+1: master_out_sig_ack = resp_ack_at_t;
	 at t+1: master_out_sig_data = resp_data_at_t;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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

property wait_run_4 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_4;
	 at t: not(slave_out1_sync);
prove:
	 at t+1: run_4;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
	 at t+1: req_trans_type = req_trans_type_at_t;
	 at t+1: resp_ack = resp_ack_at_t;
	 at t+1: resp_data = resp_data_at_t;
	 at t+1: slave_out1_sig_addr = req_addr_at_t;
	 at t+1: slave_out1_sig_data = req_data_at_t;
	 at t+1: slave_out1_sig_trans_type = req_trans_type_at_t;
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

property wait_run_5 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_5;
	 at t: not(slave_in1_sync);
prove:
	 at t+1: run_5;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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

property wait_run_6 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_6;
	 at t: not(slave_out2_sync);
prove:
	 at t+1: run_6;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
	 at t+1: req_trans_type = req_trans_type_at_t;
	 at t+1: resp_ack = resp_ack_at_t;
	 at t+1: resp_data = resp_data_at_t;
	 at t+1: slave_out2_sig_addr = req_addr_at_t;
	 at t+1: slave_out2_sig_data = req_data_at_t;
	 at t+1: slave_out2_sig_trans_type = req_trans_type_at_t;
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

property wait_run_7 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_7;
	 at t: not(slave_in2_sync);
prove:
	 at t+1: run_7;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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

property wait_run_8 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_8;
	 at t: not(slave_out3_sync);
prove:
	 at t+1: run_8;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
	 at t+1: req_trans_type = req_trans_type_at_t;
	 at t+1: resp_ack = resp_ack_at_t;
	 at t+1: resp_data = resp_data_at_t;
	 at t+1: slave_out3_sig_addr = req_addr_at_t;
	 at t+1: slave_out3_sig_data = req_data_at_t;
	 at t+1: slave_out3_sig_trans_type = req_trans_type_at_t;
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

property wait_run_9 is
dependencies: no_reset;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_9;
	 at t: not(slave_in3_sync);
prove:
	 at t+1: run_9;
	 at t+1: req_addr = req_addr_at_t;
	 at t+1: req_data = req_data_at_t;
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
