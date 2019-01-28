-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro master_out1_notify :  boolean  := end macro; 
--macro value_in_notify :  boolean  := end macro; 
--macro value_in_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro master_out1_sig : bool := master_out1 end macro; 
macro value_in_sig : int := value_in end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro var : int := var_signal end macro; 


-- STATES -- 
macro idle_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_0;
	 at t: var = 10;
	 at t: master_out1_notify = false;
	 at t: value_in_notify = true;
end property;


property idle_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_out1_sig_at_t = master_out1_sig@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t;
assume: 
	 at t: idle_0;
	 at t: (value_in_sig = 0);
	 at t: value_in_sync;
prove:
	 at t_end: idle_0;
	 at t_end: master_out1_sig = true;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: master_out1_notify = false;
	 at t_end: master_out1_notify = true;
	 during[t+1, t_end-1]: value_in_notify = false;
	 at t_end: value_in_notify = true;
end property;

property idle_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_out1_sig_at_t = master_out1_sig@t,
	var_at_t = var@t;
assume: 
	 at t: idle_0;
	 at t: (var = 0);
	 at t: not(value_in_sync);
prove:
	 at t_end: idle_0;
	 at t_end: master_out1_sig = true;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: master_out1_notify = false;
	 at t_end: master_out1_notify = true;
	 during[t+1, t_end-1]: value_in_notify = false;
	 at t_end: value_in_notify = true;
end property;

property idle_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_out1_sig_at_t = master_out1_sig@t,
	var_at_t = var@t;
assume: 
	 at t: idle_0;
	 at t: not((var = 0));
	 at t: not(value_in_sync);
prove:
	 at t_end: idle_0;
	 at t_end: master_out1_sig = false;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: master_out1_notify = false;
	 at t_end: master_out1_notify = true;
	 during[t+1, t_end-1]: value_in_notify = false;
	 at t_end: value_in_notify = true;
end property;

property idle_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	master_out1_sig_at_t = master_out1_sig@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t;
assume: 
	 at t: idle_0;
	 at t: not((value_in_sig = 0));
	 at t: value_in_sync;
prove:
	 at t_end: idle_0;
	 at t_end: master_out1_sig = false;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: master_out1_notify = false;
	 at t_end: master_out1_notify = true;
	 during[t+1, t_end-1]: value_in_notify = false;
	 at t_end: value_in_notify = true;
end property;
