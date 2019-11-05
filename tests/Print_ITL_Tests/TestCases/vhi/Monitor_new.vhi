-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro frame_pulse_sync : boolean := end macro;


-- DP SIGNALS --
macro config_in_sig_LOFreset : signed := end macro;
macro config_in_sig_LOFset : signed := end macro;
macro frame_pulse_sig : boolean := end macro;
macro lof_sig : boolean := end macro;
macro oof_sig : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : signed := end macro;
macro nextphase : Phases := end macro;
macro phase : Phases := end macro;


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
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t+1: state_1;
	at t+1: cnt = 0;
	at t+1: lof_sig = true;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
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
	at t+1: state_1;
	at t+1: cnt = (1 + cnt_at_t)(31 downto 0);
	at t+1: lof_sig = true;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
assume:
	at t: state_1;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (config_in_sig_LOFreset <= cnt);
	at t: not((phase = Monitor_N_LOF));
prove:
	at t+1: state_2;
	at t+1: cnt = 0;
	at t+1: lof_sig = false;
	at t+1: nextphase = Monitor_N_LOF;
	at t+1: phase = Monitor_N_LOF;
end property;


property state_1_8 is
dependencies: no_reset;
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
	at t+1: state_1;
	at t+1: cnt = cnt_at_t;
	at t+1: lof_sig = lof_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_2_9 is
dependencies: no_reset;
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
	at t+1: state_2;
	at t+1: cnt = (1 + cnt_at_t)(31 downto 0);
	at t+1: lof_sig = false;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_2_11 is
dependencies: no_reset;
assume:
	at t: state_2;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: (config_in_sig_LOFset <= cnt);
prove:
	at t+1: state_1;
	at t+1: cnt = 0;
	at t+1: lof_sig = true;
	at t+1: nextphase = Monitor_LOF;
	at t+1: phase = Monitor_LOF;
end property;


property state_2_13 is
dependencies: no_reset;
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t+1: state_2;
	at t+1: cnt = 0;
	at t+1: lof_sig = false;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_2_16 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: not(frame_pulse_sync);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t+1: state_2;
	at t+1: cnt = cnt_at_t;
	at t+1: lof_sig = lof_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


