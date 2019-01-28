-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro var : int := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: b_out_sig = resize(4,32);
	 at t: var = resize(4,32);
	 at t: b_out_notify = true;
end property;


property run_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	var_at_t = var@t;
assume: 
	 at t: run_0;
	 at t: b_out_sync;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: b_out_sig = (1 + var_at_t)(31 downto 0);
	 at t_end: var = (1 + var_at_t)(31 downto 0);
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	var_at_t = var@t;
assume: 
	 at t: run_0;
	 at t: not(b_out_sync);
prove:
	 at t_end: run_0;
	 at t_end: b_out_sig = (-1 + var_at_t)(31 downto 0);
	 at t_end: var = (-1 + var_at_t)(31 downto 0);
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;