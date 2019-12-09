-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro s_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro phase : Phases := end macro;


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: phase = SECTION_A;
	 at t: s_out_sig = resize(0,32);
end property;


property state_1_1 is
dependencies: no_reset;
assume:
	at t: state_1;
	at t: not((phase = SECTION_B));
prove:
	at t+1: state_1;
	at t+1: phase = SECTION_A;
	at t+1: s_out_sig = 1337;
end property;


