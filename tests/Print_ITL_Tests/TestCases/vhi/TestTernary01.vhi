-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro data_in_sync : boolean := true end macro;
macro valid_out_sync : boolean := true end macro;
macro data_in_notify : boolean := true end  macro;
macro valid_out_notify : boolean := true end  macro;


-- DP SIGNALS --
macro data_in_sig : signed :=resize(0,32) end macro;
macro data_out_sig : boolean :=false end macro;
macro valid_out_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro valid : boolean :=false end macro;
macro value_in : signed :=resize(0,32) end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro output1_2 : boolean := true end macro;
macro output2_3 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: data_out_sig = false;
	 at t: valid = false;
	 at t: value_in = resize(0,32);
	 at t: data_in_notify = true;
	 at t: valid_out_notify = false;
end property;


property output1_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	valid_at_t = valid@t,
	value_in_at_t = value_in@t;
assume:
	at t: output1_2;
	at t: valid_out_sync;
prove:
	at t_end: output2_3;
	at t_end: data_out_sig = valid_at_t;
	at t_end: valid = valid_at_t;
	at t_end: valid_out_sig = ((value_in_at_t <= 0)?0:1);
	at t_end: value_in = value_in_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: valid_out_notify = false;
	at t_end: valid_out_notify = true;
end property;


property output2_3_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_out_sig_at_t = data_out_sig@t,
	valid_at_t = valid@t,
	value_in_at_t = value_in@t;
assume:
	at t: output2_3;
	at t: valid_out_sync;
prove:
	at t_end: state_1;
	at t_end: data_out_sig = data_out_sig_at_t;
	at t_end: valid = valid_at_t;
	at t_end: value_in = value_in_at_t;
	during[t+1, t_end-1]: data_in_notify = false;
	at t_end: data_in_notify = true;
	during[t+1, t_end]: valid_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t;
assume:
	at t: state_1;
	at t: data_in_sync;
	at t: (data_in_sig >= resize(5,32));
prove:
	at t_end: output1_2;
	at t_end: data_out_sig = true;
	at t_end: valid = true;
	at t_end: valid_out_sig = (1 + (1 + data_in_sig_at_t)(31 downto 0))(31 downto 0);
	at t_end: value_in = data_in_sig_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: valid_out_notify = false;
	at t_end: valid_out_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t;
assume:
	at t: state_1;
	at t: data_in_sync;
	at t: (data_in_sig <= resize(4,32));
prove:
	at t_end: output1_2;
	at t_end: data_out_sig = true;
	at t_end: valid = true;
	at t_end: valid_out_sig = (1 + data_in_sig_at_t)(31 downto 0);
	at t_end: value_in = data_in_sig_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: valid_out_notify = false;
	at t_end: valid_out_notify = true;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	value_in_at_t = value_in@t;
assume:
	at t: state_1;
	at t: not(data_in_sync);
	at t: (value_in >= resize(6,32));
prove:
	at t_end: output1_2;
	at t_end: data_out_sig = false;
	at t_end: valid = false;
	at t_end: valid_out_sig = (1 + value_in_at_t)(31 downto 0);
	at t_end: value_in = value_in_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: valid_out_notify = false;
	at t_end: valid_out_notify = true;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	value_in_at_t = value_in@t;
assume:
	at t: state_1;
	at t: not(data_in_sync);
	at t: (value_in <= resize(5,32));
prove:
	at t_end: output1_2;
	at t_end: data_out_sig = false;
	at t_end: valid = false;
	at t_end: valid_out_sig = value_in_at_t;
	at t_end: value_in = value_in_at_t;
	during[t+1, t_end]: data_in_notify = false;
	during[t+1, t_end-1]: valid_out_notify = false;
	at t_end: valid_out_notify = true;
end property;


property wait_output1_2 is
dependencies: no_reset;
freeze:
	data_out_sig_at_t = data_out_sig@t,
	valid_at_t = valid@t,
	valid_out_sig_at_t = valid_out_sig@t,
	value_in_at_t = value_in@t;
assume:
	at t: output1_2;
	at t: not(valid_out_sync);
prove:
	at t+1: output1_2;
	at t+1: data_out_sig = data_out_sig_at_t;
	at t+1: valid = valid_at_t;
	at t+1: valid_out_sig = valid_out_sig_at_t;
	at t+1: value_in = value_in_at_t;
	at t+1: data_in_notify = false;
	at t+1: valid_out_notify = true;
end property;


property wait_output2_3 is
dependencies: no_reset;
freeze:
	data_out_sig_at_t = data_out_sig@t,
	valid_at_t = valid@t,
	valid_out_sig_at_t = valid_out_sig@t,
	value_in_at_t = value_in@t;
assume:
	at t: output2_3;
	at t: not(valid_out_sync);
prove:
	at t+1: output2_3;
	at t+1: data_out_sig = data_out_sig_at_t;
	at t+1: valid = valid_at_t;
	at t+1: valid_out_sig = valid_out_sig_at_t;
	at t+1: value_in = value_in_at_t;
	at t+1: data_in_notify = false;
	at t+1: valid_out_notify = true;
end property;


