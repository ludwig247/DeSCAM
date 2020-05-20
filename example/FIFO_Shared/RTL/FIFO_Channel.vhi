-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro consumer_sync : boolean := consumer_sync end macro;
--macro producer_sync : boolean := producer_sync end macro;
--macro consumer_notify : boolean := consumer_notify end macro;
--macro producer_notify : boolean := producer_notify end macro;

-- DP SIGNALS --
macro consumer_sig : signed := consumer end macro;
macro producer_sig : signed := producer end macro;

-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;

-- VISIBLE REGISTERS --
macro buffer : int_array := fifo end macro;
--macro head : unsigned := head end macro;
--macro tail : unsigned := tail end macro;

--STATES--
macro state_empty : boolean := state = EMPTY and (head < 3) and (tail < 3) end macro; --empty state
macro state_filled : boolean := state = FILLED and (head < 3) and (tail < 3) and not(head = tail) end macro; --filled state
macro state_full : boolean := state = FULL and (head < 3) and (tail < 3) end macro; --full state

--OPERATIONS--
property reset is
assume:
	reset_sequence;
prove:
	at t: state_empty;
	at t: buffer(0) = resize(0,32);
	at t: buffer(1) = resize(0,32);
	at t: buffer(2) = resize(0,32);
	at t: head = resize(0,32);
	at t: tail = resize(0,32);
	at t: consumer_notify = false;
	at t: producer_notify = false;
	at t: consumer_sig = 0;
end property;

--Property from Empty state to Filled state
property empty_to_filled is
dependencies: no_reset;
for timepoints:
  t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t,
	consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_empty;
	at t: producer_sync;
	at t: not consumer_sync;
prove:
	at t_end: state_filled;
	at t_end: (head = ((head_at_t + 1) mod 3));
	at t_end: (tail = tail_at_t);
	at t_end: buffer(head_at_t) = producer_sig_at_t;
	at t_end: buffer((head_at_t + 1) mod 3) = buffer_at_t((head_at_t + 1) mod 3);
	at t_end: buffer((head_at_t + 2) mod 3) = buffer_at_t((head_at_t + 2) mod 3);
	at t_end: consumer_notify = false;
	at t_end: producer_notify = true;
	at t_end: consumer_sig = consumer_sig_at_t;
end property;

--Property for staying in empty state but passthrough the value from producer to consumer
property empty_to_empty_read_and_write is
dependencies: no_reset;
for timepoints:
  t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_empty;
	at t: producer_sync;
	at t: consumer_sync;
prove:
	at t_end: state_empty;
	at t_end: (head = head_at_t);
	at t_end: (tail = tail_at_t);
	at t_end: buffer = buffer_at_t;
	at t_end: consumer_sig = producer_sig_at_t;
	at t_end: consumer_notify = true;
	at t_end: producer_notify = true;
end property;



--Property for FIFO is filled and producer writes values to FIFO
property filled_to_filled_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t,
	consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_filled;
	at t: producer_sync;
	at t: not consumer_sync;
	at t: not((head_at_t + 1) mod 3 = tail_at_t); --to ensure FIFO is not full after writing
	at t: not(head_at_t = tail_at_t);
prove:
	at t_end: state_filled;
	at t_end: (head = (head_at_t + 1) mod 3);
	at t_end: (tail = tail_at_t);
	at t_end: buffer(head_at_t) = producer_sig_at_t;
	at t_end: buffer((head_at_t + 1) mod 3) = buffer_at_t((head_at_t + 1) mod 3);
	at t_end: buffer((head_at_t + 2) mod 3) = buffer_at_t((head_at_t + 2) mod 3);
    at t_end: consumer_notify = false;
    at t_end: producer_notify = true;
	at t_end: consumer_sig = consumer_sig_at_t;
end property;



--Property for FIFO is filled and consumer reads values from FIFO
property filled_to_filled_read is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_filled;
	at t: not producer_sync;
	at t: consumer_sync;
	at t: not((tail_at_t + 1) mod 3 = head_at_t);
	at t: not(head_at_t = tail_at_t);
prove:
	at t_end: state_filled;
  at t_end: (head = head_at_t);
  at t_end: (tail = (tail_at_t + 1) mod 3);
	at t_end: buffer = buffer_at_t;
	at t_end: consumer_sig = buffer_at_t(tail_at_t);
  at t_end: consumer_notify = true;
  at t_end: producer_notify = false;
end property;

--Property for staying in filled state with read and write
property filled_to_filled_read_and_write is
dependencies: no_reset;
for timepoints:
  t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_filled;
	at t: producer_sync;
	at t: consumer_sync;
	at t: not(head_at_t = tail_at_t);
prove:
	at t_end: state_filled;
	at t_end: (head = (head_at_t + 1) mod 3);
  at t_end: (tail = (tail_at_t + 1) mod 3);
	at t_end: buffer(head_at_t) = producer_sig_at_t;
	at t_end: buffer((head_at_t + 1) mod 3) = buffer_at_t((head_at_t + 1) mod 3);
	at t_end: buffer((head_at_t + 2) mod 3) = buffer_at_t((head_at_t + 2) mod 3);
	at t_end: consumer_sig = buffer_at_t(tail_at_t);
	at t_end: consumer_notify = true;
	at t_end: producer_notify = true;
