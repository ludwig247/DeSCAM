-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;
macro s_in2_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_sig : signed := end macro;
macro s_in2_sig : signed := end macro;


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
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: s_in2_sync;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: phase = SECTION_A;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not(s_in2_sync);
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: phase = SECTION_A;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: s_in2_sync;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: phase = SECTION_A;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: not(s_in2_sync);
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: phase = SECTION_A;
end property;


