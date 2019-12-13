-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := end macro;
macro b_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_out_sig : unsigned := end macro;
macro m_in_sig : unsigned_4 := end macro;
macro m_in_sig_0 : unsigned := end macro;
macro m_in_sig_1 : unsigned := end macro;
macro m_in_sig_2 : unsigned := end macro;
macro m_in_sig_3 : unsigned := end macro;


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
	 at t: b_out_sig = m_in_sig(foobar(resize(0,32)));
	 at t: b_out_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	m_in_sig_at_t = m_in_sig@t;
assume:
	at t: state_1;
	at t: b_out_sync;
prove:
	at t_end: state_1;
	at t_end: b_out_sig = m_in_sig(foobar(0));
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: state_1;
	at t: not(b_out_sync);
prove:
	at t+1: state_1;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_out_notify = true;
end property;


-- FUNCTIONS --
macro foobar(num: unsigned) : unsigned :=
	unsigned(num);
end macro;

