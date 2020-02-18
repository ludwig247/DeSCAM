-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: empty_1;
	 at t: buffer(0) = resize(0,32);
	 at t: buffer(1) = resize(0,32);
	 at t: buffer(2) = resize(0,32);
	 at t: consumer_notify_sig = false;
	 at t: consumer_sig_sig = resize(0,32);
	 at t: head = resize(0,32);
	 at t: producer_notify_sig = false;
	 at t: state = EMPTY;
	 at t: tail = resize(0,32);
end property;


property empty_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: (head = resize(0,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property empty_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property empty_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: (head = resize(1,32));
	at t: (tail = resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property empty_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((tail >= resize(2,32)));
	at t: (head = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property empty_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property empty_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = resize(0,32)));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property empty_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = producer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property empty_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: (state = EMPTY);
	at t: not(producer_sync_sig);
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property empty_1_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: empty_1;
	at t: not((not((resize(3,32) <= head)) and not((resize(3,32) <= tail))));
	at t: (state = EMPTY);
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property filled_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: (head = resize(0,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property filled_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((resize(0,32) = tail));
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property filled_2_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: (head = resize(1,32));
	at t: (tail = resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property filled_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((resize(1,32) <= tail));
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: (head = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property filled_2_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = resize(0,32)));
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
end property;


property filled_2_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = tail));
	at t: producer_sync_sig;
	at t: not(consumer_sync_sig);
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: not((tail = resize(0,32)));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
end property;


property filled_2_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: (head = resize(1,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 1;
end property;


property filled_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = resize(0,32)));
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((resize(1,32) = head));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 1;
end property;


property filled_2_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: (head = resize(2,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 2;
end property;


property filled_2_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head >= resize(1,32)));
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: (tail = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 2;
end property;


property filled_2_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 0;
end property;


property filled_2_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = tail));
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((resize(0,32) = head));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 0;
end property;


property filled_2_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(1,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 1;
end property;


property filled_2_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = resize(0,32)));
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 1;
end property;


property filled_2_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(0,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 2;
end property;


property filled_2_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = resize(1,32)));
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((head = resize(0,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 2;
end property;


property filled_2_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property filled_2_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(1,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property filled_2_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = tail));
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property filled_2_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: (state = FILLED);
	at t: not((head = tail));
	at t: not(producer_sync_sig);
	at t: not(consumer_sync_sig);
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property filled_2_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: filled_2;
	at t: not(((not((resize(3,32) <= head)) and not((resize(3,32) <= tail))) and not((head = tail))));
	at t: (state = FILLED);
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property full_3_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: (head = resize(1,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 1;
end property;


property full_3_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((resize(1,32) = head));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 1;
end property;


property full_3_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: (head = resize(2,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 2;
end property;


property full_3_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((resize(2,32) <= head));
	at t: (tail = resize(1,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 2;
end property;


property full_3_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: empty_1;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = EMPTY;
	at t_end: tail = 0;
end property;


property full_3_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	head_at_t = head@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(producer_sync_sig);
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((resize(0,32) = head));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: filled_2;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = FILLED;
	at t_end: tail = 0;
end property;


property full_3_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(0,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 1;
end property;


property full_3_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(1,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 1;
end property;


property full_3_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(0,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_0_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 1;
end property;


property full_3_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(0,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 2;
end property;


property full_3_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: (head = resize(1,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 2;
end property;


property full_3_42 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail = resize(1,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_1_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 2;
end property;


property full_3_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(0,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = producer_sig_sig_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 1;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property full_3_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: (head = resize(1,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = producer_sig_sig_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 2;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property full_3_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	producer_sig_sig_at_t = producer_sig_sig@t,
	state_at_t = state@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: producer_sync_sig;
	at t: consumer_sync_sig;
	at t: not((tail = resize(0,32)));
	at t: not((tail = resize(1,32)));
	at t: not((head = resize(0,32)));
	at t: not((head = resize(1,32)));
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = producer_sig_sig_at_t;
	at t_end: consumer_notify_sig = true;
	at t_end: consumer_sig_sig = buffer_2_at_t;
	at t_end: head = 0;
	at t_end: producer_notify_sig = true;
	at t_end: state = state_at_t;
	at t_end: tail = 0;
end property;


property full_3_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: full_3;
	at t: (state = FULL);
	at t: not(consumer_sync_sig);
	at t: (head <= resize(2,32));
	at t: (tail <= resize(2,32));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


property full_3_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_0_at_t = buffer(0)@t,
	buffer_1_at_t = buffer(1)@t,
	buffer_2_at_t = buffer(2)@t,
	consumer_sig_sig_at_t = consumer_sig_sig@t,
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: full_3;
	at t: not((not((resize(3,32) <= head)) and not((resize(3,32) <= tail))));
	at t: not((state = EMPTY));
	at t: not((state = FILLED));
prove:
	at t_end: full_3;
	at t_end: buffer(0) = buffer_0_at_t;
	at t_end: buffer(1) = buffer_1_at_t;
	at t_end: buffer(2) = buffer_2_at_t;
	at t_end: consumer_notify_sig = false;
	at t_end: consumer_sig_sig = consumer_sig_sig_at_t;
	at t_end: head = head_at_t;
	at t_end: producer_notify_sig = false;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
end property;


