-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro m_out_1_notify : boolean := true end  macro;
macro m_out_2_notify : boolean := true end  macro;
macro m_out_3_notify : boolean := true end  macro;


-- DP SIGNALS --
macro m_in_1_sig : signed :=resize(0,32) end macro;
macro m_in_2_sig : signed :=resize(0,32) end macro;
macro m_in_3_sig : signed :=resize(0,32) end macro;
macro m_out_1_sig : signed :=resize(0,32) end macro;
macro m_out_2_sig : signed :=resize(0,32) end macro;
macro m_out_3_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: m_out_1_sig = m_in_1_sig;
	 at t: m_out_2_sig = m_in_2_sig;
	 at t: m_out_3_sig = m_in_3_sig;
	 at t: m_out_1_notify = true;
	 at t: m_out_2_notify = true;
	 at t: m_out_3_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_1_sig_at_t = m_in_1_sig@t,
	m_in_2_sig_at_t = m_in_2_sig@t,
	m_in_3_sig_at_t = m_in_3_sig@t;
assume:
	at t: state_1;
prove:
	at t_end: state_1;
	at t_end: m_out_1_sig = m_in_1_sig_at_t;
	at t_end: m_out_2_sig = m_in_2_sig_at_t;
	at t_end: m_out_3_sig = m_in_3_sig_at_t;
	during[t+1, t_end-1]: m_out_1_notify = false;
	at t_end: m_out_1_notify = true;
	during[t+1, t_end-1]: m_out_2_notify = false;
	at t_end: m_out_2_notify = true;
	during[t+1, t_end-1]: m_out_3_notify = false;
	at t_end: m_out_3_notify = true;
end property;


