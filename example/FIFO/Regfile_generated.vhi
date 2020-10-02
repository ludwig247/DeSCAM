-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := true end macro;
macro val_sync : boolean := true end macro;
macro out_notify : boolean := true end  macro;
macro val_notify : boolean := true end  macro;


-- DP SIGNALS --
macro out_sig : signed :=resize(0,32) end macro;
macro val_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_16 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro fifo_size : unsigned :=resize(0,32) end macro;
macro head : unsigned :=resize(0,32) end macro;
macro reader_notify : event :=false end macro;
macro state : states :=EMPTY end macro;
macro tail : unsigned :=resize(0,32) end macro;
macro writer_notify : event :=false end macro;


-- STATES --
macro start_state : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: tail = resize(0,32);
	 at t: out_notify = false;
	 at t: val_notify = false;
	 at t: out_notify = true;
	 at t: val_notify = false;
end property;


property start_state_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: ((((state = FULL) and not(out_sync)) and val_sync) or (((state = EMPTY) and out_sync) and not(val_sync)));
prove:
	at t_end: start_state;
	at t_end: state = state_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	reader_notify_at_t = reader_notify@t,
	tail_at_t = tail@t,
	writer_notify_at_t = writer_notify@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: (head = ((resize(4294967295,32) + tail)(31 downto 0) + fifo_size)(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(0) = ((head_at_t = 0))?val:1337;
	at t_end: buffer(1) = ((head_at_t = 1))?val:1337;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: out = buffer_at_t(tail_at_t);
	at t_end: reader_notify = reader_notify_at_t;
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) + fifo_size_at_t)(31 downto 0);
	at t_end: val = val;
	at t_end: writer_notify = writer_notify_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	reader_notify_at_t = reader_notify@t,
	tail_at_t = tail@t,
	writer_notify_at_t = writer_notify@t;
assume:
	at t: start_state;
	at t: ((((not((state = EMPTY)) and not((head = ((resize(4294967295,32) + tail)(31 downto 0) + fifo_size)(31 downto 0)))) and out_sync) and val_sync) or ((((state = EMPTY) and not((head = ((resize(4294967295,32) + tail)(31 downto 0) + fifo_size)(31 downto 0)))) and out_sync) and val_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(0) = ((head_at_t = 0))?val:1337;
	at t_end: buffer(1) = ((head_at_t = 1))?val:1337;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: out = buffer_at_t(tail_at_t);
	at t_end: reader_notify = reader_notify_at_t;
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) + fifo_size_at_t)(31 downto 0);
	at t_end: val = val;
	at t_end: writer_notify = writer_notify_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	reader_notify_at_t = reader_notify@t,
	tail_at_t = tail@t,
	writer_notify_at_t = writer_notify@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) + fifo_size)(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) + fifo_size)(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(0) = ((head_at_t = 0))?val:1337;
	at t_end: buffer(1) = ((head_at_t = 1))?val:1337;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: out = buffer_at_t(tail_at_t);
	at t_end: reader_notify = reader_notify_at_t;
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) + fifo_size_at_t)(31 downto 0);
	at t_end: val = val;
	at t_end: writer_notify = writer_notify_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	reader_notify_at_t = reader_notify@t,
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) + fifo_size)(31 downto 0));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out = buffer_at_t(tail_at_t);
	at t_end: reader_notify = reader_notify_at_t;
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) + fifo_size_at_t)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	writer_notify_at_t = writer_notify@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(0) = ((head_at_t = 0))?val:1337;
	at t_end: buffer(1) = ((head_at_t = 1))?val:1337;
	at t_end: head = ((head_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val = val;
	at t_end: writer_notify = writer_notify_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	writer_notify_at_t = writer_notify@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(0) = ((head_at_t = 0))?val:1337;
	at t_end: buffer(1) = ((head_at_t = 1))?val:1337;
	at t_end: head = ((head_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val = val;
	at t_end: writer_notify = writer_notify_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;


property start_state_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	reader_notify_at_t = reader_notify@t,
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) + fifo_size)(31 downto 0)));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out = buffer_at_t(tail_at_t);
	at t_end: reader_notify = reader_notify_at_t;
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) + fifo_size_at_t)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
	during[t+1, t_end-1]: out_notify = false;
	at t_end: out_notify = true;
	during[t+1, t_end]: val_notify = false;
end property;



