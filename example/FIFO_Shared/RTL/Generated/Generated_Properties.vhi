-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := consumer_sync end macro;
macro val_sync : boolean := producer_sync end macro;
macro out_notify : boolean := consumer_notify end  macro;
macro val_notify : boolean := producer_notify end  macro;


-- DP SIGNALS --
macro out_sig : signed :=consumer end macro;
macro val_sig : signed :=producer end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_array := fifo end macro;
--macro fifo_size : unsigned :=resize(3,32) end macro;
--macro head : signed :=head end macro;
macro reader_notify : boolean :=false end macro;
--macro state : states :=state end macro;
--macro tail : signed :=tail end macro;
macro writer_notify : boolean :=false end macro;


-- STATES --
macro Start_State : boolean := (head<3) and (tail<3) and((state = EMPTY) and (head = tail) or (state = FILLED) and not(head = tail) or (state = FULL) and (head = tail))
end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: Start_State;
	 at t: buffer(0) = 0;
     at t: buffer(1) = 0;
     at t: buffer(2) = 0;
	 at t: fifo_size = fifo_size;
	 at t: head = resize(0,32);
	 at t: out_sig = out_sig;
	 at t: state = EMPTY;
	 at t: tail = resize(0,32);
	 at t: out_notify = false;
	 at t: val_notify = false;
end property;


property Start_State_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	out_sig_at_t = out_sig@t,
	state_at_t = state@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = buffer_at_t(head_at_t);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+2)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out_sig = out_sig_at_t;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;


property Start_State_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = buffer_at_t(head_at_t);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+2)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property Start_State_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = buffer_at_t(head_at_t);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+2)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property Start_State_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	out_sig_at_t = out_sig@t,
	state_at_t = state@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = FULL);
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = buffer_at_t(head_at_t);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+2)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = head_at_t;
	at t_end: out_sig = out_sig_at_t;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;


property Start_State_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fifo_size_at_t = fifo_size@t,
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	out_sig_at_t = out_sig@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;             --Changed head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = out_sig_at_t;
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
end property;


property Start_State_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fifo_size_at_t = fifo_size@t,
    buffer_at_t = buffer@t,
	head_at_t = head@t,
	out_sig_at_t = out_sig@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;     --CHANGED head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = out_sig_at_t;
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
end property;


property Start_State_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail);
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail);
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;         --Changed head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer(tail_at_t);              --Changed buffer_at_t to buffer
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = tail));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: not((EMPTY = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: not((EMPTY = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;             --Changed head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;                 --Changed head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod signed(fifo_size))(31 downto 0)));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head_at_t) = val_sig_at_t;                 --Changed head to head_at_t
    at t_end: buffer((head)mod fifo_size) = buffer_at_t((head_at_t+1)mod fifo_size);
    at t_end: buffer((head+1)mod fifo_size) = buffer_at_t((head_at_t+2)mod fifo_size);
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: head = ((head_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1) mod signed(fifo_size_at_t))(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;

property wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	fifo_size_at_t = fifo_size@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t,
	state_at_t = state@t;
assume:
	at t: Start_State;
	at t: not(out_sync);
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: fifo_size = fifo_size_at_t;
	at t_end: buffer = buffer_at_t;
	at t_end: head = head_at_t;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;



