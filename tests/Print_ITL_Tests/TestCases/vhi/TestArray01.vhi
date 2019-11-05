-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro m_in_sync : boolean := end macro;
macro m_out_sync : boolean := end macro;
macro m_in_notify : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro m_in_sig : signed := end macro;
macro m_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro regfile : int_2 := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: regfile(0) = resize(0,32);
	 at t: regfile(1) = resize(0,32);
	 at t: m_in_notify = true;
	 at t: m_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: state_1;
	at t: m_in_sync;
prove:
	at t_end: state_2;
	at t_end: m_out_sig = (1 + m_in_sig_at_t)(31 downto 0);
	at t_end: regfile(0) = (1 + m_in_sig_at_t)(31 downto 0);
	at t_end: regfile(1) = (1 + m_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: m_in_notify = false;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t;
assume:
	at t: state_2;
	at t: m_out_sync;
prove:
	at t_end: state_1;
	at t_end: regfile(0) = regfile_0_at_t;
	at t_end: regfile(1) = regfile_1_at_t;
	during[t+1, t_end-1]: m_in_notify = false;
	at t_end: m_in_notify = true;
	during[t+1, t_end]: m_out_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t;
assume:
	at t: state_1;
	at t: not(m_in_sync);
prove:
	at t+1: state_1;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: m_in_notify = true;
	at t+1: m_out_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	regfile_0_at_t = regfile(0)@t,
	regfile_1_at_t = regfile(1)@t;
assume:
	at t: state_2;
	at t: not(m_out_sync);
prove:
	at t+1: state_2;
	at t+1: m_out_sig = regfile_0_at_t;
	at t+1: regfile(0) = regfile_0_at_t;
	at t+1: regfile(1) = regfile_1_at_t;
	at t+1: m_in_notify = false;
	at t+1: m_out_notify = true;
end property;


