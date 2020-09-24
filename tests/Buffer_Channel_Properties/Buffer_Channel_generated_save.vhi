-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := consumer_sync end macro;
macro val_0_sync : boolean := producer0_sync end macro;
macro val_1_sync : boolean := producer1_sync end macro;
macro val_2_sync : boolean := producer2_sync end macro;
macro out_notify : boolean := consumer_notify end  macro;
macro val_0_notify : boolean := producer0_notify end  macro;
macro val_1_notify : boolean := producer1_notify end  macro;
macro val_2_notify : boolean := producer2_notify end  macro;


-- DP SIGNALS --
macro out_sig : signed := consumer end macro;
macro val_0_sig : signed := producer0 end macro;
macro val_1_sig : signed := producer1 end macro;
macro val_2_sig : signed := producer2 end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer0 : int_array := fifo0 end macro;
macro buffer1 : int_array := fifo1 end macro;
macro buffer2 : int_array := fifo2 end macro;

-- STATES --
macro start_state : boolean :=  (head0<FIFO_SIZE) and (head1<FIFO_SIZE) and (head2<FIFO_SIZE) and
                                (tail0<FIFO_SIZE) and (tail1<FIFO_SIZE) and (tail2<FIFO_SIZE) and
                                (((state0 = EMPTY) or (state0 = FULL)) and (head0 = tail0) or
                                (state0 = FILLED) and not(head0 = tail0)) and
                                (((state1 = EMPTY) or (state1 = FULL)) and (head1 = tail1) or
                                (state1 = FILLED) and not(head1 = tail1)) and
                                (((state2 = EMPTY) or (state2 = FULL)) and (head2 = tail2) or
                                (state2 = FILLED) and not(head2 = tail2)) and
                                (next_read < 3)
end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: head0 = resize(0,32);
	 at t: head1 = resize(0,32);
	 at t: head2 = resize(0,32);
	 at t: next_read = resize(0,32);
	 at t: state0 = EMPTY;
	 at t: state1 = EMPTY;
	 at t: state2 = EMPTY;
	 at t: tail0 = resize(0,32);
	 at t: tail1 = resize(0,32);
	 at t: tail2 = resize(0,32);
	 at t: out_notify = false;
	 at t: val_0_notify = false;
	 at t: val_1_notify = false;
	 at t: val_2_notify = false;
end property;


property start_state_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1004 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_101 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1010 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1017 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1019 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1022 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1024 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1026 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1029 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1031 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1033 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1039 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1042 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1053 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1058 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: ((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and (state2 = FULL)) and out_sync) and not(val_0_sync)) and not(val_1_sync)) and val_2_sync) or (((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and (state1 = FULL)) and out_sync) and not(val_0_sync)) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_106 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1060 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1062 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1065 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1067 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1069 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1072 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1074 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1076 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1089 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1091 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1096 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1098 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1102 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1104 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1106 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1109 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_111 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1111 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1113 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1116 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1118 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1120 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1124 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1126 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1128 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1131 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1133 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1135 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1138 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1140 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1142 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1149 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1153 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1157 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1161 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1166 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1171 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1188 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1190 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1192 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1206 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state1 = FULL);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1209 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1217 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1220 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1228 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1231 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1254 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1260 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1266 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1273 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1275 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1278 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_128 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1280 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1282 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1285 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1287 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1289 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = head0_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1294 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1296 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1299 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_130 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1301 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1303 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1306 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1308 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1310 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1316 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1319 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_132 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1330 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state2 = FULL;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1334 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state0_at_t = state0@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: state0 = state0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1336 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1338 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1341 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state0_at_t = state0@t,
	state1_at_t = state1@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1343 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1345 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1348 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1350 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1352 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1355 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1357 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1359 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1363 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1365 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1367 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1370 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1372 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1374 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1377 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1379 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1381 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1385 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1387 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1389 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1392 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1394 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1396 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1399 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1401 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1403 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1407 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1409 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1411 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1414 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1416 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1418 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1421 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1423 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1425 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1428 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state0_at_t = state0@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: state0 = state0_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1430 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1432 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1435 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1437 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1439 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1442 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1444 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1446 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state0 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1448 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state1_at_t = state1@t;
