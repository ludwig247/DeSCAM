-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro m_out_notify :  boolean  := end macro; 
macro s_in_sync   :  boolean  := end macro; 
macro s_in2_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro m_in_sig : int := end macro; 
macro m_out_sig : int := end macro; 
macro s_in_sig : int := end macro; 
macro s_in2_sig : int := end macro; 
macro s_out_sig : int := end macro; 
macro shared_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro save_val : int := end macro; 
macro succ : bool := end macro; 
macro val : int := end macro; 


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_B_4 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: s_out_sig = resize(0,32);
	 at t: save_val = resize(0,32);
	 at t: shared_out_sig = resize(0,32);
	 at t: succ = false;
	 at t: val = resize(0,32);
	 at t: m_out_notify = false;
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in2_sig_at_t = s_in2_sig@t,
	s_in_sig_at_t = s_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: m_out_sig = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: save_val = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: shared_out_sig = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_1 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in2_sig_at_t = s_in2_sig@t,
	s_in_sig_at_t = s_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_B_4;
	 at t+1: m_out_sig = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: save_val = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: shared_out_sig = (((save_val_at_t + s_in_sig_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_2 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in_sig_at_t = s_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: m_out_sig = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: s_out_sig = m_in_sig_at_t;
	 at t+1: save_val = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: shared_out_sig = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = m_in_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_3 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in_sig_at_t = s_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_B_4;
	 at t+1: m_out_sig = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: s_out_sig = m_in_sig_at_t;
	 at t+1: save_val = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: shared_out_sig = ((save_val_at_t + s_in_sig_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = m_in_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_4 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in2_sig_at_t = s_in2_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: m_out_sig = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: save_val = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: shared_out_sig = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_5 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	s_in2_sig_at_t = s_in2_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_B_4;
	 at t+1: m_out_sig = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: save_val = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: shared_out_sig = (((save_val_at_t + val_at_t)(31 downto 0) + m_in_sig_at_t)(31 downto 0) + s_in2_sig_at_t)(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_6 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: m_out_sig = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: s_out_sig = m_in_sig_at_t;
	 at t+1: save_val = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: shared_out_sig = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = m_in_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_A_0_read_7 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t,
	save_val_at_t = save_val@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_B_4;
	 at t+1: m_out_sig = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: s_out_sig = m_in_sig_at_t;
	 at t+1: save_val = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: shared_out_sig = ((save_val_at_t + val_at_t)(31 downto 0) + (2 * m_in_sig_at_t)(31 downto 0))(31 downto 0);
	 at t+1: succ = succ_at_t;
	 at t+1: val = m_in_sig_at_t;
	 at t+1: m_out_notify = true;
end property;

property SECTION_B_4_read_8 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	save_val_at_t = save_val@t,
	shared_out_sig_at_t = shared_out_sig@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_B_4;
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (4 * s_in2_sig_at_t)(31 downto 0);
	 at t+1: save_val = save_val_at_t;
	 at t+1: shared_out_sig = shared_out_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in2_sig_at_t)(31 downto 0);
	 at t+1: m_out_notify = false;
end property;

property SECTION_B_4_read_9 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	save_val_at_t = save_val@t,
	shared_out_sig_at_t = shared_out_sig@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_B_4;
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (4 * s_in_sig_at_t)(31 downto 0);
	 at t+1: save_val = save_val_at_t;
	 at t+1: shared_out_sig = shared_out_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in_sig_at_t)(31 downto 0);
	 at t+1: m_out_notify = false;
end property;

property SECTION_B_4_read_10 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	save_val_at_t = save_val@t,
	shared_out_sig_at_t = shared_out_sig@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_B_4;
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (4 * s_in2_sig_at_t)(31 downto 0);
	 at t+1: save_val = save_val_at_t;
	 at t+1: shared_out_sig = shared_out_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in2_sig_at_t)(31 downto 0);
	 at t+1: m_out_notify = false;
end property;

property SECTION_B_4_read_11 is
dependencies: no_reset;
freeze:
	save_val_at_t = save_val@t,
	shared_out_sig_at_t = shared_out_sig@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_4;
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (4 * val_at_t)(31 downto 0);
	 at t+1: save_val = save_val_at_t;
	 at t+1: shared_out_sig = shared_out_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * val_at_t)(31 downto 0);
	 at t+1: m_out_notify = false;
end property;