-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig_x : int := end macro; 
macro b_in_sig_y : unsigned := end macro; 
macro b_out_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- FUNCTIONS --
macro foo(record_var_x: int;record_var_y: unsigned) : unsigned := 
	if ((signed(record_var_y) < resize(20,32))) then unsigned(unsigned((shift_right(signed(record_var_y),signed((y and resize(31,32)))))))
	else unsigned(resize(0,32))
end if;
end macro; 



-- VISIBLE REGISTERS --
macro record_var_x : int := end macro; 
macro record_var_y : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: record_var_x = resize(0,32);
	 at t: record_var_y = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_x_at_t = b_in_sig_x@t,
	b_in_sig_y_at_t = b_in_sig_y@t;
assume: 
	 at t: run_0;
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = foo(b_in_sig_x_at_t,b_in_sig_y_at_t);
	 at t_end: record_var_x = b_in_sig_x_at_t;
	 at t_end: record_var_y = b_in_sig_y_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	record_var_x_at_t = record_var_x@t,
	record_var_y_at_t = record_var_y@t;
assume: 
	 at t: run_1;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: record_var_x = record_var_x_at_t;
	 at t_end: record_var_y = record_var_y_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	record_var_x_at_t = record_var_x@t,
	record_var_y_at_t = record_var_y@t;
assume: 
	 at t: run_0;
	 at t: not(b_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: record_var_x = record_var_x_at_t;
	 at t+1: record_var_y = record_var_y_at_t;
	 at t+1: b_in_notify = true;
	 at t+1: b_out_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	record_var_x_at_t = record_var_x@t,
	record_var_y_at_t = record_var_y@t;
assume: 
	 at t: run_1;
	 at t: not(b_out_sync);
prove:
	 at t+1: run_1;
	 at t+1: b_out_sig = foo(record_var_x_at_t,record_var_y_at_t);
	 at t+1: record_var_x = record_var_x_at_t;
	 at t+1: record_var_y = record_var_y_at_t;
	 at t+1: b_in_notify = false;
	 at t+1: b_out_notify = true;
end property;