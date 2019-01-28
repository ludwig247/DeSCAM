-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro s_in_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro s_in_sig : int := end macro; 
macro s_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro val : int := end macro; 


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_B_2 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: val = resize(0,32);
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume: 
	 at t: SECTION_A_0;
	 at t: (s_in_sig <= resize(10,32));
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = s_in_sig_at_t;
	 at t+1: val = s_in_sig_at_t;
end property;

property SECTION_A_0_read_1 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume: 
	 at t: SECTION_A_0;
	 at t: (s_in_sig >= resize(11,32));
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = s_in_sig_at_t;
	 at t+1: val = s_in_sig_at_t;
end property;

property SECTION_A_0_read_2 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: (val <= resize(10,32));
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = val_at_t;
	 at t+1: val = val_at_t;
end property;

property SECTION_A_0_read_3 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: (val >= resize(11,32));
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = val_at_t;
	 at t+1: val = val_at_t;
end property;

property SECTION_B_2_read_4 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume: 
	 at t: SECTION_B_2;
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (1 + s_in_sig_at_t)(31 downto 0);
	 at t+1: val = (1 + s_in_sig_at_t)(31 downto 0);
end property;

property SECTION_B_2_read_5 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_2;
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = (1 + val_at_t)(31 downto 0);
	 at t+1: val = (1 + val_at_t)(31 downto 0);
end property;