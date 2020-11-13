-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro test_in_sync : boolean := true end macro;
macro test_out_sync : boolean := true end macro;
macro test_in_notify : boolean := true end  macro;
macro test_out_notify : boolean := true end  macro;


-- DP SIGNALS --
macro test_in_sig : signed :=resize(0,32) end macro;
macro test_out_sig : unsigned :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro bar : unsigned :=resize(0,32) end macro;
macro list : unsigned_5 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;


-- STATES --
macro idle_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_1;
	 at t: bar = resize(0,32);
	 at t: list(0) = resize(0,32);
	 at t: list(1) = resize(0,32);
	 at t: list(2) = resize(0,32);
	 at t: list(3) = resize(0,32);
	 at t: list(4) = resize(0,32);
	 at t: test_in_notify = true;
	 at t: test_out_notify = false;
end property;


property idle_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t,
	test_in_sig_at_t = test_in_sig@t;
assume:
	at t: idle_1;
	at t: test_in_sync;
	at t: compute3((test_in_sig > resize(5,32)),(((bar + unsigned(compute2(test_in_sig,bar)))(31 downto 0) + compute(resize(3,32),compute2(test_in_sig,(bar + unsigned(compute2(test_in_sig,bar)))(31 downto 0))))(31 downto 0) + compute(list(0),resize(5,32)))(31 downto 0));
prove:
	at t_end: state_2;
	at t_end: bar = (((bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0) + compute(3,compute2(test_in_sig_at_t,(bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0))))(31 downto 0) + compute(list_0_at_t,5))(31 downto 0);
	at t_end: list(0) = list_0_at_t;
	at t_end: list(1) = list_1_at_t;
	at t_end: list(2) = list_2_at_t;
	at t_end: list(3) = list_3_at_t;
	at t_end: list(4) = list_4_at_t;
	at t_end: test_out_sig = (((bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0) + compute(3,compute2(test_in_sig_at_t,(bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0))))(31 downto 0) + compute(list_0_at_t,5))(31 downto 0);
	during[t+1, t_end]: test_in_notify = false;
	during[t+1, t_end-1]: test_out_notify = false;
	at t_end: test_out_notify = true;
end property;


property idle_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t,
	test_in_sig_at_t = test_in_sig@t;
assume:
	at t: idle_1;
	at t: test_in_sync;
	at t: not(compute3((test_in_sig > resize(5,32)),(((bar + unsigned(compute2(test_in_sig,bar)))(31 downto 0) + compute(resize(3,32),compute2(test_in_sig,(bar + unsigned(compute2(test_in_sig,bar)))(31 downto 0))))(31 downto 0) + compute(list(0),resize(5,32)))(31 downto 0)));
prove:
	at t_end: state_3;
	at t_end: bar = (((bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0) + compute(3,compute2(test_in_sig_at_t,(bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0))))(31 downto 0) + compute(list_0_at_t,5))(31 downto 0);
	at t_end: list(0) = list_0_at_t;
	at t_end: list(1) = list_1_at_t;
	at t_end: list(2) = list_2_at_t;
	at t_end: list(3) = list_3_at_t;
	at t_end: list(4) = list_4_at_t;
	at t_end: test_out_sig = ((((bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0) + compute(3,compute2(test_in_sig_at_t,(bar_at_t + unsigned(compute2(test_in_sig_at_t,bar_at_t)))(31 downto 0))))(31 downto 0) + compute(list_0_at_t,5))(31 downto 0) + 1)(31 downto 0);
	during[t+1, t_end]: test_in_notify = false;
	during[t+1, t_end-1]: test_out_notify = false;
	at t_end: test_out_notify = true;
end property;


property state_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t;
assume:
	at t: state_2;
	at t: test_out_sync;
prove:
	at t_end: idle_1;
	at t_end: bar = bar_at_t;
	at t_end: list(0) = list_0_at_t;
	at t_end: list(1) = list_1_at_t;
	at t_end: list(2) = list_2_at_t;
	at t_end: list(3) = list_3_at_t;
	at t_end: list(4) = list_4_at_t;
	during[t+1, t_end-1]: test_in_notify = false;
	at t_end: test_in_notify = true;
	during[t+1, t_end]: test_out_notify = false;
end property;


property state_3_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t;
assume:
	at t: state_3;
	at t: test_out_sync;
prove:
	at t_end: idle_1;
	at t_end: bar = bar_at_t;
	at t_end: list(0) = list_0_at_t;
	at t_end: list(1) = list_1_at_t;
	at t_end: list(2) = list_2_at_t;
	at t_end: list(3) = list_3_at_t;
	at t_end: list(4) = list_4_at_t;
	during[t+1, t_end-1]: test_in_notify = false;
	at t_end: test_in_notify = true;
	during[t+1, t_end]: test_out_notify = false;
end property;


property wait_idle_1 is
dependencies: no_reset;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t;
assume:
	at t: idle_1;
	at t: not(test_in_sync);
prove:
	at t+1: idle_1;
	at t+1: bar = bar_at_t;
	at t+1: list(0) = list_0_at_t;
	at t+1: list(1) = list_1_at_t;
	at t+1: list(2) = list_2_at_t;
	at t+1: list(3) = list_3_at_t;
	at t+1: list(4) = list_4_at_t;
	at t+1: test_in_notify = true;
	at t+1: test_out_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t,
	test_out_sig_at_t = test_out_sig@t;
assume:
	at t: state_2;
	at t: not(test_out_sync);
prove:
	at t+1: state_2;
	at t+1: bar = bar_at_t;
	at t+1: list(0) = list_0_at_t;
	at t+1: list(1) = list_1_at_t;
	at t+1: list(2) = list_2_at_t;
	at t+1: list(3) = list_3_at_t;
	at t+1: list(4) = list_4_at_t;
	at t+1: test_out_sig = test_out_sig_at_t;
	at t+1: test_in_notify = false;
	at t+1: test_out_notify = true;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	bar_at_t = bar@t,
	list_0_at_t = list(0)@t,
	list_1_at_t = list(1)@t,
	list_2_at_t = list(2)@t,
	list_3_at_t = list(3)@t,
	list_4_at_t = list(4)@t,
	test_out_sig_at_t = test_out_sig@t;
assume:
	at t: state_3;
	at t: not(test_out_sync);
prove:
	at t+1: state_3;
	at t+1: bar = bar_at_t;
	at t+1: list(0) = list_0_at_t;
	at t+1: list(1) = list_1_at_t;
	at t+1: list(2) = list_2_at_t;
	at t+1: list(3) = list_3_at_t;
	at t+1: list(4) = list_4_at_t;
	at t+1: test_out_sig = test_out_sig_at_t;
	at t+1: test_in_notify = false;
	at t+1: test_out_notify = true;
end property;


-- GLOBAL FUNCTIONS --
macro compute(param: unsigned;param2: signed) : unsigned :=
	if (((param > resize(10,32)) and (param2 > resize(10,32)))) then unsigned((param + resize(1,32))(31 downto 0))
	else unsigned((param + unsigned(param2))(31 downto 0))
end if;
end macro;

macro compute2(param: signed;param2: unsigned) : signed :=
	signed((((param + signed(param2))(31 downto 0) + resize(3,32))(31 downto 0) + nested(param2))(31 downto 0));
end macro;

macro compute3(param: boolean;val: unsigned) : boolean :=
	if (param) then ((val + resize(2,32))(31 downto 0))
	else (val)
end if;
end macro;

macro nested(param2: unsigned) : signed :=
	signed((signed(param2) + resize(3,32))(31 downto 0));
end macro;

