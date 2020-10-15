-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := consumer_sync end macro;
macro val_0_sync : boolean := producer_0_sync end macro;
macro val_1_sync : boolean := producer_1_sync end macro;
macro val_2_sync : boolean := producer_2_sync end macro;
macro out_notify : boolean := consumer_notify end  macro;
macro val_0_notify : boolean := producer_0_notify end  macro;
macro val_1_notify : boolean := producer_1_notify end  macro;
macro val_2_notify : boolean := producer_2_notify end  macro;


-- DP SIGNALS --
macro out_sig(n : unsigned) : signed :=
if(n = 0) then signed(consumer(31 downto 0))
elsif (n = 1) then signed(consumer(63 downto 32))
else signed(consumer(95 downto 64))
end if;
end macro;
macro val_0_sig : signed :=producer_0 end macro;
macro val_1_sig : signed :=producer_1 end macro;
macro val_2_sig : signed :=producer_2 end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_array := buf end macro;
macro flag0 : boolean :=flags(0) end macro;
macro flag1 : boolean :=flags(1) end macro;
macro flag2 : boolean :=flags(2) end macro;


-- STATES --
macro start_state : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: buffer(resize(0,32)) = resize(0,32);
	 at t: buffer(resize(1,32)) = resize(0,32);
	 at t: buffer(resize(2,32)) = resize(0,32);
	 at t: flag0 = false;
	 at t: flag1 = false;
	 at t: flag2 = false;
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
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: flag0;
	at t: not(flag1);
	at t: flag2;
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_111 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: flag0;
	at t: not(flag1);
	at t: not(flag2);
	at t: not(not(true));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_121 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(flag2);
	at t: flag0;
	at t: flag1;
	at t: not(flag2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
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
	flag1_at_t = flag1@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: ((((((not(flag0) and flag1) and not(out_sync)) and val_0_sync) and val_1_sync) and not(val_2_sync)) or (((((not(flag0) and not(flag1)) and out_sync) and val_0_sync) and not(val_1_sync)) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = flag1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_131 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_141 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: flag2;
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_144 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag1_at_t = flag1@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (((((((not(flag0) and flag1) and not(flag2)) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or ((((((not(flag0) and not(flag2)) and not(flag1)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_147 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: not(flag2);
	at t: not(not(flag1));
	at t: not(not(true));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag1_at_t = flag1@t,
	flag2_at_t = flag2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: ((((((((not(flag0) and flag1) and flag2) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or ((((((not(flag0) and flag2) and not(flag1)) and out_sync) and val_0_sync) and not(val_1_sync)) and val_2_sync)) or (((((not(flag0) and flag1) and not(flag2)) and out_sync) and val_0_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_153 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	flag1_at_t = flag1@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((((flag0 and flag1) and not(flag2)) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or (((((flag0 and not(flag1)) and not(flag2)) and out_sync) and not(val_1_sync)) and val_2_sync)) or ((((((not(flag0) and flag1) and not(flag2)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_161 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(flag2);
	at t: flag0;
	at t: not(flag2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_168 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
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
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_173 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: ((((((flag0 and not(flag1)) and not(out_sync)) and val_0_sync) and val_1_sync) and not(val_2_sync)) or (((((not(flag0) and not(flag1)) and out_sync) and not(val_0_sync)) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_180 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: not(flag1);
	at t: not(not(flag2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_188 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_199 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (((((((flag0 and not(flag1)) and not(flag2)) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or ((((((not(flag0) and not(flag1)) and not(flag2)) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t;
assume:
	at t: start_state;
	at t: (((((flag0 and not(out_sync)) and val_0_sync) and not(val_1_sync)) and not(val_2_sync)) or ((((not(flag0) and out_sync) and not(val_0_sync)) and not(val_1_sync)) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: flag0 = flag0_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_207 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: not(flag1);
	at t: flag2;
	at t: not(not(flag2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_211 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: not(flag1);
	at t: not(flag2);
	at t: not(not(true));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_218 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(flag2);
	at t: flag1;
	at t: not(flag2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_225 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_228 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	flag2_at_t = flag2@t;
assume:
	at t: start_state;
	at t: ((((((flag0 and flag2) and not(out_sync)) and val_0_sync) and not(val_1_sync)) and val_2_sync) or (((((not(flag0) and flag2) and out_sync) and not(val_0_sync)) and not(val_1_sync)) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_230 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: ((((((flag0 and not(flag2)) and not(out_sync)) and val_0_sync) and not(val_1_sync)) and val_2_sync) or (((((not(flag0) and not(flag2)) and out_sync) and not(val_0_sync)) and not(val_1_sync)) and val_2_sync));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_240 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(flag2);
	at t: not(flag2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_244 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_248 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_258 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_280 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag1);
	at t: not(flag2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_288 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag2_at_t = flag2@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: flag2;
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_290 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_0_sig_at_t = val_0_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_292 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag1_at_t = flag1@t;
assume:
	at t: start_state;
	at t: flag1;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: flag1 = flag1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_294 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(flag1);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag1 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_297 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag1_at_t = flag1@t,
	flag2_at_t = flag2@t;
assume:
	at t: start_state;
	at t: flag1;
	at t: flag2;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_299 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag1_at_t = flag1@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flag1;
	at t: not(flag2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_302 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag2_at_t = flag2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(flag1);
	at t: flag2;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag1 = true;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_304 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag1);
	at t: not(flag2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_306 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag2_at_t = flag2@t;
assume:
	at t: start_state;
	at t: flag2;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_308 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag2 = true;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_309 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flag0_at_t = flag0@t,
	flag1_at_t = flag1@t,
	flag2_at_t = flag2@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: flag1;
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	flag1_at_t = flag1@t;
assume:
	at t: start_state;
	at t: (((((((flag0 and flag1) and not(out_sync)) and val_0_sync) and val_1_sync) and not(val_2_sync)) or (((((not(flag0) and flag1) and out_sync) and not(val_0_sync)) and val_1_sync) and not(val_2_sync))) or ((((flag0 and not(flag1)) and out_sync) and not(val_1_sync)) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = flag1_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag2_at_t = flag2@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: (((((((not(flag0) and not(flag1)) and flag2) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or ((((((not(flag0) and not(flag1)) and not(flag2)) and out_sync) and val_0_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: not(flag1);
	at t: not(not(true));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	flag0_at_t = flag0@t,
	flag2_at_t = flag2@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: ((((((((flag0 and not(flag1)) and flag2) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or ((((((not(flag0) and not(flag1)) and flag2) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync)) or (((((flag0 and not(flag1)) and not(flag2)) and out_sync) and val_1_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = true;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(flag1);
	at t: flag0;
	at t: not(flag1);
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
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
	flag0_at_t = flag0@t,
	flag1_at_t = flag1@t,
	flag2_at_t = flag2@t;
assume:
	at t: start_state;
	at t: (((((((((flag0 and flag1) and flag2) and not(out_sync)) and val_0_sync) and val_1_sync) and val_2_sync) or (((((flag0 and not(flag1)) and flag2) and out_sync) and not(val_1_sync)) and val_2_sync)) or ((((((not(flag0) and flag1) and flag2) and out_sync) and not(val_0_sync)) and val_1_sync) and val_2_sync)) or ((((flag0 and flag1) and not(flag2)) and out_sync) and not(val_2_sync)));
prove:
	at t_end: start_state;
	at t_end: flag0 = flag0_at_t;
	at t_end: flag1 = flag1_at_t;
	at t_end: flag2 = flag2_at_t;
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: flag0 = true;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_78 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: flag1;
	at t: flag2;
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
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
	buffer_at_t = buffer@t;
assume:
	at t: start_state;
	at t: not(not(flag0));
	at t: not(not(flag1));
	at t: not(not(flag2));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_84 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: flag1;
	at t: not(flag2);
	at t: not(not(flag1));
	at t: not(not(true));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = true;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_91 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: not(flag1);
	at t: flag2;
	at t: not(not(true));
	at t: not(not(flag2));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = true;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_96 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flag0);
	at t: not(flag0);
	at t: not(flag1);
	at t: not(flag2);
	at t: not(not(true));
	at t: not(not(true));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flag0 = false;
	at t_end: flag1 = false;
	at t_end: flag2 = false;
	at t_end: out_sig(resize(0,32)) = val_0_sig_at_t;
	at t_end: out_sig(resize(1,32)) = val_1_sig_at_t;
	at t_end: out_sig(resize(2,32)) = val_2_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;



