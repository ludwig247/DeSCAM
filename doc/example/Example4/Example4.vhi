-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro report_out_notify :  boolean  := end macro; 
--macro value_in_notify :  boolean  := end macro; 
--macro value_in_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro master_in1_sig : bool := master_in1 end macro; 
macro master_in2_sig : bool := master_in2 end macro; 
macro report_out_sig : bool := report_out end macro; 
macro value_in_sig : int := value_in end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro value : bool := value_signal end macro; 
macro var : int := var_signal end macro; 


-- STATES -- 
macro idle_0 : boolean := (report_out_notify and (report_out = false) and not(value_in_notify)) end macro;
macro idle_1 : boolean := (value_in_notify and not(report_out_notify)) end macro;
macro reading_3 : boolean := (report_out_notify and (report_out = true) and not(value_in_notify)) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_0;
	 at t: report_out_sig = false;
	 at t: value = false;
	 at t: var = 10;
	 at t: report_out_notify = true;
	 at t: value_in_notify = false;
end property;


property idle_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	value_at_t = value@t,
	var_at_t = var@t;
assume: 
	 at t: idle_0;
prove:
	 at t_end: idle_1;
	 at t_end: value = value_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end]: report_out_notify = false;
	 during[t+1, t_end-1]: value_in_notify = false;
	 at t_end: value_in_notify = true;
end property;

property idle_1_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t;
assume: 
	 at t: idle_1;
	 at t: not((value_in_sig = 0));
	 at t: not(value);
	 at t: value_in_sync;
prove:
	 at t_end: idle_0;
	 at t_end: report_out_sig = false;
	 at t_end: value = value_at_t;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t;
assume: 
	 at t: idle_1;
	 at t: not((var = 0));
	 at t: not(value);
	 at t: not(value_in_sync);
prove:
	 at t_end: idle_0;
	 at t_end: report_out_sig = false;
	 at t_end: value = value_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t;
assume: 
	 at t: idle_1;
	 at t: not((value_in_sig = 0));
	 at t: value;
	 at t: value_in_sync;
prove:
	 at t_end: reading_3;
	 at t_end: report_out_sig = true;
	 at t_end: value = value_at_t;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t;
assume: 
	 at t: idle_1;
	 at t: not((var = 0));
	 at t: value;
	 at t: not(value_in_sync);
prove:
	 at t_end: reading_3;
	 at t_end: report_out_sig = true;
	 at t_end: value = value_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t,
	master_in1_sig_at_t = master_in1_sig@t;
assume: 
	 at t: idle_1;
	 at t: not(master_in1_sig);
	 at t: (value_in_sig = 0);
	 at t: value_in_sync;
prove:
	 at t_end: idle_0;
	 at t_end: report_out_sig = false;
	 at t_end: value = master_in1_sig_at_t;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	value_in_sig_at_t = value_in_sig@t,
	master_in1_sig_at_t = master_in1_sig@t;
assume: 
	 at t: idle_1;
	 at t: master_in1_sig;
	 at t: (value_in_sig = 0);
	 at t: value_in_sync;
prove:
	 at t_end: reading_3;
	 at t_end: report_out_sig = true;
	 at t_end: value = master_in1_sig_at_t;
	 at t_end: var = value_in_sig_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	master_in1_sig_at_t = master_in1_sig@t;
assume: 
	 at t: idle_1;
	 at t: not(master_in1_sig);
	 at t: (var = 0);
	 at t: not(value_in_sync);
prove:
	 at t_end: idle_0;
	 at t_end: report_out_sig = false;
	 at t_end: value = master_in1_sig_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property idle_1_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t,
	master_in1_sig_at_t = master_in1_sig@t;
assume: 
	 at t: idle_1;
	 at t: master_in1_sig;
	 at t: (var = 0);
	 at t: not(value_in_sync);
prove:
	 at t_end: reading_3;
	 at t_end: report_out_sig = true;
	 at t_end: value = master_in1_sig_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;

property reading_3_write_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	report_out_sig_at_t = report_out_sig@t,
	value_at_t = value@t,
	var_at_t = var@t;
assume: 
	 at t: reading_3;
prove:
	 at t_end: idle_0;
	 at t_end: report_out_sig = false;
	 at t_end: value = value_at_t;
	 at t_end: var = var_at_t;
	 during[t+1, t_end-1]: report_out_notify = false;
	 at t_end: report_out_notify = true;
	 during[t+1, t_end]: value_in_notify = false;
end property;
