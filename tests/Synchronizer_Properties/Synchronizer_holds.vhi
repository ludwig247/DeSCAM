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
macro out_sig_0 : signed :=consumer(31 downto 0) end macro;
macro out_sig_1 : signed :=consumer(63 downto 32) end macro;
macro out_sig_2 : signed :=consumer(95 downto 64) end macro;
macro out_sig : signed := out_sig_2 & out_sig_1 & out_sig_0 end macro;
macro val_0_sig : signed :=producer_0 end macro;
macro val_1_sig : signed :=producer_1 end macro;
macro val_2_sig : signed :=producer_2 end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer : int_array := buf end macro;
--macro flags : bool_array := flags end macro;
--macro number_of_senders : unsigned :=resize(0,32) end macro;
macro cnt_0 : unsigned := (flags(0)=true) ? resize(1,32) : resize(0,32) end macro;
macro cnt_1 : unsigned := (flags(1)=true) ? resize(1,32) : resize(0,32) end macro;
macro cnt_2 : unsigned := (flags(2)=true) ? resize(1,32) : resize(0,32) end macro;
macro cnt : unsigned := cnt_0 + cnt_1 + cnt_2 end macro;

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
	 at t: cnt = resize(0,32);
	 at t: flags(resize(0,32)) = false;
	 at t: flags(resize(1,32)) = false;
	 at t: flags(resize(2,32)) = false;
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
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(2,32));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_102 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(2,32));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_103 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(2,32)));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_105 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(2,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_117 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_118 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_119 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_120 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_121 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_122 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_123 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_124 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_125 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_126 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_128 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_129 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_131 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_132 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_134 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_147 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_148 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_149 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_150 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_151 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_152 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_153 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_154 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_155 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_156 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_157 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_158 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_159 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_161 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_162 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_164 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_165 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_167 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_168 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_170 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: flags(resize(2,32));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_171 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_173 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(flags(resize(2,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_174 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_176 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: flags(resize(2,32));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_179 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not(flags(resize(2,32)));
	at t: not(((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
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


property Start_State_203 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_204 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_205 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_206 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property Start_State_207 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_208 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_209 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_210 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (((0 + 1) + 1) + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
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
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_29 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_35 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_36 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(1,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_48 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_49 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_55 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_57 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(1,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_58 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: flags(resize(1,32));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_63 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(0,32)));
	at t: not(flags(resize(1,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_75 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_76 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_77 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_78 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = ((0 + 1) + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = true;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property Start_State_79 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_81 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(2,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_84 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(resize(2,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = 0;
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property Start_State_91 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = false;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property Start_State_92 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_93 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_94 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_95 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
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
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
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


property Start_State_96 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
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
	at t_end: cnt = cnt_at_t;
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


property Start_State_97 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_at_t = flags@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: Start_State;
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(2,32)));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
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


property Start_State_99 is
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
	at t: (cnt < resize(3,32));
	at t: flags(resize(0,32));
	at t: not(flags(resize(2,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: Start_State;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(resize(0,32)) = true;
	at t_end: flags(resize(1,32)) = false;
	at t_end: flags(resize(2,32)) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;



