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
	if(N_LOF_1) then monitor_comp/oof_cnt;
	else monitor_comp/if_cnt;
	end if;
end macro; 

-- STATES --
macro N_LOF_1 : boolean := not(monitor_comp/lof) end macro;
macro LOF_0 : boolean := monitor_comp/lof end macro;

--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: N_LOF_1;
	 at t: cnt = 0;
	 at t: lof_sig = false;
end property;


property LOF_0_read_0 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t;
assume: 
	 at t: LOF_0;
	 at t: not(frame_pulse_sync);
prove:
	 at t+1: LOF_0;
	 at t+1: cnt = cnt_at_t;
	 at t+1: lof_sig = lof_sig_at_t;
end property;

property LOF_0_read_1 is
dependencies: no_reset;
assume: 
	 at t: LOF_0;
	 at t: frame_pulse_sync;
	 at t: oof_sig;
	 at t: frame_pulse_sync;
prove:
	 at t+1: LOF_0;
	 at t+1: cnt = 0;
	 at t+1: lof_sig = true;
end property;

property LOF_0_read_2 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: LOF_0;
	 at t: frame_pulse_sync;
	 at t: not(oof_sig);
	 at t: not((config_in_sig_LOFreset <= cnt));
	 at t: frame_pulse_sync;
prove:
	 at t+1: LOF_0;
	 at t+1: cnt = (1 + cnt_at_t);
	 at t+1: lof_sig = true;
end property;

property LOF_0_read_3 is
dependencies: no_reset;
assume: 
	 at t: LOF_0;
	 at t: frame_pulse_sync;
	 at t: not(oof_sig);
	 at t: (config_in_sig_LOFreset <= cnt);
	 at t: frame_pulse_sync;
prove:
	 at t+1: N_LOF_1;
	 at t+1: cnt = 0;
	 at t+1: lof_sig = false;
end property;

property N_LOF_1_read_4 is
dependencies: no_reset;
assume: 
	 at t: N_LOF_1;
	 at t: frame_pulse_sync;
	 at t: oof_sig;
	 at t: (config_in_sig_LOFset <= cnt);
	 at t: frame_pulse_sync;
prove:
	 at t+1: LOF_0;
	 at t+1: cnt = 0;
	 at t+1: lof_sig = true;
end property;

property N_LOF_1_read_5 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	lof_sig_at_t = lof_sig@t;
assume: 
	 at t: N_LOF_1;
	 at t: not(frame_pulse_sync);
prove:
	 at t+1: N_LOF_1;
	 at t+1: cnt = cnt_at_t;
	 at t+1: lof_sig = lof_sig_at_t;
end property;

property N_LOF_1_read_6 is
dependencies: no_reset;
assume: 
	 at t: N_LOF_1;
	 at t: frame_pulse_sync;
	 at t: not(oof_sig);
	 at t: frame_pulse_sync;
prove:
	 at t+1: N_LOF_1;
	 at t+1: cnt = 0;
	 at t+1: lof_sig = false;
end property;

property N_LOF_1_read_7 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: N_LOF_1;
	 at t: frame_pulse_sync;
	 at t: oof_sig;
	 at t: not((config_in_sig_LOFset <= cnt));
	 at t: frame_pulse_sync;
prove:
	 at t+1: N_LOF_1;
	 at t+1: cnt = (1 + cnt_at_t);
	 at t+1: lof_sig = false;
end property;