end property;


--Property from Filled state to Empty state
property filled_to_empty is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_filled;
	at t: consumer_sync;
	at t: not producer_sync;
	at t: (tail_at_t + 1) mod 3 = head_at_t;
	at t: not(head_at_t = tail_at_t);
prove:
	at t_end: state_empty;
  at t_end: (head = head_at_t);
  at t_end: (tail = (tail_at_t + 1) mod 3);
	at t_end: buffer = buffer_at_t;
	at t_end: consumer_sig = buffer_at_t(tail_at_t);
  at t_end: consumer_notify = true;
  at t_end: producer_notify = false;
end property;



--Property from Filled state to Full state

property filled_to_full is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t,
	consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_filled;
	at t: producer_sync;
	at t: not consumer_sync;
	at t: (head_at_t + 1) mod 3 = tail_at_t;
	at t: not(head_at_t = tail_at_t);
prove:
	at t_end: state_full;
  at t_end: (head = (head_at_t + 1) mod 3);
  at t_end: (tail = tail_at_t);
	at t_end: buffer(head_at_t) = producer_sig_at_t;
	at t_end: buffer((head_at_t + 1) mod 3) = buffer_at_t((head_at_t + 1) mod 3);
	at t_end: buffer((head_at_t + 2) mod 3) = buffer_at_t((head_at_t + 2) mod 3);
	at t_end: consumer_notify = false;
  at t_end: producer_notify = true;
	at t_end: consumer_sig = consumer_sig_at_t;
end property;



--Property from Full state to Filled state
property full_to_filled is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_full;
	at t: consumer_sync;
	at t: not producer_sync;
prove:
	at t_end: state_filled;
  at t_end: (head = head_at_t);
  at t_end: (tail = (tail_at_t + 1) mod 3);
	at t_end: buffer = buffer_at_t;
	at t_end: consumer_sig = buffer(tail_at_t);
  at t_end: consumer_notify = true;
  at t_end: producer_notify = false;
end property;

--Property for staying in full state with read and write
property full_to_full_read_and_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
  buffer_at_t = buffer@t,
  head_at_t = head@t,
  tail_at_t = tail@t,
  producer_sig_at_t = producer_sig@t;
assume:
	at t: state_full;
	at t: consumer_sync;
	at t: producer_sync;
prove:
	at t_end: state_full;
  at t_end: (head = (head_at_t + 1) mod 3);
  at t_end: (tail = (tail_at_t + 1) mod 3);
	at t_end: buffer(head_at_t) = producer_sig_at_t;
	at t_end: buffer((head_at_t + 1) mod 3) = buffer_at_t((head_at_t + 1) mod 3);
	at t_end: buffer((head_at_t + 2) mod 3) = buffer_at_t((head_at_t + 2) mod 3);
	at t_end: consumer_sig = buffer_at_t(tail_at_t);
  at t_end: consumer_notify = true;
  at t_end: producer_notify = true;
end property;

--Wait Properties

--Property wait in Empty state
property wait_in_empty is
dependencies: no_reset;
for timepoints:
    t_end = t+1;
freeze:
    buffer_at_t = buffer@t,
    head_at_t = head@t,
    tail_at_t = tail@t,
    consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_empty;
	at t: not producer_sync;
prove:
	at t_end: state_empty;
	at t_end: (head = head_at_t);
	at t_end: (tail = tail_at_t);
	at t_end: (buffer = buffer_at_t);
	at t_end: (consumer_sig = consumer_sig_at_t);
	at t_end: (consumer_notify = false);
	at t_end: (producer_notify = false);
end property;

--Property wait in Filled state
property wait_in_filled is
dependencies: no_reset;
for timepoints:
    t_end = t+1;
freeze:
    buffer_at_t = buffer@t,
    head_at_t = head@t,
    tail_at_t = tail@t,
    consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_filled;
	at t: not producer_sync;
	at t: not consumer_sync;
	at t: not (head_at_t = tail_at_t);
prove:
	at t_end: state_filled;
	at t_end: (head = head_at_t);
	at t_end: (tail = tail_at_t);
	at t_end: (buffer = buffer_at_t);
	at t_end: (consumer_sig = consumer_sig_at_t);
	at t_end: (consumer_notify = false);
	at t_end: (producer_notify = false);
end property;

--Property wait in Full state
property wait_in_full is
dependencies: no_reset;
for timepoints:
    t_end = t+1;
freeze:
    buffer_at_t = buffer@t,
    head_at_t = head@t,
    tail_at_t = tail@t,
    consumer_sig_at_t = consumer_sig@t;
assume:
	at t: state_full;
	at t: not consumer_sync;
prove:
	at t_end: state_full;
	at t_end: (head = head_at_t);
	at t_end: (tail = tail_at_t);
	at t_end: (buffer = buffer_at_t);
	at t_end: (consumer_sig = consumer_sig_at_t);
	at t_end: (consumer_notify = false);
	at t_end: (producer_notify = false);
end property;
