-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro m_in_sig : signed := end macro;
macro m_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro idle_1 : boolean := true end macro;
macro store_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_1;
	 at t: m_out_sig = m_in_sig;
	 at t: m_out_notify = true;
end property;


property idle_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: idle_1;
prove:
	at t_end: store_2;
	at t_end: m_out_sig = m_in_sig_at_t;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property store_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: store_2;
prove:
	at t_end: idle_1;
	at t_end: m_out_sig = m_in_sig_at_t;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


