-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig : int := end macro; 
macro b_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro var : int := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: var = resize(4,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume: 
	 at t: run_0;
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = b_in_sig_at_t;
	 at t_end: var = b_in_sig_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	var_at_t = var@t;
assume: 
	 at t: run_1;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	var_at_t = var@t;
assume: 
	 at t: run_0;
	 at t: not(b_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: var = var_at_t;
	 at t+1: b_in_notify = true;
	 at t+1: b_out_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	var_at_t = var@t;
assume: 
	 at t: run_1;
	 at t: not(b_out_sync);
prove:
	 at t+1: run_1;
	 at t+1: b_out_sig = var_at_t;
	 at t+1: var = var_at_t;
	 at t+1: b_in_notify = false;
	 at t+1: b_out_notify = true;
end property;