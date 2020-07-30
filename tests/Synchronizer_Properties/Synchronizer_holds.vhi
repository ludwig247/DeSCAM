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
	 at t: start_state;
	 at t: buffer(resize(0,32)) = buffer(resize(0,32));
	 at t: buffer(resize(1,32)) = buffer(resize(1,32));
	 at t: buffer(resize(2,32)) = buffer(resize(2,32));
	 at t: cnt = resize(0,32);
	 at t: flags(0) = false;
	 at t: flags(1) = false;
	 at t: flags(2) = false;
	 at t: out_sig(resize(0,32)) = out_sig(resize(0,32));
	 at t: out_sig(resize(1,32)) = out_sig(resize(1,32));
	 at t: out_sig(resize(2,32)) = out_sig(resize(2,32));
	 at t: out_notify = false;
	 at t: val_0_notify = false;
	 at t: val_1_notify = false;
	 at t: val_2_notify = false;
end property;


property start_state_100 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(2);
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_102 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(2);
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_103 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(2));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_105 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(2));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_120 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((0 + 1)+1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_121 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(1);
	at t: flags(2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_122 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(1);
	at t: not(flags(2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_123 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(1));
	at t: flags(2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_124 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_125 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(1);
	at t: flags(2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_126 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(1);
	at t: not(flags(2));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_128 is
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
	at t: (cnt < resize(3,32));
	at t: flags(1);
	at t: not(flags(2));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_129 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: flags(2);
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
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
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: flags(2);
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_132 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: not(flags(2));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_134 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_149 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not(false);
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((0 + 1)+1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_150 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: flags(1);
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_151 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: flags(1);
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_152 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: not(flags(1));
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_153 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_154 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: flags(1);
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_155 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: flags(1);
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_156 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: not(flags(1));
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_157 is
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
	at t: start_state;
	at t: not(flags(0));
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_158 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: flags(1);
	at t: flags(2);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_159 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: flags(1);
	at t: not(flags(2));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
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
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: flags(1);
	at t: not(flags(2));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_162 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: flags(2);
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_164 is
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
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: flags(2);
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_165 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: not(flags(2));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_167 is
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
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_168 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: flags(2);
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_170 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: flags(2);
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(resize(0,32)) = buffer_at_t(0);
	at t_end: out_sig(resize(1,32)) = buffer_at_t(1);
	at t_end: out_sig(resize(2,32)) = buffer_at_t(2);
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
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: not(flags(2));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_173 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: not(flags(2));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_174 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(1));
	at t: flags(2);
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_176 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(1));
	at t: flags(2);
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_179 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(1));
	at t: not(flags(2));
	at t: not(((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
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
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: cnt = (((0 + 1) + 1) + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = true;
end property;


property start_state_211 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
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
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_23 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
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
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_36 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not(false);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(1);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(1));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(1);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
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
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_42 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(1));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_49 is
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: flags(1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: not(flags(1));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: flags(1);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: not(flags(1));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
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
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: flags(1);
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_55 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_57 is
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
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(1));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_58 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_60 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: flags(1);
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(1));
	at t: (((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_63 is
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
	at t: (cnt < resize(3,32));
	at t: not(flags(0));
	at t: not(flags(1));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not((((cnt + resize(1,32))(31 downto 0) + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: val_1_sync;
	at t: not(val_2_sync);
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = val_1_sig_at_t;
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer(0);
	at t_end: out_sig(63 downto 32) = buffer(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
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
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = ((0 + 1)+1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = true;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = true;
	at t_end: val_2_notify = false;
end property;


property start_state_79 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(2);
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
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
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(2));
	at t: not(out_sync);
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_81 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(2);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: not(flags(2));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
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
	at t: (cnt < resize(3,32));
	at t: not(flags(2));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = 0;
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
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
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not((cnt < resize(3,32)));
	at t: not(false);
	at t: out_sync;
	at t: not(val_0_sync);
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = false;
	at t_end: flags(1) = false;
	at t_end: flags(2) = true;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer_at_t(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_92 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_93 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: flags(0);
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_94 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: flags(2);
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_95 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: not(flags(0));
	at t: not(flags(2));
	at t: not(out_sync);
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = ((cnt_at_t + 1)(31 downto 0) + 1)(31 downto 0);
	at t_end: flags(0) = true;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_96 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	flags_2_at_t = flags(2)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: flags(2);
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = buffer_at_t(2);
	at t_end: cnt = cnt_at_t;
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = flags_2_at_t;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = false;
end property;


property start_state_97 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer_at_t = buffer@t,
	cnt_at_t = cnt@t,
	flags_0_at_t = flags(0)@t,
	flags_1_at_t = flags(1)@t,
	out_sig_at_t = out_sig@t,
	val_0_sig_at_t = val_0_sig@t,
	val_1_sig_at_t = val_1_sig@t,
	val_2_sig_at_t = val_2_sig@t;
assume:
	at t: start_state;
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(2));
	at t: ((cnt + resize(1,32))(31 downto 0) < resize(3,32));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = buffer_at_t(0);
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (cnt_at_t + 1)(31 downto 0);
	at t_end: flags(0) = flags_0_at_t;
	at t_end: flags(1) = flags_1_at_t;
	at t_end: flags(2) = true;
	at t_end: out_sig(resize(0,32)) = out_sig_at_t(0);
	at t_end: out_sig(resize(1,32)) = out_sig_at_t(1);
	at t_end: out_sig(resize(2,32)) = out_sig_at_t(2);
	at t_end: out_notify = false;
	at t_end: val_0_notify = false;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;


property start_state_99 is
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
	at t: (cnt < resize(3,32));
	at t: flags(0);
	at t: not(flags(2));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: not(((cnt + resize(1,32))(31 downto 0) < resize(3,32)));
	at t: out_sync;
	at t: val_0_sync;
	at t: not(val_1_sync);
	at t: val_2_sync;
prove:
	at t_end: start_state;
	at t_end: buffer(resize(0,32)) = val_0_sig_at_t;
	at t_end: buffer(resize(1,32)) = buffer_at_t(1);
	at t_end: buffer(resize(2,32)) = val_2_sig_at_t;
	at t_end: cnt = (0 + 1);
	at t_end: flags(0) = true;
	at t_end: flags(1) = false;
	at t_end: flags(2) = false;
	at t_end: out_sig(31 downto 0) = buffer_at_t(0);
	at t_end: out_sig(63 downto 32) = buffer_at_t(1);
	at t_end: out_sig(95 downto 64) = buffer(2);
	at t_end: out_notify = true;
	at t_end: val_0_notify = true;
	at t_end: val_1_notify = false;
	at t_end: val_2_notify = true;
end property;
