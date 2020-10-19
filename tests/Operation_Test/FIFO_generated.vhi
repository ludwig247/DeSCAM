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
macro buffer : int_8 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro head : signed :=resize(0,32) end macro;
macro state : states :=EMPTY end macro;
macro tail : signed :=resize(0,32) end macro;


-- STATES --
macro Start_State : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: Start_State;
	 at t: head = resize(0,32);
	 at t: state = EMPTY;
	 at t: tail = resize(0,32);
	 at t: out_notify = false;
	 at t: val_notify = false;
	 at t: out_notify = true;
	 at t: val_notify = false;
end property;


property Start_State_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((((resize(1,32) + head)(31 downto 0) mod resize(3,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state_at_t = state@t;
assume:
	at t: Start_State;
	at t: ((((state = FULL)
and not(out_sync))
and val_sync)
or
(((state = EMPTY)
and out_sync)
and not(val_sync)));
prove:
	at t_end: Start_State;
	at t_end: state = state_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;


property Start_State_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property Start_State_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
end property;


property Start_State_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: Start_State;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(head) = val_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
end property;


property Start_State_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: Start_State;
	at t: not(out_sync);
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: head = head_at_t;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;


property Start_State_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property Start_State_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: Start_State;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod resize(3,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: Start_State;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 3)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;



