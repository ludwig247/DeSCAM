-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := end macro;
macro b_out_sync : boolean := end macro;
macro b_in_notify : boolean := end macro;
macro b_out_notify : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_in_sig : signed := end macro;
macro b_out_sig : signed := end macro;
macro m_in_sig : signed := end macro;
macro m_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro rspValue : signed := end macro;


-- STATES --
macro state_10 : boolean := true end macro;
macro state_18 : boolean := true end macro;
macro state_20 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_10;
	 at t: rspValue = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
	 at t: m_out_notify = false;
end property;


property state_10_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t,
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: state_10;
	at t: b_in_sync;
prove:
	at t_end: state_18;
	at t_end: b_out_sig = m_in_sig_at_t;
	at t_end: m_out_sig = b_in_sig_at_t;
	at t_end: rspValue = m_in_sig_at_t;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_18_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	rspValue_at_t = rspValue@t;
assume:
	at t: state_18;
	at t: b_out_sync;
prove:
	at t_end: state_10;
	at t_end: rspValue = rspValue_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end]: m_out_notify = false;
end property;


property wait_state_10 is
dependencies: no_reset;
freeze:
	rspValue_at_t = rspValue@t;
assume:
	at t: state_10;
	at t: not(b_in_sync);
prove:
	at t+1: state_10;
	at t+1: rspValue = rspValue_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
	at t+1: m_out_notify = false;
end property;


property wait_state_18 is
dependencies: no_reset;
freeze:
	rspValue_at_t = rspValue@t;
assume:
	at t: state_18;
	at t: not(b_out_sync);
prove:
	at t+1: state_18;
	at t+1: b_out_sig = rspValue_at_t;
	at t+1: rspValue = rspValue_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
	at t+1: m_out_notify = false;
end property;


