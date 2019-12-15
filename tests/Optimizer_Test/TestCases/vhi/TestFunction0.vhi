-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := end macro;
macro b_out_sync : boolean := end macro;
macro b_in_notify : boolean := end macro;
macro b_out_notify : boolean := end macro;


-- DP SIGNALS --
macro b_in_sig : signed := end macro;
macro b_out_sig : unsigned := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro y : unsigned := end macro;


-- STATES --
macro state_2 : boolean := true end macro;
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: y = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	y_at_t = y@t;
assume:
	at t: state_2;
	at t: b_out_sync;
prove:
	at t_end: state_1;
	at t_end: y = y_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: (resize(15,32) > unsigned(foo(b_in_sig)));
	at t: (unsigned(foo(b_in_sig)) > resize(0,32));
	at t: ((unsigned(b_in_sig) > resize(1,32)) or (resize(1,32) > unsigned(b_in_sig)));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 2;
	at t_end: y = 2;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: (resize(15,32) > unsigned(foo(b_in_sig)));
	at t: (unsigned(foo(b_in_sig)) > resize(0,32));
	at t: not(((unsigned(b_in_sig) > resize(1,32)) or (resize(1,32) > unsigned(b_in_sig))));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 1;
	at t_end: y = 1;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: (resize(15,32) > unsigned(foo(b_in_sig)));
	at t: not((unsigned(foo(b_in_sig)) > resize(0,32)));
	at t: ((unsigned(b_in_sig) > resize(0,32)) or (resize(0,32) > unsigned(b_in_sig)));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 2;
	at t_end: y = 2;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: (resize(15,32) > unsigned(foo(b_in_sig)));
	at t: not((unsigned(foo(b_in_sig)) > resize(0,32)));
	at t: not(((unsigned(b_in_sig) > resize(0,32)) or (resize(0,32) > unsigned(b_in_sig))));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 0;
	at t_end: y = 0;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((resize(15,32) > unsigned(foo(b_in_sig))));
	at t: (unsigned(foo(b_in_sig)) > resize(0,32));
	at t: ((unsigned(b_in_sig) > resize(1,32)) or (resize(1,32) > unsigned(b_in_sig)));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 2;
	at t_end: y = 2;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((resize(15,32) > unsigned(foo(b_in_sig))));
	at t: (unsigned(foo(b_in_sig)) > resize(0,32));
	at t: not(((unsigned(b_in_sig) > resize(1,32)) or (resize(1,32) > unsigned(b_in_sig))));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 1;
	at t_end: y = 1;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((resize(15,32) > unsigned(foo(b_in_sig))));
	at t: not((unsigned(foo(b_in_sig)) > resize(0,32)));
	at t: ((unsigned(b_in_sig) > unsigned(foo(b_in_sig))) or (unsigned(foo(b_in_sig)) > unsigned(b_in_sig)));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = 2;
	at t_end: y = 2;
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: state_1;
	at t: b_in_sync;
	at t: not((resize(15,32) > unsigned(foo(b_in_sig))));
	at t: not((unsigned(foo(b_in_sig)) > resize(0,32)));
	at t: not(((unsigned(b_in_sig) > unsigned(foo(b_in_sig))) or (unsigned(foo(b_in_sig)) > unsigned(b_in_sig))));
prove:
	at t_end: state_2;
	at t_end: b_out_sig = unsigned(foo(b_in_sig_at_t));
	at t_end: y = unsigned(foo(b_in_sig_at_t));
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	y_at_t = y@t;
assume:
	at t: state_2;
	at t: not(b_out_sync);
prove:
	at t+1: state_2;
	at t+1: b_out_sig = y_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	y_at_t = y@t;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


-- FUNCTIONS --
macro foo(x: signed) : signed :=
	if (((x + resize(1,32))(31 downto 0) > resize(5,32))) then signed((shift_left((x + resize(1,32))(31 downto 0),resize(1,32))))
	elsif (not(((x + resize(1,32))(31 downto 0) > resize(5,32))) and ((x + resize(1,32))(31 downto 0) > resize(20,32))) then signed(((x + resize(1,32))(31 downto 0) + resize(2,32))(31 downto 0))
	elsif (not(((x + resize(1,32))(31 downto 0) > resize(5,32))) and not(((x + resize(1,32))(31 downto 0) > resize(20,32))) and ((x + resize(1,32))(31 downto 0) = resize(20,32))) then signed((x + resize(1,32))(31 downto 0))
	else signed(resize(0,32))
end if;
end macro;

