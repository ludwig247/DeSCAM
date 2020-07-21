-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := true end macro;
macro b_out_sync : boolean := true end macro;
macro b_in_notify : boolean := true end  macro;
macro b_out_notify : boolean := true end  macro;


-- DP SIGNALS --
macro b_in_sig : int_5 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro b_in_sig_0 : signed :=resize(0,32) end macro;
macro b_in_sig_1 : signed :=resize(0,32) end macro;
macro b_in_sig_2 : signed :=resize(0,32) end macro;
macro b_in_sig_3 : signed :=resize(0,32) end macro;
macro b_in_sig_4 : signed :=resize(0,32) end macro;
macro b_out_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_0_at_t = b_in_sig(0)@t;
assume:
	at t: state_1;
	at t: b_in_sync;
prove:
	at t_end: state_2;
	at t_end: b_out_sig = (2 + b_in_sig_at_t(0))(31 downto 0);
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_2;
	at t: b_out_sync;
prove:
	at t_end: state_1;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: state_2;
	at t: not(b_out_sync);
prove:
	at t+1: state_2;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


