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


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: s_out_sig = resize(0,32);
	 at t: val = resize(0,32);
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume: 
	 at t: SECTION_A_0;
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = s_in_sig_at_t;
	 at t+1: val = s_in_sig_at_t;
end property;

property SECTION_A_0_read_1 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = val_at_t;
	 at t+1: val = val_at_t;
end property;