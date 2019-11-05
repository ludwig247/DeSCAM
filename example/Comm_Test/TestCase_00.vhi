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
macro cnt : signed := end macro;
macro phase : Phases := end macro;


-- STATES --
macro state_15 : boolean := true end macro;
macro state_9 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_9;
	 at t: cnt = resize(0,32);
	 at t: phase = READ;
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_15_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t;
assume:
	at t: state_15;
	at t: b_out_sync;
prove:
	at t_end: state_9;
	at t_end: cnt = cnt_at_t;
	at t_end: phase = READ;
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
	at t: not((phase = PROCESS));
	at t: not((phase = WRITE));
prove:
	at t_end: state_15;
	at t_end: b_out_sig = (-1 + b_in_sig_at_t)(31 downto 0);
	at t_end: cnt = (-1 + b_in_sig_at_t)(31 downto 0);
	at t_end: phase = WRITE;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property wait_state_15 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	phase_at_t = phase@t;
assume:
	at t: state_15;
	at t: not(b_out_sync);
prove:
	at t+1: state_15;
	at t+1: b_out_sig = cnt_at_t;
	at t+1: cnt = cnt_at_t;
	at t+1: phase = phase_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_9 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	phase_at_t = phase@t;
assume:
	at t: state_9;
	at t: not(b_in_sync);
prove:
	at t+1: state_9;
	at t+1: cnt = cnt_at_t;
	at t+1: phase = phase_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


