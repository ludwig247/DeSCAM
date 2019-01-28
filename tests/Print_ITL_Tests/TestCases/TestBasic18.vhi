-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_out_sig_mode : Mode := end macro; 
macro b_out_sig_x : int := end macro; 
macro b_out_sig_y : bool := end macro; 
macro m_in_sig_mode : Mode := end macro; 
macro m_in_sig_x : int := end macro; 
macro m_in_sig_y : bool := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro compoundType_mode : Mode := end macro; 
macro compoundType_x : int := end macro; 
macro compoundType_y : bool := end macro; 


-- STATES -- 
macro SECTION_A_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_1;
	 at t: b_out_sig_mode = m_in_sig_mode;
	 at t: b_out_sig_x = m_in_sig_x;
	 at t: b_out_sig_y = m_in_sig_y;
	 at t: compoundType_mode = m_in_sig_mode;
	 at t: compoundType_x = m_in_sig_x;
	 at t: compoundType_y = m_in_sig_y;
	 at t: b_out_notify = true;
end property;


property SECTION_A_1_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	m_in_sig_mode_at_t = m_in_sig_mode@t,
	m_in_sig_x_at_t = m_in_sig_x@t,
	m_in_sig_y_at_t = m_in_sig_y@t;
assume: 
	 at t: SECTION_A_1;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_1;
	 at t_end: b_out_sig_mode = m_in_sig_mode_at_t;
	 at t_end: b_out_sig_x = m_in_sig_x_at_t;
	 at t_end: b_out_sig_y = m_in_sig_y_at_t;
	 at t_end: compoundType_mode = m_in_sig_mode_at_t;
	 at t_end: compoundType_x = m_in_sig_x_at_t;
	 at t_end: compoundType_y = m_in_sig_y_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property wait_SECTION_A_1 is
dependencies: no_reset;
freeze:
	compoundType_mode_at_t = compoundType_mode@t,
	compoundType_x_at_t = compoundType_x@t,
	compoundType_y_at_t = compoundType_y@t;
assume: 
	 at t: SECTION_A_1;
	 at t: not(b_out_sync);
prove:
	 at t+1: SECTION_A_1;
	 at t+1: b_out_sig_mode = compoundType_mode_at_t;
	 at t+1: b_out_sig_x = compoundType_x_at_t;
	 at t+1: b_out_sig_y = compoundType_y_at_t;
	 at t+1: compoundType_mode = compoundType_mode_at_t;
	 at t+1: compoundType_x = compoundType_x_at_t;
	 at t+1: compoundType_y = compoundType_y_at_t;
	 at t+1: b_out_notify = true;
end property;