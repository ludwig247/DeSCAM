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
macro val : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro idle_2 : boolean := true end macro;
macro wait_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro store_5 : boolean := true end macro;
macro load_6 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: val = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: state_1;
	at t: b_in_sync;
prove:
	at t_end: idle_2;
	at t_end: val = b_in_sig_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property idle_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: idle_2;
	at t: b_in_sync;
prove:
	at t_end: wait_3;
	at t_end: val = b_in_sig_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property wait_3_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: wait_3;
	at t: b_in_sync;
prove:
	at t_end: state_4;
	at t_end: b_out_sig = b_in_sig_at_t;
	at t_end: val = b_in_sig_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property wait_3_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_at_t = val@t;
assume:
	at t: wait_3;
	at t: not(b_in_sync);
prove:
	at t_end: state_4;
	at t_end: b_out_sig = val_at_t;
	at t_end: val = val_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_4_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_at_t = val@t;
assume:
	at t: state_4;
	at t: b_out_sync;
prove:
	at t_end: store_5;
	at t_end: b_out_sig = val_at_t;
	at t_end: val = val_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property store_5_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_at_t = val@t;
assume:
	at t: store_5;
	at t: b_out_sync;
prove:
	at t_end: load_6;
	at t_end: b_out_sig = val_at_t;
	at t_end: val = val_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property load_6_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_at_t = val@t;
assume:
	at t: load_6;
	at t: b_out_sync;
prove:
	at t_end: state_1;
	at t_end: val = val_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property load_6_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_at_t = val@t;
assume:
	at t: load_6;
	at t: not(b_out_sync);
prove:
	at t_end: state_1;
	at t_end: val = val_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: val = val_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


property wait_idle_2 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: idle_2;
	at t: not(b_in_sync);
prove:
	at t+1: idle_2;
	at t+1: val = val_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: state_4;
	at t: not(b_out_sync);
prove:
	at t+1: state_4;
	at t+1: b_out_sig = val_at_t;
	at t+1: val = val_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_store_5 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: store_5;
	at t: not(b_out_sync);
prove:
	at t+1: store_5;
	at t+1: b_out_sig = val_at_t;
	at t+1: val = val_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


