-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := end macro;
macro b_in_notify : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_in_sig_data : signed := end macro;
macro b_in_sig_status : status_t := end macro;
macro m_out_sig : signed := end macro;
macro s_out_sig : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : signed := end macro;
macro msg_data : signed := end macro;
macro msg_status : status_t := end macro;
macro nextPhase : Phase := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: cnt = resize(0,32);
	 at t: msg_data = resize(0,32);
	 at t: msg_status = in_frame;
	 at t: nextPhase = idle;
	 at t: s_out_sig = false;
	 at t: b_in_notify = true;
	 at t: m_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: (b_in_sig_status = in_frame);
prove:
	at t_end: state_3;
	at t_end: cnt = 3;
	at t_end: m_out_sig = 3;
	at t_end: msg_data = b_in_sig_data_at_t;
	at t_end: msg_status = b_in_sig_status_at_t;
	at t_end: nextPhase = frame_start;
	at t_end: s_out_sig = true;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t,
	cnt_at_t = cnt@t,
	nextPhase_at_t = nextPhase@t;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((b_in_sig_status = in_frame));
	at t: (nextPhase = idle);
prove:
	at t_end: state_1;
	at t_end: cnt = cnt_at_t;
	at t_end: msg_data = b_in_sig_data_at_t;
	at t_end: msg_status = b_in_sig_status_at_t;
	at t_end: nextPhase = nextPhase_at_t;
	at t_end: s_out_sig = false;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: m_out_notify = false;
end property;


property state_3_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	at t: state_3;
	at t: (cnt = resize(1,32));
prove:
	at t_end: state_2;
	at t_end: cnt = 15;
	at t_end: msg_data = msg_data_at_t;
	at t_end: msg_status = msg_status_at_t;
	at t_end: nextPhase = frame_data;
	at t_end: s_out_sig = s_out_sig_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: m_out_notify = false;
end property;


property state_3_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	nextPhase_at_t = nextPhase@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	at t: state_3;
	at t: not((cnt = resize(1,32)));
	at t: (nextPhase = frame_start);
prove:
	at t_end: state_3;
	at t_end: cnt = (-1 + cnt_at_t)(31 downto 0);
	at t_end: m_out_sig = (-1 + cnt_at_t)(31 downto 0);
	at t_end: msg_data = msg_data_at_t;
	at t_end: msg_status = msg_status_at_t;
	at t_end: nextPhase = nextPhase_at_t;
	at t_end: s_out_sig = s_out_sig_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_2_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_data_at_t = b_in_sig_data@t,
	b_in_sig_status_at_t = b_in_sig_status@t,
	cnt_at_t = cnt@t,
	nextPhase_at_t = nextPhase@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	at t: state_2;
	at t: b_in_sync;
	at t: (nextPhase = frame_data);
prove:
	at t_end: state_2;
	at t_end: cnt = cnt_at_t;
	at t_end: msg_data = b_in_sig_data_at_t;
	at t_end: msg_status = b_in_sig_status_at_t;
	at t_end: nextPhase = nextPhase_at_t;
	at t_end: s_out_sig = s_out_sig_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: m_out_notify = false;
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t;
assume:
	at t: state_2;
	at t: not(b_in_sync);
	at t: (cnt = resize(0,32));
prove:
	at t_end: state_1;
	at t_end: cnt = (-1 + cnt_at_t)(31 downto 0);
	at t_end: m_out_sig = msg_data_at_t;
	at t_end: msg_data = msg_data_at_t;
	at t_end: msg_status = msg_status_at_t;
	at t_end: nextPhase = idle;
	at t_end: s_out_sig = false;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	nextPhase_at_t = nextPhase@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	at t: state_2;
	at t: not(b_in_sync);
	at t: not((cnt = resize(0,32)));
	at t: (nextPhase = frame_data);
prove:
	at t_end: state_2;
	at t_end: cnt = (-1 + cnt_at_t)(31 downto 0);
	at t_end: m_out_sig = msg_data_at_t;
	at t_end: msg_data = msg_data_at_t;
	at t_end: msg_status = msg_status_at_t;
	at t_end: nextPhase = nextPhase_at_t;
	at t_end: s_out_sig = s_out_sig_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t,
	msg_data_at_t = msg_data@t,
	msg_status_at_t = msg_status@t,
	nextPhase_at_t = nextPhase@t,
	s_out_sig_at_t = s_out_sig@t;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: cnt = cnt_at_t;
	at t+1: msg_data = msg_data_at_t;
	at t+1: msg_status = msg_status_at_t;
	at t+1: nextPhase = nextPhase_at_t;
	at t+1: s_out_sig = s_out_sig_at_t;
	at t+1: b_in_notify = true;
	at t+1: m_out_notify = false;
end property;


