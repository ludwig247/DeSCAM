-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro m_out_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro m_out_sig_x : int := end macro; 
macro m_out_sig_y : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro test_x : int := end macro; 
macro test_y : unsigned := end macro; 
macro test2 : unsigned := end macro; 


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_A_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: m_out_sig_x = resize(0,32);
	 at t: m_out_sig_y = resize(31,32);
	 at t: test_x = resize(0,32);
	 at t: test_y = resize(31,32);
	 at t: test2 = resize(31,32);
	 at t: m_out_notify = true;
end property;


property SECTION_A_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	test2_at_t = test2@t,
	test_x_at_t = test_x@t;
assume: 
	 at t: SECTION_A_0;
	 at t: (test2 > resize(10,32));
prove:
	 at t_end: SECTION_A_0;
	 at t_end: m_out_sig_x = test_x_at_t;
	 at t_end: m_out_sig_y = (1 + test2_at_t)(31 downto 0);
	 at t_end: test_x = test_x_at_t;
	 at t_end: test_y = (1 + test2_at_t)(31 downto 0);
	 at t_end: test2 = (1 + test2_at_t)(31 downto 0);
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property SECTION_A_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	test2_at_t = test2@t,
	test_x_at_t = test_x@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not((test2 > resize(10,32)));
prove:
	 at t_end: SECTION_A_1;
	 at t_end: m_out_sig_x = test_x_at_t;
	 at t_end: m_out_sig_y = test2_at_t;
	 at t_end: test_x = test_x_at_t;
	 at t_end: test_y = test2_at_t;
	 at t_end: test2 = (1 + test2_at_t)(31 downto 0);
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property SECTION_A_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	test2_at_t = test2@t,
	test_x_at_t = test_x@t;
assume: 
	 at t: SECTION_A_1;
	 at t: (test2 > resize(10,32));
prove:
	 at t_end: SECTION_A_0;
	 at t_end: m_out_sig_x = test_x_at_t;
	 at t_end: m_out_sig_y = (1 + test2_at_t)(31 downto 0);
	 at t_end: test_x = test_x_at_t;
	 at t_end: test_y = (1 + test2_at_t)(31 downto 0);
	 at t_end: test2 = (1 + test2_at_t)(31 downto 0);
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property SECTION_A_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	test2_at_t = test2@t,
	test_x_at_t = test_x@t;
assume: 
	 at t: SECTION_A_1;
	 at t: not((test2 > resize(10,32)));
prove:
	 at t_end: SECTION_A_1;
	 at t_end: m_out_sig_x = test_x_at_t;
	 at t_end: m_out_sig_y = test2_at_t;
	 at t_end: test_x = test_x_at_t;
	 at t_end: test_y = test2_at_t;
	 at t_end: test2 = (1 + test2_at_t)(31 downto 0);
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;