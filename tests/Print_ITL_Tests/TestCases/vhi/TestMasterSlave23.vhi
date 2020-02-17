-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro s_in_1_sync : boolean := end macro;
macro s_in_2_sync : boolean := end macro;
macro s_in_3_sync : boolean := end macro;


-- DP SIGNALS --
macro s_in_1_sig : signed := end macro;
macro s_in_2_sig : signed := end macro;
macro s_in_3_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro data3 : signed := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: data3 = resize(0,32);
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_1_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_1_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_1_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = data3_at_t;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = data3_at_t;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = data3_at_t;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
	at t: (s_in_3_sig >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_1;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
	at t: (data3 >= resize(6,32));
prove:
	at t_end: state_2;
	at t_end: data3 = data3_at_t;
end property;


property state_1_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_1;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
	at t: (s_in_3_sig <= resize(5,32));
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: s_in_3_sync;
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_2_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_2_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_2_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_2;
	at t: s_in_1_sync;
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_2_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: s_in_3_sync;
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_2_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: s_in_2_sync;
	at t: not(s_in_3_sync);
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


property state_2_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	s_in_3_sig_at_t = s_in_3_sig@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: s_in_3_sync;
prove:
	at t_end: state_1;
	at t_end: data3 = s_in_3_sig_at_t;
end property;


property state_2_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data3_at_t = data3@t;
assume:
	at t: state_2;
	at t: not(s_in_1_sync);
	at t: not(s_in_2_sync);
	at t: not(s_in_3_sync);
prove:
	at t_end: state_1;
	at t_end: data3 = data3_at_t;
end property;


