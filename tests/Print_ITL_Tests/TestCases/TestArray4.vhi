-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro m_in_notify :  boolean  := end macro; 
macro m_in_sync   :  boolean  := end macro; 
macro m_out_notify :  boolean  := end macro; 
macro m_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro m_in_sig : signed := end macro; 
macro m_out_sig : int_5 := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro myArray : int_5 := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: myArray(0) = resize(0,32);
	 at t: myArray(1) = resize(0,32);
	 at t: myArray(2) = resize(0,32);
	 at t: myArray(3) = resize(0,32);
	 at t: myArray(4) = resize(0,32);
	 at t: m_in_notify = true;
	 at t: m_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	myArray_1_at_t = myArray(1)@t,
	myArray_2_at_t = myArray(2)@t,
	myArray_3_at_t = myArray(3)@t,
	myArray_4_at_t = myArray(4)@t;
assume: 
	 at t: run_0;
	 at t: m_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: m_out_sig_0 = m_in_sig_at_t;
	 at t_end: m_out_sig_1 = myArray_1_at_t;
	 at t_end: m_out_sig_2 = myArray_2_at_t;
	 at t_end: m_out_sig_3 = myArray_3_at_t;
	 at t_end: m_out_sig_4 = myArray_4_at_t;
	 at t_end: myArray(0) = m_in_sig_at_t;
	 at t_end: myArray(1) = myArray_1_at_t;
	 at t_end: myArray(2) = myArray_2_at_t;
	 at t_end: myArray(3) = myArray_3_at_t;
	 at t_end: myArray(4) = myArray_4_at_t;
	 during[t+1, t_end]: m_in_notify = false;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property run_1_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	myArray_0_at_t = myArray(0)@t,
	myArray_1_at_t = myArray(1)@t,
	myArray_2_at_t = myArray(2)@t,
	myArray_3_at_t = myArray(3)@t,
	myArray_4_at_t = myArray(4)@t;
assume: 
	 at t: run_1;
	 at t: m_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: myArray(0) = myArray_0_at_t;
	 at t_end: myArray(1) = myArray_1_at_t;
	 at t_end: myArray(2) = myArray_2_at_t;
	 at t_end: myArray(3) = myArray_3_at_t;
	 at t_end: myArray(4) = myArray_4_at_t;
	 during[t+1, t_end-1]: m_in_notify = false;
	 at t_end: m_in_notify = true;
	 during[t+1, t_end]: m_out_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	myArray_0_at_t = myArray(0)@t,
	myArray_1_at_t = myArray(1)@t,
	myArray_2_at_t = myArray(2)@t,
	myArray_3_at_t = myArray(3)@t,
	myArray_4_at_t = myArray(4)@t;
assume: 
	 at t: run_0;
	 at t: not(m_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: myArray(0) = myArray_0_at_t;
	 at t+1: myArray(1) = myArray_1_at_t;
	 at t+1: myArray(2) = myArray_2_at_t;
	 at t+1: myArray(3) = myArray_3_at_t;
	 at t+1: myArray(4) = myArray_4_at_t;
	 at t+1: m_in_notify = true;
	 at t+1: m_out_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	myArray_0_at_t = myArray(0)@t,
	myArray_1_at_t = myArray(1)@t,
	myArray_2_at_t = myArray(2)@t,
	myArray_3_at_t = myArray(3)@t,
	myArray_4_at_t = myArray(4)@t;
assume: 
	 at t: run_1;
	 at t: not(m_out_sync);
prove:
	 at t+1: run_1;
	 at t+1: m_out_sig_0 = myArray_0_at_t;
	 at t+1: m_out_sig_1 = myArray_1_at_t;
	 at t+1: m_out_sig_2 = myArray_2_at_t;
	 at t+1: m_out_sig_3 = myArray_3_at_t;
	 at t+1: m_out_sig_4 = myArray_4_at_t;
	 at t+1: myArray(0) = myArray_0_at_t;
	 at t+1: myArray(1) = myArray_1_at_t;
	 at t+1: myArray(2) = myArray_2_at_t;
	 at t+1: myArray(3) = myArray_3_at_t;
	 at t+1: myArray(4) = myArray_4_at_t;
	 at t+1: m_in_notify = false;
	 at t+1: m_out_notify = true;
end property;