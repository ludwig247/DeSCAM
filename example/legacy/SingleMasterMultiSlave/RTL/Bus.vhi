
-- DP SIGNALS --
macro master_in_addr_sig : int := master_in.addr end macro;
macro master_in_data_sig : int := master_in.data end macro;
macro master_in_trans_type_sig : trans_t := master_in.trans_type end macro;
macro master_out_ack_sig : ack_t := master_out.ack end macro;
macro master_out_data_sig : int := master_out.data end macro;
macro slave_in0_ack_sig : ack_t := slave_in0.ack end macro;
macro slave_in0_data_sig : int := slave_in0.data end macro;
macro slave_in1_ack_sig : ack_t := slave_in1.ack end macro;
macro slave_in1_data_sig : int := slave_in1.data end macro;
macro slave_in2_ack_sig : ack_t := slave_in2.ack end macro;
macro slave_in2_data_sig : int := slave_in2.data end macro;
macro slave_in3_ack_sig : ack_t := slave_in3.ack end macro;
macro slave_in3_data_sig : int :=  slave_in3.data end macro;
macro slave_out0_addr_sig : int := slave_out0.addr end macro;
macro slave_out0_data_sig : int := slave_out0.data end macro;
macro slave_out0_trans_type_sig : trans_t := slave_out0.trans_type end macro;
macro slave_out1_addr_sig : int := slave_out1.addr end macro;
macro slave_out1_data_sig : int := slave_out1.data end macro;
macro slave_out1_trans_type_sig : trans_t := slave_out1.trans_type end macro;
macro slave_out2_addr_sig : int := slave_out2.addr end macro;
macro slave_out2_data_sig : int := slave_out2.data end macro;
macro slave_out2_trans_type_sig : trans_t := slave_out2.trans_type end macro;
macro slave_out3_addr_sig : int := slave_out3.addr end macro;
macro slave_out3_data_sig : int := slave_out3.data end macro;
macro slave_out3_trans_type_sig : trans_t := slave_out3.trans_type end macro;


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
for timepoints:
	t_end = t;
assume:
	 reset_sequence;
prove:
	 at t_end: run_0;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = ERR;
	 at t_end: resp_data = 0;
	 during[t+1, t_end-1]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_in_notify = true;
end property;

property wait_run_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (master_in_sync = false);
prove:
	 at t_end: run_0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end-1]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_in_notify = true;
end property;

property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_trans_type_sig));
	 at t: (master_in_addr_sig >= 0);
	 at t: (master_in_addr_sig <= 7);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_1;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end-1]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out0_notify = true;
	 at t_end: slave_out0_addr_sig = req_addr;
	 at t_end: slave_out0_data_sig = req_data;
	 at t_end: slave_out0_trans_type_sig = req_trans_type;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_trans_type_sig);
	 at t: (master_in_addr_sig >= 0);
	 at t: (master_in_addr_sig <= 7);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_1;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end-1]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out0_notify = true;
	 at t_end: slave_out0_addr_sig = req_addr;
	 at t_end: slave_out0_data_sig = req_data;
	 at t_end: slave_out0_trans_type_sig = req_trans_type;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_trans_type_sig);
	 at t: not(((master_in_addr_sig >= 0) and not((8 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 8) and not((16 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 16) and not((24 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 24) and not((32 <= master_in_addr_sig))));
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: not(((master_in_addr_sig >= 0) and not((8 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 8) and not((16 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 16) and not((24 <= master_in_addr_sig))));
	 at t: not(((master_in_addr_sig >= 24) and not((32 <= master_in_addr_sig))));
	 at t: (SINGLE_WRITE = master_in_trans_type_sig);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = master_in_sig_addr_at_t;
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_trans_type_sig));
	 at t: (master_in_addr_sig >= 8);
	 at t: (master_in_addr_sig <= 15);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_4;
	 at t_end: req_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end-1]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out1_notify = true;
	 at t_end: slave_out1_addr_sig = req_addr;
	 at t_end: slave_out1_data_sig = req_data;
	 at t_end: slave_out1_trans_type_sig = req_trans_type;
end property;

property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_trans_type_sig);
	 at t: (master_in_addr_sig >= 8);
	 at t: (master_in_addr_sig <= 15);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_4;
	 at t_end: req_addr = (-8 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end-1]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out1_notify = true;
	 at t_end: slave_out1_addr_sig = req_addr;
	 at t_end: slave_out1_data_sig = req_data;
	 at t_end: slave_out1_trans_type_sig = req_trans_type;
end property;

property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_trans_type_sig));
	 at t: (master_in_addr_sig >= 16);
	 at t: (master_in_addr_sig <= 23);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_6;
	 at t_end: req_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end-1]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out2_notify = true;
	 at t_end: slave_out2_addr_sig = req_addr;
	 at t_end: slave_out2_data_sig = req_data;
	 at t_end: slave_out2_trans_type_sig = req_trans_type;
