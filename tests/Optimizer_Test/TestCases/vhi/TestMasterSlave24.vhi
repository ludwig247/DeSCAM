-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_1_sync : boolean := end macro;
macro s_in_2_sync : boolean := end macro;
macro s_in_3_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_1_sig : signed := end macro;
macro s_in_2_sig : signed := end macro;
macro s_in_3_sig : signed := end macro;
macro s_out_1_sig : signed := end macro;
macro s_out_2_sig : signed := end macro;
macro s_out_3_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro data1 : signed := end macro;
macro data2 : signed := end macro;
macro data3 : signed := end macro;


-- STATES --
macro state_2 : boolean := true end macro;
macro state_1 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: data1 = resize(0,32);
	 at t: data2 = resize(0,32);
	 at t: data3 = resize(0,32);
	 at t: s_out_1_sig = resize(0,32);
	 at t: s_out_2_sig = resize(0,32);
	 at t: s_out_3_sig = resize(0,32);
end property;


property state_2_17 is
dependencies: no_reset;
freeze:
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = (1 + s_in_1_sig_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + s_in_2_sig_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + s_in_3_sig_at_t)(31 downto 0);
end property;


property state_2_18 is
dependencies: no_reset;
freeze:
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = (1 + s_in_1_sig_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + s_in_2_sig_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + data3_at_t)(31 downto 0);
end property;


property state_2_19 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = (1 + s_in_1_sig_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + data2_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + s_in_3_sig_at_t)(31 downto 0);
end property;


property state_2_20 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = (1 + s_in_1_sig_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + data2_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + data3_at_t)(31 downto 0);
end property;


property state_2_21 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = (1 + data1_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + s_in_2_sig_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + s_in_3_sig_at_t)(31 downto 0);
end property;


property state_2_22 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data3_at_t = data3@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = (1 + data1_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + s_in_2_sig_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + data3_at_t)(31 downto 0);
end property;


property state_2_23 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = (1 + data1_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + data2_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + s_in_3_sig_at_t)(31 downto 0);
end property;


property state_2_24 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	data3_at_t = data3@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = (1 + data1_at_t)(31 downto 0);
	at t+1: s_out_2_sig = (1 + data2_at_t)(31 downto 0);
	at t+1: s_out_3_sig = (1 + data3_at_t)(31 downto 0);
end property;


property state_1_1 is
dependencies: no_reset;
freeze:
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
freeze:
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_4 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_6 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data3_at_t = data3@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_7 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_8 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t+1: state_2;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_9 is
dependencies: no_reset;
freeze:
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_10 is
dependencies: no_reset;
freeze:
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_11 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	s_in_1_sig_at_t = s_in_1_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_12 is
dependencies: no_reset;
freeze:
	data2_at_t = data2@t,
	data3_at_t = data3@t,
	s_in_1_sig_at_t = s_in_1_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = s_in_1_sig_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = s_in_1_sig_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_13 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	s_in_2_sig_at_t = s_in_2_sig@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_14 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data3_at_t = data3@t,
	s_in_2_sig_at_t = s_in_2_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = s_in_2_sig_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = s_in_2_sig_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


property state_1_15 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = s_in_3_sig_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = s_in_3_sig_at_t;
end property;


property state_1_16 is
dependencies: no_reset;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t+1: state_1;
	at t+1: data1 = data1_at_t;
	at t+1: data2 = data2_at_t;
	at t+1: data3 = data3_at_t;
	at t+1: s_out_1_sig = data1_at_t;
	at t+1: s_out_2_sig = data2_at_t;
	at t+1: s_out_3_sig = data3_at_t;
end property;


