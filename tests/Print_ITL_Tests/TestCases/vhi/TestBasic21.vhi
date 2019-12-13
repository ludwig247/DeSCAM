-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := end macro;
macro b_out_notify : boolean := end macro;
macro m_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_out_sig : CompoundType := end macro;
macro b_out_sig_mode : Mode := end macro;
macro b_out_sig_x : signed := end macro;
macro b_out_sig_y : boolean := end macro;
macro m_out_sig : CompoundType := end macro;
macro m_out_sig_mode : Mode := end macro;
macro m_out_sig_x : signed := end macro;
macro m_out_sig_y : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro compoundType_mode : Mode := end macro;
macro compoundType_x : signed := end macro;
macro compoundType_y : boolean := end macro;
macro phase : Phases := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: b_out_sig_mode = READ;
	 at t: b_out_sig_x = resize(0,32);
	 at t: b_out_sig_y = false;
	 at t: compoundType_mode = READ;
	 at t: compoundType_x = resize(0,32);
	 at t: compoundType_y = false;
	 at t: phase = SECTION_A;
	 at t: b_out_notify = true;
	 at t: m_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	compoundType_mode_at_t = compoundType_mode@t,
	compoundType_x_at_t = compoundType_x@t,
	compoundType_y_at_t = compoundType_y@t,
	phase_at_t = phase@t;
assume:
	at t: state_1;
	at t: b_out_sync;
prove:
	at t_end: state_2;
	at t_end: compoundType_mode = compoundType_mode_at_t;
	at t_end: compoundType_x = compoundType_x_at_t;
	at t_end: compoundType_y = compoundType_y_at_t;
	at t_end: m_out_sig_mode = compoundType_mode_at_t;
	at t_end: m_out_sig_x = compoundType_x_at_t;
	at t_end: m_out_sig_y = compoundType_y_at_t;
	at t_end: phase = phase_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	compoundType_mode_at_t = compoundType_mode@t,
	compoundType_x_at_t = compoundType_x@t,
	compoundType_y_at_t = compoundType_y@t,
	phase_at_t = phase@t;
assume:
	at t: state_1;
	at t: not(b_out_sync);
prove:
	at t_end: state_2;
	at t_end: compoundType_mode = compoundType_mode_at_t;
	at t_end: compoundType_x = compoundType_x_at_t;
	at t_end: compoundType_y = compoundType_y_at_t;
	at t_end: m_out_sig_mode = compoundType_mode_at_t;
	at t_end: m_out_sig_x = compoundType_x_at_t;
	at t_end: m_out_sig_y = compoundType_y_at_t;
	at t_end: phase = phase_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	compoundType_mode_at_t = compoundType_mode@t,
	compoundType_x_at_t = compoundType_x@t,
	compoundType_y_at_t = compoundType_y@t;
assume:
	at t: state_2;
	at t: not((phase = SECTION_B));
prove:
	at t_end: state_1;
	at t_end: b_out_sig_mode = compoundType_mode_at_t;
	at t_end: b_out_sig_x = compoundType_x_at_t;
	at t_end: b_out_sig_y = compoundType_y_at_t;
	at t_end: compoundType_mode = compoundType_mode_at_t;
	at t_end: compoundType_x = compoundType_x_at_t;
	at t_end: compoundType_y = compoundType_y_at_t;
	at t_end: m_out_sig_mode = compoundType_mode_at_t;
	at t_end: m_out_sig_x = compoundType_x_at_t;
	at t_end: m_out_sig_y = compoundType_y_at_t;
	at t_end: phase = SECTION_A;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end-1]: m_out_notify = false;
	at t_end: m_out_notify = true;
end property;


