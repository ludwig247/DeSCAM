-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := end macro;
macro b_in_notify : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_in_sig_mode : Mode := end macro;
macro b_in_sig_x : signed := end macro;
macro b_in_sig_y : boolean := end macro;
macro m_out_sig : signed := end macro;


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
	 at t: phase = SECTION_A;
	 at t: b_in_notify = true;
	 at t: m_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_x_at_t = b_in_sig_x@t;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((phase = SECTION_B));
	at t: (b_in_sig_x >= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: m_out_sig = b_in_sig_x_at_t;
	at t_end: phase = SECTION_A;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((phase = SECTION_B));
	at t: (b_in_sig_x <= resize(4,32));
prove:
	at t_end: state_1;
	at t_end: phase = SECTION_A;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: m_out_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	phase_at_t = phase@t;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: phase = phase_at_t;
	at t+1: b_in_notify = true;
	at t+1: m_out_notify = false;
end property;


