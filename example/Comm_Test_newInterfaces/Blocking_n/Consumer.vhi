-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro in_sync : boolean := end macro;
macro in_notify : boolean := end macro;


-- DP SIGNALS --
macro in_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_5 : boolean := true end macro;
macro state_7 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_5;
	 at t: in_notify = true;
end property;


property state_5_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_5;
	at t: in_sync;
prove:
	at t_end: state_7;
	during[t+1, t_end]: in_notify = false;
end property;


property state_5_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_5;
	at t: not(in_sync);
prove:
	at t_end: state_5;
	during[t+1, t_end-1]: in_notify = false;
	at t_end: in_notify = true;
end property;


property state_7_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_7;
prove:
	at t_end: state_5;
	during[t+1, t_end-1]: in_notify = false;
	at t_end: in_notify = true;
end property;


