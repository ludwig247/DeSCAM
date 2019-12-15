-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_sig : signed := end macro;
macro s_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro nextphase : Phases := end macro;
macro phase : Phases := end macro;
macro val : signed := end macro;


-- STATES --
macro state_2 : boolean := true end macro;
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: nextphase = SECTION_A;
	 at t: phase = SECTION_A;
	 at t: s_out_sig = resize(0,32);
	 at t: val = resize(0,32);
end property;


property state_2_5 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume:
	at t: state_2;
	at t: s_in_sync;
prove:
	at t+1: state_1;
	at t+1: nextphase = SECTION_A;
	at t+1: phase = SECTION_A;
	at t+1: s_out_sig = (1 + s_in_sig_at_t)(31 downto 0);
	at t+1: val = (1 + s_in_sig_at_t)(31 downto 0);
end property;


property state_2_6 is
dependencies: no_reset;
freeze:
	val_at_t = val@t;
assume:
	at t: state_2;
	at t: not(s_in_sync);
prove:
	at t+1: state_1;
	at t+1: nextphase = SECTION_A;
	at t+1: phase = SECTION_A;
	at t+1: s_out_sig = (1 + val_at_t)(31 downto 0);
	at t+1: val = (1 + val_at_t)(31 downto 0);
end property;


property state_1_1 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not((phase = SECTION_B));
	at t: (s_in_sig >= resize(11,32));
prove:
	at t+1: state_2;
	at t+1: nextphase = SECTION_B;
	at t+1: phase = SECTION_B;
	at t+1: s_out_sig = s_in_sig_at_t;
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
	at t: (val >= resize(11,32));
prove:
	at t+1: state_2;
	at t+1: nextphase = SECTION_B;
	at t+1: phase = SECTION_B;
	at t+1: s_out_sig = val_at_t;
	at t+1: val = val_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
freeze:
	nextphase_at_t = nextphase@t,
	s_in_sig_at_t = s_in_sig@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
	at t: (s_in_sig <= resize(10,32));
prove:
	at t+1: state_1;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
	at t+1: s_out_sig = s_in_sig_at_t;
	at t+1: val = s_in_sig_at_t;
end property;


property state_1_4 is
dependencies: no_reset;
freeze:
	nextphase_at_t = nextphase@t,
	val_at_t = val@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
	at t: (val <= resize(10,32));
prove:
	at t+1: state_1;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
	at t+1: s_out_sig = val_at_t;
	at t+1: val = val_at_t;
end property;