end property;

property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_trans_type_sig);
	 at t: (master_in_addr_sig >= 16);
	 at t: (master_in_addr_sig <= 23);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_6;
	 at t_end: req_addr = (-16 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end-1]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out2_notify = true;
	 at t_end: slave_out2_addr_sig = req_addr;
	 at t_end: slave_out2_data_sig = req_data;
	 at t_end: slave_out2_trans_type_sig = req_trans_type;
end property;

property run_0_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: not((SINGLE_READ = master_in_trans_type_sig));
	 at t: (master_in_addr_sig >= 24);
	 at t: (master_in_addr_sig <= 31);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_8;
	 at t_end: req_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: req_data = master_in_sig_data_at_t;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
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
	 at t_end: slave_out3_addr_sig = req_addr;
	 at t_end: slave_out3_data_sig = req_data;
	 at t_end: slave_out3_trans_type_sig = req_trans_type;
end property;

property run_0_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	master_in_sig_addr_at_t = master_in_addr_sig@t,
	master_in_sig_data_at_t = master_in_data_sig@t,
	master_in_sig_trans_type_at_t = master_in_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (SINGLE_READ = master_in_trans_type_sig);
	 at t: (master_in_addr_sig >= 24);
	 at t: (master_in_addr_sig <= 31);
	 at t: (master_in_sync = true);
prove:
	 at t_end: run_8;
	 at t_end: req_addr = (-24 + master_in_sig_addr_at_t);
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = master_in_sig_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
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
	 at t_end: slave_out3_addr_sig = req_addr;
	 at t_end: slave_out3_data_sig = req_data;
	 at t_end: slave_out3_trans_type_sig = req_trans_type;
end property;

property wait_run_1 is
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
	 at t: (slave_out0_sync = false);
prove:
	 at t_end: run_1;
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end-1]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out0_notify = true;
	 at t_end: slave_out0_addr_sig = req_addr;
	 at t_end: slave_out0_data_sig = req_data;
	 at t_end: slave_out0_trans_type_sig = req_trans_type;
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
	 at t: (slave_out0_sync = true);
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
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in0_notify = true;
end property;

property wait_run_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in0_sig_ack_at_t = slave_in0_ack_sig@t,
	slave_in0_sig_data_at_t = slave_in0_data_sig@t;
assume:
	 at t: run_2;
	 at t: (slave_in0_sync = false);
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
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in0_notify = true;
end property;

property run_2_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in0_sig_ack_at_t = slave_in0_ack_sig@t,
	slave_in0_sig_data_at_t = slave_in0_data_sig@t;
