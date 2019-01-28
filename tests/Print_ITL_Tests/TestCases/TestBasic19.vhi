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


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: b_out_sig_mode = READ;
	 at t: b_out_sig_x = resize(0,32);
	 at t: b_out_sig_y = false;
	 at t: b_out_notify = true;
end property;


property SECTION_A_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	m_in_sig_mode_at_t = m_in_sig_mode@t,
	m_in_sig_x_at_t = m_in_sig_x@t,
	m_in_sig_y_at_t = m_in_sig_y@t;
assume: 
	 at t: SECTION_A_0;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig_mode = m_in_sig_mode_at_t;
	 at t_end: b_out_sig_x = m_in_sig_x_at_t;
	 at t_end: b_out_sig_y = m_in_sig_y_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property SECTION_A_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	m_in_sig_mode_at_t = m_in_sig_mode@t,
	m_in_sig_x_at_t = m_in_sig_x@t,
	m_in_sig_y_at_t = m_in_sig_y@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(b_out_sync);
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig_mode = m_in_sig_mode_at_t;
	 at t_end: b_out_sig_x = m_in_sig_x_at_t;
	 at t_end: b_out_sig_y = m_in_sig_y_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;