-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := end macro;
macro b_out_sync : boolean := end macro;
macro b_in_notify : boolean := end macro;
macro b_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_in_sig : signed := end macro;
macro b_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro value : signed := end macro;


-- STATES --
macro state_14 : boolean := true end macro;
macro state_17 : boolean := true end macro;
macro state_19 : boolean := true end macro;
macro state_9 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_9;
	 at t: value = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_14_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	value_at_t = value@t;
assume:
	at t: state_14;
prove:
	at t_end: state_17;
	at t_end: b_out_sig = value_at_t;
	at t_end: value = value_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_17_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	value_at_t = value@t;
assume:
	at t: state_17;
	at t: b_out_sync;
prove:
	at t_end: state_9;
	at t_end: value = value_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property state_9_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: state_9;
	at t: b_in_sync;
prove:
	at t_end: state_14;
	at t_end: value = (5 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end]: b_out_notify = false;
end property;


property wait_state_17 is
dependencies: no_reset;
freeze:
	value_at_t = value@t;
assume:
	at t: state_17;
	at t: not(b_out_sync);
prove:
	at t+1: state_17;
	at t+1: b_out_sig = value_at_t;
	at t+1: value = value_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_9 is
dependencies: no_reset;
freeze:
	value_at_t = value@t;
assume:
	at t: state_9;
	at t: not(b_in_sync);
prove:
	at t+1: state_9;
	at t+1: value = value_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


