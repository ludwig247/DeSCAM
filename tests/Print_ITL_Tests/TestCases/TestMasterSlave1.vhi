-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 


-- DP SIGNALS -- 
macro s_out_sig : int := end macro; 


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
	 at t: s_out_sig = resize(1337,32);
end property;


property SECTION_A_0_write_0 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_0;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = 1337;
end property;