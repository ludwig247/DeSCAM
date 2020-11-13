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


-- STATES --
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: bar = ((((number + resize(0,32))(31 downto 0) + number2)(31 downto 0) + unsigned(number3))(31 downto 0) + test_var(number2))(31 downto 0);
	 at t: test_out_sig = ((((number + resize(0,32))(31 downto 0) + number2)(31 downto 0) + unsigned(number3))(31 downto 0) + test_var(number2))(31 downto 0);
	 at t: test_in_notify = false;
	 at t: test_out_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	bar_at_t = bar@t;
assume:
	at t: state_1;
	at t: test_out_sync;
	at t: not(number4);
prove:
	at t_end: state_1;
	at t_end: bar = ((((number + bar_at_t)(31 downto 0) + number2)(31 downto 0) + unsigned(number3))(31 downto 0) + test_var(number2))(31 downto 0);
	at t_end: test_out_sig = ((((number + bar_at_t)(31 downto 0) + number2)(31 downto 0) + unsigned(number3))(31 downto 0) + test_var(number2))(31 downto 0);
	during[t+1, t_end]: test_in_notify = false;
	during[t+1, t_end-1]: test_out_notify = false;
	at t_end: test_out_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	bar_at_t = bar@t,
	test_out_sig_at_t = test_out_sig@t;
assume:
	at t: state_1;
	at t: not(test_out_sync);
prove:
	at t+1: state_1;
	at t+1: bar = bar_at_t;
	at t+1: test_out_sig = test_out_sig_at_t;
	at t+1: test_in_notify = false;
	at t+1: test_out_notify = true;
end property;


-- FUNCTIONS --
macro test_var(val: unsigned) : unsigned :=
	unsigned(((val + resize(3,32))(31 downto 0) + number)(31 downto 0));
end macro;

