-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := true end macro;
macro val_0_sync : boolean := true end macro;
macro val_1_sync : boolean := true end macro;
macro val_2_sync : boolean := true end macro;
macro out_notify : boolean := true end  macro;
macro val_0_notify : boolean := true end  macro;
macro val_1_notify : boolean := true end  macro;
macro val_2_notify : boolean := true end  macro;


-- DP SIGNALS --
macro out_sig : signed :=resize(0,32) end macro;
macro val_0_sig : signed :=resize(0,32) end macro;
macro val_1_sig : signed :=resize(0,32) end macro;
macro val_2_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_8 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro head : signed :=resize(0,32) end macro;
macro state : states :=EMPTY end macro;
macro tail : signed :=resize(0,32) end macro;


-- STATES --
macro start_state : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: head = resize(0,32);
	 at t: state = EMPTY;
	 at t: tail = resize(0,32);
	 at t: out_notify = false;
	 at t: val_0_notify = false;
	 at t: val_1_notify = false;
	 at t: val_2_notify = false;
end property;


property start_state_106 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((state = EMPTY)) and
	 (((resize(1,32) + ((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 val_2_sync)
	or
	((((((((state = EMPTY) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = tail)) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 (((resize(1,32) + ((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_116 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (((((((not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 not((((resize(1,32) + ((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 val_2_sync)
	or
	(((((((state = EMPTY) and
	 not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail))) and
	 not((((resize(1,32) + ((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_120 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_0_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_166 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((state = EMPTY)) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 val_0_sync) and
	 not(val_1_sync)) and
	 val_2_sync)
	or
	((((((((state = EMPTY) and
	 (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail)) and
	 not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 val_0_sync) and
	 not(val_1_sync)) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_0_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_176 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 not(val_1_sync)) and
	 val_2_sync)
	or
	((((((state = EMPTY) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 not(val_1_sync)) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_180 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: ((((((state = FULL) and
	 not(out_sync)) and
	 val_2_sync)
	or
	(((state = FULL) and
	 not(out_sync)) and
	 val_1_sync))
	or
	(((state = FULL) and
	 not(out_sync)) and
	 val_0_sync))
	or
	(((((state = EMPTY) and
	 out_sync) and
	 not(val_0_sync)) and
	 not(val_1_sync)) and
	 not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: state = state_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_210 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_214 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_225 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_237 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((state = EMPTY)) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 not(val_0_sync)) and
	 val_1_sync) and
	 val_2_sync)
	or
	((((((((state = EMPTY) and
	 (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail)) and
	 not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 not(val_0_sync)) and
	 val_1_sync) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_247 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 not(val_0_sync)) and
	 val_1_sync) and
	 val_2_sync)
	or
	((((((state = EMPTY) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 not(val_0_sync)) and
	 val_1_sync) and
	 val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_251 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_0_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_281 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_285 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_296 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0)));
	at t: not((FILLED = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_302 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_0_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_0_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_304 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_0_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_318 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_320 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_347 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: (((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_349 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_363 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: (((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_365 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_369 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_371 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_385 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: (((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_387 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_391 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: (((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FULL;
	at t_end: tail = tail_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_393 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_2_sig_at_t;
	at t_end: head = ((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: state = FILLED;
	at t_end: tail = tail_at_t;
	at t_end: val_2_sig = val_2_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_394 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	head_at_t = head@t,
	state_at_t = state@t,
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head = head_at_t;
	at t_end: state = state_at_t;
	at t_end: tail = tail_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: (head = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (((((not((state = EMPTY)) and
	 (((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync)
	or
	(((((state = EMPTY) and
	 (((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = tail)) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FULL;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: ((((((not((((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0))) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 not(val_2_sync))
	or
	((((((state = EMPTY) and
	 not((((resize(1,32) + ((resize(1,32) + head)(31 downto 0) mod resize(8,32))(31 downto 0))(31 downto 0) mod resize(8,32))(31 downto 0) = ((resize(1,32) + tail)(31 downto 0) mod resize(8,32))(31 downto 0)))) and
	 out_sync) and
	 val_0_sync) and
	 val_1_sync) and
	 not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (state = EMPTY);
	at t: not((state = FULL));
	at t: not((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = FULL));
	at t: not((((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = tail));
	at t: not((FILLED = EMPTY));
	at t: (((((head + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0) = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(head) = val_1_sig_at_t;
	at t_end: head = ((((head_at_t + 1)(31 downto 0) mod 8)(31 downto 0) + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = EMPTY;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: val_0_sig = val_0_sig_at_t;
	at t_end: val_1_sig = val_1_sig_at_t;
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
	buffer_at_t = buffer@t,
	head_at_t = head@t,
	tail_at_t = tail@t;
assume:
	at t: start_state;
	at t: not((state = EMPTY));
	at t: not((head = ((tail + resize(1,32))(31 downto 0) mod resize(8,32))(31 downto 0)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: head = head_at_t;
	at t_end: out_sig = buffer_at_t(tail_at_t);
	at t_end: state = FILLED;
	at t_end: tail = ((tail_at_t + 1)(31 downto 0) mod 8)(31 downto 0);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;