assume:
	 at t: run_2;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: (slave_in0_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in0_sig_ack_at_t;
	 at t_end: resp_data = slave_in0_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_2_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in0_sig_ack_at_t = slave_in0_ack_sig@t,
	slave_in0_sig_data_at_t = slave_in0_data_sig@t;
assume:
	 at t: run_2;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: (slave_in0_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in0_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
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
	 at t: (master_out_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end-1]: master_in_notify = false;
	 during[t+1, t_end]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_in_notify = true;
end property;

property wait_run_3 is
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
	 at t: (master_out_sync = false);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property wait_run_4 is
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
	 at t: (slave_out1_sync = false);
prove:
	 at t_end: run_4;
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end-1]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out1_notify = true;
	 at t_end: slave_out1_addr_sig = req_addr;
	 at t_end: slave_out1_data_sig = req_data;
	 at t_end: slave_out1_trans_type_sig = req_trans_type;
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
	 at t: (slave_out1_sync = true);
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
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in1_notify = true;
end property;

property run_5_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in1_sig_ack_at_t = slave_in1_ack_sig@t,
	slave_in1_sig_data_at_t = slave_in1_data_sig@t;
assume:
	 at t: run_5;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: (slave_in1_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in1_sig_ack_at_t;
	 at t_end: resp_data = slave_in1_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_5_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in1_sig_ack_at_t = slave_in1_ack_sig@t,
	slave_in1_sig_data_at_t = slave_in1_data_sig@t;
assume:
	 at t: run_5;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: (slave_in1_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in1_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property wait_run_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in1_sig_ack_at_t = slave_in1_ack_sig@t,
	slave_in1_sig_data_at_t = slave_in1_data_sig@t;
assume:
	 at t: run_5;
	 at t: (slave_in1_sync = false);
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
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in1_notify = true;
end property;

property wait_run_6 is
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
	 at t: (slave_out2_sync = false);
prove:
	 at t_end: run_6;
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end-1]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_out2_notify = true;
	 at t_end: slave_out2_addr_sig = req_addr;
	 at t_end: slave_out2_data_sig = req_data;
	 at t_end: slave_out2_trans_type_sig = req_trans_type;
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
	 at t: (slave_out2_sync = true);
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in2_notify = true;
end property;

property run_7_read_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in2_sig_ack_at_t = slave_in2_ack_sig@t,
	slave_in2_sig_data_at_t = slave_in2_data_sig@t;
assume:
	 at t: run_7;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: (slave_in2_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in2_sig_ack_at_t;
	 at t_end: resp_data = slave_in2_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_7_read_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in2_sig_ack_at_t = slave_in2_ack_sig@t,
	slave_in2_sig_data_at_t = slave_in2_data_sig@t;
assume:
	 at t: run_7;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: (slave_in2_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in2_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property wait_run_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in2_sig_ack_at_t = slave_in2_ack_sig@t,
	slave_in2_sig_data_at_t = slave_in2_data_sig@t;
assume:
	 at t: run_7;
	 at t: (slave_in2_sync = false);
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in2_notify = true;
end property;

property wait_run_8 is
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
	 at t: (slave_out3_sync = false);
prove:
	 at t_end: run_8;
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
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end-1]: slave_out3_notify = false;
	 at t_end: slave_out3_notify = true;
	 at t_end: slave_out3_addr_sig = req_addr;
	 at t_end: slave_out3_data_sig = req_data;
	 at t_end: slave_out3_trans_type_sig = req_trans_type;
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
	 at t: (slave_out3_sync = true);
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
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in3_notify = true;
end property;

property run_9_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in3_sig_ack_at_t = slave_in3_ack_sig@t,
	slave_in3_sig_data_at_t = slave_in3_data_sig@t;
assume:
	 at t: run_9;
	 at t: not((SINGLE_WRITE = req_trans_type));
	 at t: (slave_in3_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in3_sig_ack_at_t;
	 at t_end: resp_data = slave_in3_sig_data_at_t;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property run_9_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in3_sig_ack_at_t = slave_in3_ack_sig@t,
	slave_in3_sig_data_at_t = slave_in3_data_sig@t;
assume:
	 at t: run_9;
	 at t: (SINGLE_WRITE = req_trans_type);
	 at t: (slave_in3_sync = true);
prove:
	 at t_end: run_3;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = slave_in3_sig_ack_at_t;
	 at t_end: resp_data = 0;
	 during[t+1, t_end]: master_in_notify = false;
	 during[t+1, t_end-1]: master_out_notify = false;
	 during[t+1, t_end]: slave_in0_notify = false;
	 during[t+1, t_end]: slave_in1_notify = false;
	 during[t+1, t_end]: slave_in2_notify = false;
	 during[t+1, t_end]: slave_in3_notify = false;
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: master_out_notify = true;
	 at t_end: master_out_ack_sig = resp_ack;
	 at t_end: master_out_data_sig = resp_data;
end property;

property wait_run_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	slave_in3_sig_ack_at_t = slave_in3_ack_sig@t,
	slave_in3_sig_data_at_t = slave_in3_data_sig@t;
assume:
	 at t: run_9;
	 at t: (slave_in3_sync = false);
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
	 during[t+1, t_end]: slave_out0_notify = false;
	 during[t+1, t_end]: slave_out1_notify = false;
	 during[t+1, t_end]: slave_out2_notify = false;
	 during[t+1, t_end]: slave_out3_notify = false;
	 at t_end: slave_in3_notify = true;
end property;