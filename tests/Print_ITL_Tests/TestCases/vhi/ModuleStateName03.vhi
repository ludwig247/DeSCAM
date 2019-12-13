-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_sync : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro m_in_sig : signed := end macro;
macro m_out_sig : signed := end macro;
macro s_in_sig : signed := end macro;
macro s_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_2 : boolean := true end macro;
macro idle_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_1;
	 at t: s_out_sig = resize(0,32);
	 at t: m_out_notify = false;
end property;


property state_2_3 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t;
assume:
	at t: state_2;
	at t: s_in_sync;
prove:
	at t+1: idle_1;
	at t+1: m_out_sig = s_in_sig_at_t;
	at t+1: s_out_sig = s_in_sig_at_t;
	at t+1: m_out_notify = true;
end property;


property state_2_4 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_sync);
prove:
	at t+1: idle_1;
	at t+1: m_out_sig = m_in_sig_at_t;
	at t+1: s_out_sig = m_in_sig_at_t;
	at t+1: m_out_notify = true;
end property;


property idle_1_1 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: idle_1;
	at t: s_in_sync;
prove:
	at t+1: state_2;
	at t+1: m_out_sig = m_in_sig_at_t;
	at t+1: s_out_sig = m_in_sig_at_t;
	at t+1: m_out_notify = true;
end property;


property idle_1_2 is
dependencies: no_reset;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: idle_1;
	at t: not(s_in_sync);
prove:
	at t+1: state_2;
	at t+1: m_out_sig = m_in_sig_at_t;
	at t+1: s_out_sig = m_in_sig_at_t;
	at t+1: m_out_notify = true;
end property;


