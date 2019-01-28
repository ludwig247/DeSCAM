-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro s_in_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro s_in_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_A_1 : boolean := true end macro;
macro SECTION_B_2 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_0;
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_A_1;
end property;

property SECTION_A_0_read_1 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_0;
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_A_1;
end property;

property SECTION_A_1_read_2 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_1;
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_B_2;
end property;

property SECTION_A_1_read_3 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_1;
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_B_2;
end property;

property SECTION_B_2_read_4 is
dependencies: no_reset;
assume: 
	 at t: SECTION_B_2;
	 at t: s_in_sync;
prove:
	 at t+1: SECTION_A_0;
end property;

property SECTION_B_2_read_5 is
dependencies: no_reset;
assume: 
	 at t: SECTION_B_2;
	 at t: not(s_in_sync);
prove:
	 at t+1: SECTION_A_0;
end property;