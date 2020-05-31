-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := true end macro;
macro s_in2_sync : boolean := true end macro;


-- DP SIGNALS --
macro s_in_sig : signed :=resize(0,32) end macro;
macro s_in2_sig : signed :=resize(0,32) end macro;
macro sh_out_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro nextphase : Phases :=SECTION_A end macro;
macro phase : Phases :=SECTION_A end macro;
macro succ : boolean :=false end macro;
macro val : signed :=resize(0,32) end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: nextphase = SECTION_A;
	 at t: phase = SECTION_A;
	 at t: sh_out_sig = resize(0,32);
	 at t: succ = false;
	 at t: val = resize(0,32);
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: s_in2_sync;
	at t: succ;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_2;
	at t_end: nextphase = SECTION_B;
	at t_end: phase = SECTION_B;
	at t_end: sh_out_sig = s_in2_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in2_sig_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not(s_in2_sync);
	at t: succ;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_2;
	at t_end: nextphase = SECTION_B;
	at t_end: phase = SECTION_B;
	at t_end: sh_out_sig = s_in_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in_sig_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: s_in2_sync;
	at t: succ;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_2;
	at t_end: nextphase = SECTION_B;
	at t_end: phase = SECTION_B;
	at t_end: sh_out_sig = s_in2_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in2_sig_at_t;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	succ_at_t = succ@t,
	val_at_t = val@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: not(s_in2_sync);
	at t: succ;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_2;
	at t_end: nextphase = SECTION_B;
	at t_end: phase = SECTION_B;
	at t_end: sh_out_sig = val_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = val_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: s_in2_sync;
	at t: not(succ);
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
	at t_end: sh_out_sig = s_in2_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in2_sig_at_t;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	s_in_sig_at_t = s_in_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: s_in_sync;
	at t: not(s_in2_sync);
	at t: not(succ);
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
	at t_end: sh_out_sig = s_in_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in_sig_at_t;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: s_in2_sync;
	at t: not(succ);
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
	at t_end: sh_out_sig = s_in2_sig_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = s_in2_sig_at_t;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume:
	at t: state_1;
	at t: not(s_in_sync);
	at t: not(s_in2_sync);
	at t: not(succ);
	at t: not((phase = SECTION_B));
	at t: (nextphase = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
	at t_end: sh_out_sig = val_at_t;
	at t_end: succ = succ_at_t;
	at t_end: val = val_at_t;
end property;


property state_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_2;
	at t: s_in_sync;
	at t: not(s_in2_sync);
prove:
	at t_end: state_1;
	at t_end: nextphase = SECTION_A;
	at t_end: phase = SECTION_A;
	at t_end: sh_out_sig = (4 * s_in_sig_at_t)(31 downto 0);
	at t_end: succ = succ_at_t;
	at t_end: val = (2 * s_in_sig_at_t)(31 downto 0);
end property;


property state_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_2;
	at t: not(s_in_sync);
	at t: s_in2_sync;
prove:
	at t_end: state_1;
	at t_end: nextphase = SECTION_A;
	at t_end: phase = SECTION_A;
	at t_end: sh_out_sig = (4 * s_in2_sig_at_t)(31 downto 0);
	at t_end: succ = succ_at_t;
	at t_end: val = (2 * s_in2_sig_at_t)(31 downto 0);
end property;


property state_2_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	succ_at_t = succ@t,
	val_at_t = val@t;
assume:
	at t: state_2;
	at t: not(s_in_sync);
	at t: not(s_in2_sync);
prove:
	at t_end: state_1;
	at t_end: nextphase = SECTION_A;
	at t_end: phase = SECTION_A;
	at t_end: sh_out_sig = (4 * val_at_t)(31 downto 0);
	at t_end: succ = succ_at_t;
	at t_end: val = (2 * val_at_t)(31 downto 0);
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	succ_at_t = succ@t;
assume:
	at t: state_2;
	at t: s_in_sync;
	at t: s_in2_sync;
prove:
	at t_end: state_1;
	at t_end: nextphase = SECTION_A;
	at t_end: phase = SECTION_A;
	at t_end: sh_out_sig = (4 * s_in2_sig_at_t)(31 downto 0);
	at t_end: succ = succ_at_t;
	at t_end: val = (2 * s_in2_sig_at_t)(31 downto 0);
end property;


