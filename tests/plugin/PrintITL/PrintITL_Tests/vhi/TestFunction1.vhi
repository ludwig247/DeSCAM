-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_in_sync : boolean := true end macro;
macro b_out_sync : boolean := true end macro;
macro b_in_notify : boolean := true end  macro;
macro b_out_notify : boolean := true end  macro;


-- DP SIGNALS --
--macro b_in_sig : record :={resize(0,32), resize(0,32)} end macro;
macro b_in_sig_x : signed :=resize(0,32) end macro;
macro b_in_sig_y : unsigned :=resize(0,32) end macro;
macro b_out_sig : unsigned :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro record_var_y : unsigned :=resize(0,32) end macro;
macro x : signed :=resize(0,32) end macro;
macro y : unsigned :=resize(0,32) end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: record_var_y = resize(0,32);
	 at t: x = resize(0,32);
	 at t: y = resize(0,32);
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_x_at_t = b_in_sig_x@t,
	b_in_sig_y_at_t = b_in_sig_y@t,
	x_at_t = x@t;
assume:
	at t: state_1;
	at t: b_in_sync;
prove:
	at t_end: state_2;
	at t_end: b_out_sig = unsigned(b_in_sig_x_at_t);
	at t_end: record_var_y = b_in_sig_y_at_t;
	at t_end: x = x_at_t;
	at t_end: y = unsigned(b_in_sig_x_at_t);
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t;
assume:
	at t: state_2;
	at t: b_out_sync;
prove:
	at t_end: state_3;
	at t_end: b_out_sig = unsigned((signed(record_var_y_at_t) + x_at_t)(31 downto 0));
	at t_end: record_var_y = record_var_y_at_t;
	at t_end: x = x_at_t;
	at t_end: y = unsigned((signed(record_var_y_at_t) + x_at_t)(31 downto 0));
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_3_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_3;
	at t: b_out_sync;
prove:
	at t_end: state_4;
	at t_end: b_out_sig = unsigned((shift_right(signed(record_var_y_at_t),signed((y_at_t and 31)))));
	at t_end: record_var_y = record_var_y_at_t;
	at t_end: x = x_at_t;
	at t_end: y = unsigned((shift_right(signed(record_var_y_at_t),signed((y_at_t and 31)))));
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_4_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t;
assume:
	at t: state_4;
	at t: b_out_sync;
prove:
	at t_end: state_5;
	at t_end: b_out_sig = unsigned((shift_right(signed(record_var_y_at_t),signed((foo(record_var_y_at_t) and 31)))));
	at t_end: record_var_y = record_var_y_at_t;
	at t_end: x = x_at_t;
	at t_end: y = unsigned((shift_right(signed(record_var_y_at_t),signed((foo(record_var_y_at_t) and 31)))));
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;


property state_5_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_5;
	at t: b_out_sync;
prove:
	at t_end: state_1;
	at t_end: record_var_y = record_var_y_at_t;
	at t_end: x = x_at_t;
	at t_end: y = y_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_1;
	at t: not(b_in_sync);
prove:
	at t+1: state_1;
	at t+1: record_var_y = record_var_y_at_t;
	at t+1: x = x_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_2;
	at t: not(b_out_sync);
prove:
	at t+1: state_2;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: record_var_y = record_var_y_at_t;
	at t+1: x = x_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_3;
	at t: not(b_out_sync);
prove:
	at t+1: state_3;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: record_var_y = record_var_y_at_t;
	at t+1: x = x_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_4;
	at t: not(b_out_sync);
prove:
	at t+1: state_4;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: record_var_y = record_var_y_at_t;
	at t+1: x = x_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


property wait_state_5 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	record_var_y_at_t = record_var_y@t,
	x_at_t = x@t,
	y_at_t = y@t;
assume:
	at t: state_5;
	at t: not(b_out_sync);
prove:
	at t+1: state_5;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: record_var_y = record_var_y_at_t;
	at t+1: x = x_at_t;
	at t+1: y = y_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
end property;


-- FUNCTIONS --
macro foo(x: unsigned) : unsigned :=
	if (((x + resize(1,32))(31 downto 0) > resize(5,32))) then unsigned((shift_left((x + resize(1,32))(31 downto 0),resize(1,32))))
	elsif (not(((x + resize(1,32))(31 downto 0) > resize(5,32))) and ((x + resize(1,32))(31 downto 0) > resize(20,32))) then unsigned(((x + resize(1,32))(31 downto 0) + resize(2,32))(31 downto 0))
	elsif (not(((x + resize(1,32))(31 downto 0) > resize(5,32))) and not(((x + resize(1,32))(31 downto 0) > resize(20,32))) and ((x + resize(1,32))(31 downto 0) = resize(20,32))) then unsigned((x + resize(1,32))(31 downto 0))
	else unsigned(resize(0,32))
end if;
end macro;

