-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig : signed := end macro; 
macro b_out_sig : int_2 := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro test : signed := end macro; 
macro myArray : int_2 := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: myArray(1) = resize(0,32);
	 at t: test = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t,
	myArray_1_at_t = myArray(1)@t;
assume: 
	 at t: run_0;
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig_0 = (b_in_sig_at_t + myArray_1_at_t)(31 downto 0);
	 at t_end: b_out_sig_1 = b_in_sig_at_t;
	 at t_end: myArray(1) = b_in_sig_at_t;
	 at t_end: test = b_in_sig_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	myArray_1_at_t = myArray(1)@t,
	test_at_t = test@t;
assume: 
	 at t: run_0;
	 at t: not(b_in_sync);
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig_0 = (test_at_t + myArray_1_at_t)(31 downto 0);
	 at t_end: b_out_sig_1 = test_at_t;
	 at t_end: myArray(1) = test_at_t;
	 at t_end: test = test_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	myArray_1_at_t = myArray(1)@t,
	test_at_t = test@t;
assume: 
	 at t: run_1;
	 at t: not(b_out_sync);
prove:
	 at t_end: run_0;
	 at t_end: myArray(1) = myArray_1_at_t;
	 at t_end: test = test_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property run_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	myArray_1_at_t = myArray(1)@t,
	test_at_t = test@t;
assume: 
	 at t: run_1;
	 at t: b_out_sync;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: myArray(1) = (1 + myArray_1_at_t)(31 downto 0);
	 at t_end: test = test_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;