-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro consumer_sync : boolean := end macro;
macro producer_sync : boolean := end macro;
macro consumer_notify : boolean := end macro;
macro producer_notify : boolean := end macro;


-- DP SIGNALS --
macro consumer_sig : signed := end macro;
macro producer_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_3 := end macro;
macro from_reset : boolean := end macro;
macro head : unsigned := end macro;
macro is_empty : boolean := end macro;
macro is_full : boolean := end macro;
macro tail : unsigned := end macro;
macro value_out : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;
macro state_6 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: buffer(0) = resize(0,32);
	 at t: buffer(1) = resize(0,32);
	 at t: buffer(2) = resize(0,32);
	 at t: from_reset = false;
	 at t: head = resize(0,32);
	 at t: is_empty = true;
	 at t: is_full = false;
	 at t: tail = resize(0,32);
	 at t: value_out = resize(0,32);
	 at t: consumer_notify = false;
	 at t: producer_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_1;
	at t: producer_sync;
	at t: consumer_sync;
	at t: not(is_full);
	at t: not(is_empty);
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = true;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_1;
	at t: producer_sync;
	at t: not(consumer_sync);
	at t: not(is_full);
prove:
	at t_end: state_4;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = true;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_1;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = true;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_1_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_1;
	at t: not(((consumer_sync and not(is_full)) and not(is_empty)));
	at t: not(((producer_sync and not(consumer_sync)) and not(is_full)));
	at t: not(((not(producer_sync) and consumer_sync) and not(is_empty)));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = true;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: (tail = resize(0,32));
	at t: (head = resize(0,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = producer_sig_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: (tail = resize(0,32));
	at t: (head = resize(1,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = resize(0,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: (tail = resize(1,32));
	at t: (head = resize(0,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: (tail = resize(1,32));
	at t: (head = resize(1,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = producer_sig_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = resize(1,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(1,32));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_2_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t;
assume:
	at t: state_2;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
prove:
	at t_end: state_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: consumer_sig = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = producer_sig_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: producer_sync;
	at t: not(is_full);
	at t: not(is_empty);
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_3_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_3_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_3;
	at t: consumer_sync;
	at t: from_reset;
	at t: not((not(is_full) and not(is_empty)));
	at t: not((not(producer_sync) and not(is_empty)));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: (((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head);
	at t: from_reset;
	at t: (tail = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = true;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: consumer_sync;
	at t: not(is_full);
	at t: (tail = resize(0,32));
prove:
	at t_end: state_2;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: not(consumer_sync);
	at t: not(is_full);
	at t: (tail = resize(0,32));
prove:
	at t_end: state_4;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: is_full;
	at t: (tail = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = producer_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: (((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head);
	at t: from_reset;
	at t: (tail = resize(1,32));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = true;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: consumer_sync;
	at t: not(is_full);
	at t: (tail = resize(1,32));
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: not(consumer_sync);
	at t: not(is_full);
	at t: (tail = resize(1,32));
prove:
	at t_end: state_4;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: is_full;
	at t: (tail = resize(1,32));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_57 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head);
	at t: from_reset;
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = true;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_4_58 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: consumer_sync;
	at t: not(is_full);
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_59 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: not(consumer_sync);
	at t: not(is_full);
prove:
	at t_end: state_4;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_4_66 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_full_at_t = is_full@t,
	producer_sig_at_t = producer_sig@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: producer_sync;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0) = head));
	at t: from_reset;
	at t: is_full;
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = false;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = ((1 + tail_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: producer_sync;
	at t: not(is_full);
	at t: not(is_empty);
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_5_69 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_70 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_72 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_73 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_74 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not(producer_sync);
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_5_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_5;
	at t: consumer_sync;
	at t: from_reset;
	at t: not((not(is_full) and not(is_empty)));
	at t: not((not(producer_sync) and not(is_empty)));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_76 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: producer_sync;
	at t: consumer_sync;
	at t: not(is_full);
	at t: not(is_empty);
prove:
	at t_end: state_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_6_77 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: producer_sync;
	at t: not(consumer_sync);
	at t: not(is_full);
prove:
	at t_end: state_4;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end-1]: producer_notify = false;
	at t_end: producer_notify = true;
end property;


property state_6_78 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_79 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(0,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_0_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_0_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_81 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (head = resize(1,32));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_1_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_1_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = true;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_83 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	tail_at_t = tail@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(producer_sync);
	at t: consumer_sync;
	at t: not(is_empty);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = ((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0)));
prove:
	at t_end: state_5;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_sig = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = ((1 + head_at_t)(31 downto 0) mod 3)(31 downto 0);
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = false;
	at t_end: tail = tail_at_t;
	at t_end: value_out = buffer_2_at_t;
	during[t+1, t_end-1]: consumer_notify = false;
	at t_end: consumer_notify = true;
	during[t+1, t_end]: producer_notify = false;
end property;


property state_6_84 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_6;
	at t: from_reset;
	at t: not(((consumer_sync and not(is_full)) and not(is_empty)));
	at t: not(((producer_sync and not(consumer_sync)) and not(is_full)));
	at t: not(((not(producer_sync) and consumer_sync) and not(is_empty)));
prove:
	at t_end: state_6;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: from_reset = from_reset_at_t;
	at t_end: head = head_at_t;
	at t_end: is_empty = is_empty_at_t;
	at t_end: is_full = is_full_at_t;
	at t_end: tail = tail_at_t;
	at t_end: value_out = value_out_at_t;
	during[t+1, t_end]: consumer_notify = false;
	during[t+1, t_end]: producer_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_2;
	at t: not(producer_sync);
prove:
	at t+1: state_2;
	at t+1: buffer(0) = buffer_0_at_t;
	at t+1: buffer(1) = buffer_1_at_t;
	at t+1: buffer(2) = buffer_2_at_t;
	at t+1: from_reset = from_reset_at_t;
	at t+1: head = head_at_t;
	at t+1: is_empty = is_empty_at_t;
	at t+1: is_full = is_full_at_t;
	at t+1: tail = tail_at_t;
	at t+1: value_out = value_out_at_t;
	at t+1: consumer_notify = false;
	at t+1: producer_notify = true;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_3;
	at t: not(consumer_sync);
prove:
	at t+1: state_3;
	at t+1: buffer(0) = buffer_0_at_t;
	at t+1: buffer(1) = buffer_1_at_t;
	at t+1: buffer(2) = buffer_2_at_t;
	at t+1: consumer_sig = value_out_at_t;
	at t+1: from_reset = from_reset_at_t;
	at t+1: head = head_at_t;
	at t+1: is_empty = is_empty_at_t;
	at t+1: is_full = is_full_at_t;
	at t+1: tail = tail_at_t;
	at t+1: value_out = value_out_at_t;
	at t+1: consumer_notify = true;
	at t+1: producer_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_4;
	at t: not(producer_sync);
prove:
	at t+1: state_4;
	at t+1: buffer(0) = buffer_0_at_t;
	at t+1: buffer(1) = buffer_1_at_t;
	at t+1: buffer(2) = buffer_2_at_t;
	at t+1: from_reset = from_reset_at_t;
	at t+1: head = head_at_t;
	at t+1: is_empty = is_empty_at_t;
	at t+1: is_full = is_full_at_t;
	at t+1: tail = tail_at_t;
	at t+1: value_out = value_out_at_t;
	at t+1: consumer_notify = false;
	at t+1: producer_notify = true;
end property;


property wait_state_5 is
dependencies: no_reset;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	from_reset_at_t = from_reset@t,
	head_at_t = head@t,
	is_empty_at_t = is_empty@t,
	is_full_at_t = is_full@t,
	tail_at_t = tail@t,
	value_out_at_t = value_out@t;
assume:
	at t: state_5;
	at t: not(consumer_sync);
prove:
	at t+1: state_5;
	at t+1: buffer(0) = buffer_0_at_t;
	at t+1: buffer(1) = buffer_1_at_t;
	at t+1: buffer(2) = buffer_2_at_t;
	at t+1: consumer_sig = value_out_at_t;
	at t+1: from_reset = from_reset_at_t;
	at t+1: head = head_at_t;
	at t+1: is_empty = is_empty_at_t;
	at t+1: is_full = is_full_at_t;
	at t+1: tail = tail_at_t;
	at t+1: value_out = value_out_at_t;
	at t+1: consumer_notify = true;
	at t+1: producer_notify = false;
end property;


