-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro IntReq_notify :  boolean  := end macro;
macro IntSig_sync   :  boolean  := end macro;
macro fromMemoryPending_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro IntReq_sig : boolean := end macro;
macro IntSig_sig : boolean := end macro;
macro fromMemoryPending_sig : boolean := end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro int_allowed : boolean := end macro;
macro int_counter : signed := end macro;


-- STATES --
macro run_1 : boolean := true end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_1;
	 at t: IntReq_sig = false;
	 at t: int_allowed = true;
	 at t: int_counter = resize(0,32);
	 at t: IntReq_notify = true;
end property;


property run_1_read_0 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: int_allowed;
	 at t: (int_counter >= resize(1,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_1 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: int_allowed;
	 at t: (int_counter >= resize(1,32));
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_2 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter >= resize(3,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = true;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (-2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_3 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(2,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (-2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_4 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: not((not((int_counter <= resize(0,32))) and int_allowed));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_5 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: not((not((int_counter <= resize(0,32))) and int_allowed));
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_6 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter <= resize(0,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_7 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((IntSig_sync and IntSig_sig));
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(1,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (-1 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_8 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: int_allowed;
	 at t: (int_counter >= resize(1,32));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_9 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: int_allowed;
	 at t: (int_counter >= resize(1,32));
	 at t: not(IntSig_sync);
	 at t: not(fromMemoryPending_sync);
	 at t: not(IntSig_sync);
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_10 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter >= resize(3,32));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = true;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (-2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_11 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(2,32));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (-2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_12 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: not((not((int_counter <= resize(0,32))) and int_allowed));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_13 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: not((not((int_counter <= resize(0,32))) and int_allowed));
	 at t: not(IntSig_sync);
	 at t: not(fromMemoryPending_sync);
	 at t: not(IntSig_sync);
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_14 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter <= resize(0,32));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_15 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(1,32));
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
	 at t: not(IntSig_sync);
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (-1 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_16 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: int_allowed;
	 at t: (int_counter >= resize(0,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_17 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: int_allowed;
	 at t: (int_counter >= resize(0,32));
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_18 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter >= resize(1,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = true;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_19 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: (int_counter <= resize(-1,32));
	 at t: int_allowed;
	 at t: (int_counter >= resize(-1,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = true;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_20 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: not((fromMemoryPending_sync and fromMemoryPending_sig));
	 at t: not((not((int_counter <= resize(-2,32))) and int_allowed));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_21 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: (int_counter <= resize(-1,32));
	 at t: int_allowed;
	 at t: (int_counter >= resize(-1,32));
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = true;
	 at t+1: int_allowed = false;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_22 is
dependencies: no_reset;
freeze:
	int_allowed_at_t = int_allowed@t,
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: not((not((int_counter <= resize(-2,32))) and int_allowed));
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
	 at t: IntSig_sync;
	 at t: not(fromMemoryPending_sync);
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = int_allowed_at_t;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_23 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter <= resize(-2,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (2 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_24 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(-1,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = (1 + int_counter_at_t)(31 downto 0);
	 at t+1: IntReq_notify = true;
end property;

property run_1_read_25 is
dependencies: no_reset;
freeze:
	int_counter_at_t = int_counter@t;
assume:
	 at t: run_1;
	 at t: IntSig_sync;
	 at t: IntSig_sig;
	 at t: fromMemoryPending_sync;
	 at t: fromMemoryPending_sig;
	 at t: (int_counter = resize(0,32));
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
	 at t: IntSig_sync;
	 at t: fromMemoryPending_sync;
prove:
	 at t+1: run_1;
	 at t+1: IntReq_sig = false;
	 at t+1: int_allowed = true;
	 at t+1: int_counter = int_counter_at_t;
	 at t+1: IntReq_notify = true;
end property;