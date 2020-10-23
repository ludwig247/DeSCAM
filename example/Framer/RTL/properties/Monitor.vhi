-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro frame_pulse_sync: boolean :=  monitor_comp/frame_pulse end macro;


-- DP SIGNALS --
macro frame_pulse_sig : bool := monitor_comp/frame_pulse end macro;
macro lof_sig : bool := monitor_comp/lof end macro;
macro oof_sig : bool := not(monitor_comp/synchronized)end macro;
macro config_in_sig_LOFreset : unsigned := monitor_comp/lof_reset  end macro;
macro config_in_sig_LOFset : unsigned := monitor_comp/lof_set end macro;

--CONSTRAINTS--
constraint no_reset := reset_n = '1'; end constraint;

-- VISIBLE REGISTERS --
macro cnt : natural :=
	if(state_25) then monitor_comp/oof_cnt;
	else monitor_comp/if_cnt;
	end if;
end macro;
macro nextphase : Phases_Monitor :=
	if(state_16) then Monitor_LOF;
--	elsif (state_25) then Monitor_N_LOF;
	else Monitor_N_LOF;
	end if;
end macro;
macro phase : Phases_Monitor :=
	if(state_16) then Monitor_LOF;
--	elsif (state_25) then Monitor_N_LOF;
	else Monitor_N_LOF;
	end if;
end macro;


-- STATES --
macro state_16 : boolean := monitor_comp/lof end macro;
macro state_25 : boolean := not(monitor_comp/lof) end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_25;
	 at t: cnt = resize(0,32);
	 at t: lof_sig = false;
	 at t: nextphase = Monitor_N_LOF;
	 at t: phase = Monitor_N_LOF;
end property;


property state_16_1 is
dependencies: no_reset;
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_16;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t+1: state_16;
	at t+1: cnt = 0;
	at t+1: lof_sig = true;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_16_3 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_16;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: not((config_in_sig_LOFreset <= cnt));
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t+1: state_16;
	at t+1: cnt = (1 + cnt_at_t)(31 downto 0);
	at t+1: lof_sig = true;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_16_5 is
dependencies: no_reset;
assume:
	at t: state_16;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (config_in_sig_LOFreset <= cnt);
	at t: not((phase = Monitor_N_LOF));
prove:
	at t+1: state_25;
	at t+1: cnt = 0;
	at t+1: lof_sig = false;
	at t+1: nextphase = Monitor_N_LOF;
	at t+1: phase = Monitor_N_LOF;
end property;


property state_16_8 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_16;
	at t: not(frame_pulse_sync);
	at t: not((phase = Monitor_N_LOF));
	at t: (nextphase = Monitor_LOF);
prove:
	at t+1: state_16;
	at t+1: cnt = cnt_at_t;
	at t+1: lof_sig = lof_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_25_9 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_25;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: not((config_in_sig_LOFset <= cnt));
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t+1: state_25;
	at t+1: cnt = (1 + cnt_at_t)(31 downto 0);
	at t+1: lof_sig = false;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_25_11 is
dependencies: no_reset;
assume:
	at t: state_25;
	at t: frame_pulse_sync;
	at t: oof_sig;
	at t: (config_in_sig_LOFset <= cnt);
prove:
	at t+1: state_16;
	at t+1: cnt = 0;
	at t+1: lof_sig = true;
	at t+1: nextphase = Monitor_LOF;
	at t+1: phase = Monitor_LOF;
end property;


property state_25_13 is
dependencies: no_reset;
freeze:
	nextphase_at_t = nextphase@t;
assume:
	at t: state_25;
	at t: frame_pulse_sync;
	at t: not(oof_sig);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t+1: state_25;
	at t+1: cnt = 0;
	at t+1: lof_sig = false;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


property state_25_16 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_25;
	at t: not(frame_pulse_sync);
	at t: (nextphase = Monitor_N_LOF);
prove:
	at t+1: state_25;
	at t+1: cnt = cnt_at_t;
	at t+1: lof_sig = lof_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: phase = nextphase_at_t;
end property;


