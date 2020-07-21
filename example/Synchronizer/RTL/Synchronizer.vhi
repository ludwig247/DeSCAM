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
macro out_sig : signed := consumer end macro;
macro out_sig_0 : signed :=consumer(31 downto 0) end macro;
macro out_sig_1 : signed :=consumer(63 downto 32) end macro;
macro out_sig_2 : signed :=consumer(95 downto 64) end macro;
macro val_0_sig : signed :=producer_0 end macro;
macro val_1_sig : signed :=producer_1 end macro;
macro val_2_sig : signed :=producer_2 end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_array := buf end macro;
--macro flags : bool_array := flags end macro;
--macro number_of_senders : unsigned :=resize(0,32) end macro;


-- STATES --
macro Start_State : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: Start_State;
	 at t: buffer(resize(0,32)) = buffer(resize(0,32));
	 at t: buffer(resize(1,32)) = buffer(resize(1,32));
	 at t: buffer(resize(2,32)) = buffer(resize(2,32));
	 at t: flags(resize(0,32)) = flags(resize(0,32));
	 at t: flags(resize(1,32)) = flags(resize(1,32));
	 at t: flags(resize(2,32)) = flags(resize(2,32));
	 at t: out_sig(resize(0,32)) = out_sig(resize(0,32));
	 at t: out_sig(resize(1,32)) = out_sig(resize(1,32));
	 at t: out_sig(resize(2,32)) = out_sig(resize(2,32));
	 at t: val_0_sig = val_0_sig;
	 at t: val_1_sig = val_1_sig;
	 at t: val_2_sig = val_2_sig;
	 at t: out_notify = false;
	 at t: val_0_notify = false;
	 at t: val_1_notify = false;
	 at t: val_2_notify = false;
end property;


property Start_State_100 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_101 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_104 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_105 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_107 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_110 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_114 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_115 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_116 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_117 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_118 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_119 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_120 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_121 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_126 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_127 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_128 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_129 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_132 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_133 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_139 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_146 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(0,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(0,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(1,32));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(1,32)));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(1,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_42 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_56 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_60 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_64 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_65 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_66 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_68 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_69 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_72 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_74 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(0,32));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_76 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_77 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_81 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_83 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(0,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_87 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(flags(resize(2,32)));
	at t: flags(resize(0,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_90 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(not(flags(resize(0,32))));
	at t: not(not(flags(resize(1,32))));
	at t: not(not(flags(resize(2,32))));
	at t: flags(resize(0,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_94 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_95 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_96 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_97 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_98 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = flags_at_t(2);
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_99 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: flags(resize(0,32)) = flags_at_t(0);
	at t_end: flags(resize(1,32)) = flags_at_t(1);
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;



