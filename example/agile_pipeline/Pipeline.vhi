-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in_sync : boolean := end macro;
--macro b_out_sync : boolean := end macro;
macro b_in_notify_local : boolean := s1/b_in_notify end macro;
macro b_out_notify_local : boolean := s1/b_out_notify end macro;


-- DP SIGNALS --
macro b_in_sig : signed := b_in end macro;
macro b_out_sig : signed := b_out end macro;

-- PIPELINE SIGNALS --
macro b_out_free : boolean := s1/b_out_free end macro;
macro b_in_free : boolean := s1/b_in_free end macro;



-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --


-- STATES --
macro run_0 : boolean := s1/state=A end macro;
macro run_1 : boolean := s1/state=B end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: run_0;
	at t: b_in_sync;
	--new
	at t: b_out_free;
prove:
	at t_end: run_1;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end-1]: b_out_notify_local = false;
	at t_end: b_out_notify = true;
end property;


property run_1_write_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: run_1;
	at t: b_out_sync;
	--new
	at t: b_in_free;
prove:
	at t_end: run_0;
	during[t+1, t_end-1]: b_in_notify_local = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify_local = false;
end property;


property run_1_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: run_1;
	at t: b_out_sync;
	--new
	at t: not(b_in_free);
prove:
	at t_end: s1/state = Aw;
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end]: b_out_notify_local = false;
end property;


property wait_run_0 is
dependencies: no_reset;
assume:
	at t: run_0;
	at t: not(b_in_sync);
prove:
	at t+1: run_0;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify_local= false;
end property;


property wait_run_1 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: run_1;
	at t: not(b_out_sync);
prove:
	at t+1: run_1;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify_local = false;
	at t+1: b_out_notify = true;
end property;


