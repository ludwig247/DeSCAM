-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: b_out_sig = resize(10,32);
	 at t: b_out_notify = true;
end property;


property run_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: not(b_out_sync);
prove:
	 at t_end: run_0;
	 at t_end: b_out_sig = 10;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: b_out_sync;
	 at t: b_out_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 11;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_1;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: b_out_sig = 10;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_1;
	 at t: not(b_out_sync);
prove:
	 at t_end: run_0;
	 at t_end: b_out_sig = 10;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;