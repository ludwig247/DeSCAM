-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: component1_write_1;
	 at t: cnt = resize(1,32);
	 at t: component1_out_sig_addr = resize(8,32);
	 at t: component1_out_sig_data = resize(1,32);
	 at t: component1_out_sig_trans_type = SINGLE_WRITE;
	 at t: component1_in_notify = false;
	 at t: component1_out_notify = true;
end property;


property component1_read_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+2;
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: component1_read_2;
	at t: component1_in_sync;
prove:
	at t_end: component1_write_1;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: component1_out_sig_addr = 8;
	at t_end: component1_out_sig_data = (1 + cnt_at_t)(31 downto 0);
	at t_end: component1_out_sig_trans_type = SINGLE_WRITE;
	during[t+1, t_end]: component1_in_notify = false;
	during[t+1, t_end-1]: component1_out_notify = false;
	at t_end: component1_out_notify = true;
end property;


property component1_write_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+messages+1;
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: component1_write_1;
	at t: component1_out_sync;
prove:
	at t_end: component1_read_2;
	at t_end: cnt = cnt_at_t;
	during[t+1, t_end-1]: component1_in_notify = false;
	at t_end: component1_in_notify = true;
	during[t+1, t_end]: component1_out_notify = false;
end property;


property wait_component1_read_2 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: component1_read_2;
	at t: not(component1_in_sync);
prove:
	at t+1: component1_read_2;
	at t+1: cnt = cnt_at_t;
	at t+1: component1_in_notify = true;
	at t+1: component1_out_notify = false;
end property;


property wait_component1_write_1 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	component1_out_sig_at_t = component1_out_sig@t;
assume:
	at t: component1_write_1;
	at t: not(component1_out_sync);
prove:
	at t+1: component1_write_1;
	at t+1: cnt = cnt_at_t;
	at t+1: component1_out_sig = component1_out_sig_at_t;
	at t+1: component1_in_notify = false;
	at t+1: component1_out_notify = true;
end property;


