-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_1;
	 at t: events_out_msg_timeout = false;
	 at t: events_out_notify = false;
	 at t: rxd_notify = true;
end property;


property GET_STOP_BIT_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	events_out_msg_timeout_at_t = events_out_msg_timeout@t;
assume:
	at t: GET_STOP_BIT_2;
	at t: rxd_sync;
	at t: not(rxd_sig);
prove:
	at t_end: IDLE_1;
	at t_end: events_out_msg_timeout = events_out_msg_timeout_at_t;
	at t_end: events_out_sig_error_src = ERROR_FRAMING_MASK;
	at t_end: events_out_sig_ready = true;
	at t_end: events_out_sig_timeout = events_out_msg_timeout_at_t;
	during[t+1, t_end-1]: events_out_notify = false;
	at t_end: events_out_notify = true;
	during[t+1, t_end-1]: rxd_notify = false;
	at t_end: rxd_notify = true;
end property;


property IDLE_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	events_out_msg_timeout_at_t = events_out_msg_timeout@t;
assume:
	at t: IDLE_1;
	at t: rxd_sync;
	at t: not(rxd_sig);
prove:
	at t_end: GET_STOP_BIT_2;
	at t_end: events_out_msg_timeout = events_out_msg_timeout_at_t;
	during[t+1, t_end]: events_out_notify = false;
	during[t+1, t_end-1]: rxd_notify = false;
	at t_end: rxd_notify = true;
end property;


property IDLE_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	events_out_msg_timeout_at_t = events_out_msg_timeout@t;
assume:
	at t: IDLE_1;
	at t: rxd_sync;
	at t: rxd_sig;
prove:
	at t_end: IDLE_1;
	at t_end: events_out_msg_timeout = events_out_msg_timeout_at_t;
	during[t+1, t_end]: events_out_notify = false;
	during[t+1, t_end-1]: rxd_notify = false;
	at t_end: rxd_notify = true;
end property;


property wait_GET_STOP_BIT_2 is
dependencies: no_reset;
freeze:
	events_out_msg_timeout_at_t = events_out_msg_timeout@t;
assume:
	at t: GET_STOP_BIT_2;
	at t: not(rxd_sync);
prove:
	at t+1: GET_STOP_BIT_2;
	at t+1: events_out_msg_timeout = events_out_msg_timeout_at_t;
	at t+1: events_out_notify = false;
	at t+1: rxd_notify = true;
end property;


property wait_IDLE_1 is
dependencies: no_reset;
freeze:
	events_out_msg_timeout_at_t = events_out_msg_timeout@t;
assume:
	at t: IDLE_1;
	at t: not(rxd_sync);
prove:
	at t+1: IDLE_1;
	at t+1: events_out_msg_timeout = events_out_msg_timeout_at_t;
	at t+1: events_out_notify = false;
	at t+1: rxd_notify = true;
end property;


