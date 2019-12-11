-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := end macro;
macro b_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_out_sig_mode : Mode := end macro;
macro b_out_sig_x : signed := end macro;
macro b_out_sig_y : boolean := end macro;
macro m_in_sig_mode : Mode := end macro;
macro m_in_sig_x : signed := end macro;
macro m_in_sig_y : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro phase : Phases := end macro;


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: b_out_sig_mode = m_in_sig_mode;
	 at t: b_out_sig_x = m_in_sig_x;
	 at t: b_out_sig_y = m_in_sig_y;
	 at t: phase = SECTION_A;
	 at t: b_out_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_mode_at_t = m_in_sig_mode@t,
	m_in_sig_x_at_t = m_in_sig_x@t,
	m_in_sig_y_at_t = m_in_sig_y@t;
assume:
	at t: state_1;
	at t: b_out_sync;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: b_out_sig_mode = m_in_sig_mode_at_t;
	at t_end: b_out_sig_x = m_in_sig_x_at_t;
	at t_end: b_out_sig_y = m_in_sig_y_at_t;
	at t_end: phase = SECTION_A;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_mode_at_t = m_in_sig_mode@t,
	m_in_sig_x_at_t = m_in_sig_x@t,
	m_in_sig_y_at_t = m_in_sig_y@t;
assume:
	at t: state_1;
	at t: not(b_out_sync);
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: b_out_sig_mode = m_in_sig_mode_at_t;
	at t_end: b_out_sig_x = m_in_sig_x_at_t;
	at t_end: b_out_sig_y = m_in_sig_y_at_t;
	at t_end: phase = SECTION_A;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


