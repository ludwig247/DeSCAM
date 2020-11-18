-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 -- at t: b_out_sig = m_in_sig(foobar(resize(0,32)));
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
	at t_end: b_out_sig = m_in_sig_at_t(foobar(0));
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


