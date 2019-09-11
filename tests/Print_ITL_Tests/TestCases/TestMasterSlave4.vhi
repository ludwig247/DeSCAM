-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;
macro s_in2_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_sig : signed := end macro;
macro s_in2_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro SECTION_A_0 : boolean := true end macro;


-- OPERATIONS --
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
	at t: s_in2_sync;
prove:
	at t+1: SECTION_A_0;
end property;


property SECTION_A_0_read_1 is
dependencies: no_reset;
assume:
	at t: SECTION_A_0;
	at t: s_in_sync;
	at t: not(s_in2_sync);
prove:
	at t+1: SECTION_A_0;
end property;


property SECTION_A_0_read_2 is
dependencies: no_reset;
assume:
	at t: SECTION_A_0;
	at t: not(s_in_sync);
	at t: s_in2_sync;
prove:
	at t+1: SECTION_A_0;
end property;


property SECTION_A_0_read_3 is
dependencies: no_reset;
assume:
	at t: SECTION_A_0;
	at t: not(s_in_sync);
	at t: not(s_in2_sync);
prove:
	at t+1: SECTION_A_0;
end property;

