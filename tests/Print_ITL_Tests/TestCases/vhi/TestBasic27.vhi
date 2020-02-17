-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro m_out_1_notify : boolean := end macro;
macro m_out_2_notify : boolean := end macro;
macro m_out_3_notify : boolean := end macro;


-- DP SIGNALS --
macro m_in_1_sig : signed := end macro;
macro m_in_2_sig : signed := end macro;
macro m_in_3_sig : signed := end macro;
macro m_out_1_sig : signed := end macro;
macro m_out_2_sig : signed := end macro;
macro m_out_3_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro data2 : signed := end macro;
macro data3 : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: data2 = m_in_2_sig;
	 at t: data3 = m_in_3_sig;
	 at t: m_out_1_notify = false;
	 at t: m_out_2_notify = false;
	 at t: m_out_3_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data2_at_t = data2@t,
	data3_at_t = data3@t,
	m_in_1_sig_at_t = m_in_1_sig@t;
assume:
	at t: state_1;
prove:
	at t_end: state_2;
	at t_end: data2 = data2_at_t;
	at t_end: data3 = data3_at_t;
	at t_end: m_out_1_sig = m_in_1_sig_at_t;
	at t_end: m_out_2_sig = data2_at_t;
	at t_end: m_out_3_sig = data3_at_t;
	during[t+1, t_end-1]: m_out_1_notify = false;
	at t_end: m_out_1_notify = true;
	during[t+1, t_end-1]: m_out_2_notify = false;
	at t_end: m_out_2_notify = true;
	during[t+1, t_end-1]: m_out_3_notify = false;
	at t_end: m_out_3_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_2_sig_at_t = m_in_2_sig@t,
	m_in_3_sig_at_t = m_in_3_sig@t;
assume:
	at t: state_2;
prove:
	at t_end: state_1;
	at t_end: data2 = m_in_2_sig_at_t;
	at t_end: data3 = m_in_3_sig_at_t;
	during[t+1, t_end]: m_out_1_notify = false;
	during[t+1, t_end]: m_out_2_notify = false;
	during[t+1, t_end]: m_out_3_notify = false;
end property;


