-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_sig : signed := end macro;
macro sh_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro phase : Phases := end macro;
macro val : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: phase = SECTION_A;
	 at t: sh_out_sig = resize(0,32);
	 at t: val = resize(0,32);
end property;


property state_1_1 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not((phase = SECTION_B));
prove:
	at t+1: state_1;
	at t+1: phase = SECTION_A;
	at t+1: sh_out_sig = s_in_sig_at_t;
	at t+1: val = s_in_sig_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: not((phase = SECTION_B));
prove:
	at t+1: state_1;
	at t+1: phase = SECTION_A;
	at t+1: sh_out_sig = val_at_t;
	at t+1: val = val_at_t;
end property;


