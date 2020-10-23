-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro frame_pulse_sync : boolean := true end macro;


-- DP SIGNALS --
--macro config_in_sig : Config :={resize(0,32), resize(0,32)} end macro;
macro config_in_sig_LOFreset : signed :=resize(0,32) end macro;
macro config_in_sig_LOFset : signed :=resize(0,32) end macro;
macro frame_pulse_sig : boolean :=false end macro;
macro lof_sig : boolean :=false end macro;
macro oof_sig : boolean :=false end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : signed :=resize(0,32) end macro;
macro nextphase : Phases :=Monitor_LOF end macro;
macro phase : Phases :=Monitor_LOF end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_2;
	 at t: cnt = resize(0,32);
	 at t: lof_sig = false;
	 at t: nextphase = Monitor_N_LOF;
	 at t: phase = Monitor_N_LOF;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t_end: state_1;
	at t_end: cnt = 0;
	at t_end: lof_sig = true;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: not((config_in_sig_LOFreset <= cnt));
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t_end: state_1;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: lof_sig = true;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (config_in_sig_LOFreset <= cnt);
	at t: not((phase = Monitor_N_LOF));
prove:
	at t_end: state_2;
	at t_end: cnt = 0;
	at t_end: lof_sig = false;
	at t_end: nextphase = Monitor_N_LOF;
	at t_end: phase = Monitor_N_LOF;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: not(frame_pulse_sync);
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t_end: state_1;
	at t_end: cnt = cnt_at_t;
	at t_end: lof_sig = lof_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


property state_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_2;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: (config_in_sig_LOFset <= cnt);
prove:
	at t_end: state_1;
	at t_end: cnt = 0;
	at t_end: lof_sig = true;
	at t_end: nextphase = Monitor_LOF;
	at t_end: phase = Monitor_LOF;
end property;


property state_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t_end: state_2;
	at t_end: cnt = 0;
	at t_end: lof_sig = false;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


property state_2_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: not(frame_pulse_sync);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t_end: state_2;
	at t_end: cnt = cnt_at_t;
	at t_end: lof_sig = lof_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: not((config_in_sig_LOFset <= cnt));
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t_end: state_2;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: lof_sig = false;
	at t_end: nextphase = nextphase_at_t;
	at t_end: phase = nextphase_at_t;
end property;


