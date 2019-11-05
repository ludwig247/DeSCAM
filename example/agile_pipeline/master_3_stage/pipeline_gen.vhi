-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro m_out1_notify : boolean := end macro;
--macro m_out2_notify : boolean := end macro;


-- DP SIGNALS --
--macro m_in_sig : signed := end macro;
--macro m_out1_sig : signed := end macro;
--macro m_out2_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
--macro x : signed := end macro;


-- STATES --
macro run_0 : boolean := true end macro;
macro run_1 : boolean := m_out1_notify = true end macro;
macro run_2 : boolean := m_out1_notify = true and m_out2_notify = true end macro;
macro run_3 : boolean := m_out1_notify = true and m_out2_notify = true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: x = resize(0,32);
	 at t: m_out1_notify = false;
	 at t: m_out2_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: run_0;
prove:
	at t_end: run_1;
	at t_end: m_out1_sig = m_in_sig_at_t;
	at t_end: x = m_in_sig_at_t;
	--during[t+1, t_end-1]: m_out1_notify = false;
	--at t_end: m_out1_notify = true;
	--during[t+1, t_end]: m_out2_notify = false;
end property;


property run_1_write_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	x_at_t = x@t;
assume:
	at t: run_1;
	at t: (x >= resize(1,32));
prove:
	at t_end: run_2;
	at t_end: m_out2_sig = x_at_t;
	at t_end: x = x_at_t;
	--during[t+1, t_end]: m_out1_notify = false;
	--during[t+1, t_end-1]: m_out2_notify = false;
	--at t_end: m_out2_notify = true;
end property;


property run_1_write_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	x_at_t = x@t;
assume:
	at t: run_1;
	at t: (x <= resize(0,32));
prove:
	at t_end: run_3;
	at t_end: m_out2_sig = 1;
	at t_end: x = x_at_t;
	--during[t+1, t_end]: m_out1_notify = false;
	--during[t+1, t_end-1]: m_out2_notify = false;
	--at t_end: m_out2_notify = true;
end property;


property run_2_write_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	x_at_t = x@t;
assume:
	at t: run_2;
prove:
	at t_end: run_0;
	at t_end: x = x_at_t;
	--during[t+1, t_end]: m_out1_notify = false;
	--during[t+1, t_end]: m_out2_notify = false;
end property;


property run_3_write_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	x_at_t = x@t;
assume:
	at t: run_3;
prove:
	at t_end: run_0;
	at t_end: x = x_at_t;
	--during[t+1, t_end]: m_out1_notify = false;
	--during[t+1, t_end]: m_out2_notify = false;
end property;