assume:
	at t: start_state;
	at t: (state1 = FULL);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: state1 = state1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1450 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1452 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1455 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state1_at_t = state1@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1457 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1459 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_146 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: (state0 = FULL);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1462 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1464 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1466 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1469 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_1471 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1473 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_1475 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: (state2 = FULL);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_1477 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1479 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_1480 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_149 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_157 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_160 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_168 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_171 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_194 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state0_at_t = state0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_200 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_206 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_212 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and (state1 = FULL)) and (state2 = FULL)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync) or ((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and (state0 = FULL)) and (state2 = FULL)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync)) or ((((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and (state0 = FULL)) and (state1 = FULL)) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_214 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and not((state1 = FULL))) and (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1)) and (state2 = FULL)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync) or (((((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and (state0 = FULL)) and not((state1 = FULL))) and (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1)) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_216 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and not((state1 = FULL))) and not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1))) and (state2 = FULL)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync) or (((((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and (state0 = FULL)) and not((state1 = FULL))) and not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1))) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_219 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and not((state0 = FULL))) and (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0)) and (state2 = FULL)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync) or (((((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and not((state0 = FULL))) and (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0)) and (state1 = FULL)) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_221 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_223 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_226 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and not((state0 = FULL))) and not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0))) and (state2 = FULL)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync) or (((((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and not((state0 = FULL))) and not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0))) and (state1 = FULL)) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_228 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_230 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_234 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_236 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_238 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;                  --	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_241 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_243 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_245 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_248 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_250 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_252 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_256 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_258 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_260 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_263 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_265 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_267 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;                  --at t_end: buffer0(head0) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t); --	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_270 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_272 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_274 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_282 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_286 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_290 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_295 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_299 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_303 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_308 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_312 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_316 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_321 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_326 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_331 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_337 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_342 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_347 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_353 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_358 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_363 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;                 --	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_396 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_398 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: (head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_400 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_403 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_405 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_407 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_410 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_412 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_414 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t;
assume:
	at t: start_state;
	at t: ((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and (state1 = FULL)) and out_sync) and not(val_0_sync)) and val_1_sync) and not(val_2_sync)) or (((((((next_read = resize(1,32)) and (state1 = EMPTY)) and (state0 = FULL)) and out_sync) and val_0_sync) and not(val_1_sync)) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_444 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: (state0 = FULL);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_448 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: (state0 = FULL);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_452 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: (state0 = FULL);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_456 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_461 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_466 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_475 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_479 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_483 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_487 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_492 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_497 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_506 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_510 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_514 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(1,32));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail1)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_518 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: (state2 = FULL);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_523 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_528 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_567 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_569 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_57 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_571 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_583 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_585 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_587 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_59 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_599 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head0 = head0_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_601 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_603 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((FILLED = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_618 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_621 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_629 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_632 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_64 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t;
assume:
	at t: start_state;
	at t: ((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and (state2 = FULL)) and out_sync) and not(val_0_sync)) and not(val_1_sync)) and val_2_sync) or (((((((not((next_read = resize(0,32))) and not((next_read = resize(1,32)))) and (state2 = EMPTY)) and (state0 = FULL)) and out_sync) and val_0_sync) and not(val_1_sync)) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state2 = state2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_640 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_643 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_652 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_655 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_66 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_663 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_666 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_674 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_677 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_68 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_686 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_689 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_697 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_700 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_708 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_711 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_73 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: (head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_768 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: (state1 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_774 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_78 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_780 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_787 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state1 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_793 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_799 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	next_read_at_t = next_read@t,
	state1_at_t = state1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: next_read = next_read_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_806 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state1 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_812 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: (((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_818 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state1 = FULL));
	at t: not((((head1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = tail1_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = head2_at_t;
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_827 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_831 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_835 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state2 = FULL));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_839 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state2 = FULL);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_844 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_849 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: (state0 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0(tail0_at_t);
	at t_end: state0 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_866 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_868 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_870 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((state0 = EMPTY));
	at t: not((head0 = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_883 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and (state1 = FULL)) and not((state2 = FULL))) and (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync) or (((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and (state0 = FULL)) and not((state2 = FULL))) and (((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_885 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state1_at_t = state1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((((((next_read = resize(0,32)) and (state0 = EMPTY)) and (state1 = FULL)) and not((state2 = FULL))) and not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2))) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync) or (((((((((next_read = resize(1,32)) and (state1 = EMPTY)) and (state0 = FULL)) and not((state2 = FULL))) and not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = tail2))) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = state0_at_t;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_89 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state1 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;             --	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_890 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_892 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FULL;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_897 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_899 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state1_at_t = state1@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: (state1 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = next_read_at_t;
	at t_end: state0 = FILLED;
	at t_end: state1 = state1_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_903 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_905 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_907 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_910 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_912 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_914 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_917 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_919 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_921 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: (head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = EMPTY;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_925 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	state2_at_t = state2@t,
	tail1_at_t = tail1@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_927 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_929 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	state0_at_t = state0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_93 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: (((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FULL;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_932 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_934 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_936 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FULL;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_939 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	state2_at_t = state2@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: (state2 = FULL);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = state2_at_t;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_941 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FULL;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_943 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_at_t = buffer1@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	head2_at_t = head2@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: (next_read = resize(1,32));
	at t: not((state1 = EMPTY));
	at t: not((head1 = ((tail1 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = head1_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer1_at_t(tail1_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail1 = ((tail1_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail2 = tail2_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_950 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state0 = FULL);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FILLED;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_953 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: (state0 = FULL);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = EMPTY;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_961 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: (((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_964 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: (((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0);
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FULL;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_97 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer0_at_t = buffer0@t,
	head0_at_t = head0@t,
	head1_at_t = head1@t,
	next_read_at_t = next_read@t,
	tail0_at_t = tail0@t,
	tail1_at_t = tail1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (next_read = resize(0,32));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail0)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((state1 = FULL));
	at t: not((((resize(1,32) + head1)(31 downto 0) mod resize(3,32))(31 downto 0) = tail1));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
    at t_end: buffer1(head1_at_t) = val_1_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head1 = ((head1_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = (next_read_at_t + 1)(31 downto 0);
	at t_end: out_sig = buffer0_at_t(tail0_at_t);
	at t_end: state0 = FILLED;
	at t_end: state1 = FILLED;
	at t_end: tail0 = ((tail0_at_t + 1)(31 downto 0) mod 3);
	at t_end: tail1 = tail1_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_972 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state0 = FULL));
	at t: not((((resize(1,32) + head0)(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((((resize(1,32) + head2)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail2)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = FILLED;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_975 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head0_at_t = head0@t,
	head2_at_t = head2@t,
	tail0_at_t = tail0@t,
	tail2_at_t = tail2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: (state2 = EMPTY);
	at t: not((state0 = FULL));
	at t: not((((head0 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail0));
	at t: not((state2 = FULL));
	at t: not((((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail2));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer0(head0_at_t) = val_0_sig_at_t;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head0 = ((head0_at_t + 1)(31 downto 0) mod 3);
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2(tail2_at_t);
	at t_end: state0 = FILLED;
	at t_end: state2 = EMPTY;
	at t_end: tail0 = tail0_at_t;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_998 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer2_at_t = buffer2@t,
	head2_at_t = head2@t,
	state0_at_t = state0@t,
	tail2_at_t = tail2@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((next_read = resize(0,32)));
	at t: not((next_read = resize(1,32)));
	at t: not((state2 = EMPTY));
	at t: not((head2 = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: (state0 = FULL);
	at t: not((FILLED = FULL));
	at t: (((head2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail2 + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer2(head2_at_t) = val_2_sig_at_t;
	at t_end: head2 = ((head2_at_t + 1)(31 downto 0) mod 3);
	at t_end: next_read = 0;
	at t_end: out_sig = buffer2_at_t(tail2_at_t);
	at t_end: state0 = state0_at_t;
	at t_end: state2 = FULL;
	at t_end: tail2 = ((tail2_at_t + 1)(31 downto 0) mod 3);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;



