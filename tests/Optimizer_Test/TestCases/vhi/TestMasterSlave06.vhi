-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro phase : Phases := end macro;


-- STATES --
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: phase = SECTION_A;
end property;


property state_2_3 is
dependencies: no_reset;
assume:
	at t: state_2;
	at t: s_in_sync;
	at t: not((phase = SECTION_B));
prove:
	at t+1: state_3;
	at t+1: phase = SECTION_B;
end property;


property state_2_4 is
dependencies: no_reset;
assume:
	at t: state_2;
	at t: not(s_in_sync);
	at t: not((phase = SECTION_B));
prove:
	at t+1: state_3;
	at t+1: phase = SECTION_B;
end property;


property state_3_5 is
dependencies: no_reset;
assume:
	at t: state_3;
	at t: s_in_sync;
prove:
	at t+1: state_1;
	at t+1: phase = SECTION_A;
end property;


property state_3_6 is
dependencies: no_reset;
assume:
	at t: state_3;
	at t: not(s_in_sync);
prove:
	at t+1: state_1;
	at t+1: phase = SECTION_A;
end property;


property state_1_1 is
dependencies: no_reset;
freeze:
	phase_at_t = phase@t;
assume:
	at t: state_1;
	at t: s_in_sync;
prove:
	at t+1: state_2;
	at t+1: phase = phase_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
freeze:
	phase_at_t = phase@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
prove:
	at t+1: state_2;
	at t+1: phase = phase_at_t;
end property;


