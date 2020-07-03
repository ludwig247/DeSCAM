-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --


-- DP SIGNALS --
macro s_out_1_sig : signed :=resize(0,32) end macro;
macro s_out_2_sig : signed :=resize(0,32) end macro;
macro s_out_3_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro data1 : signed :=resize(0,32) end macro;
macro data2 : signed :=resize(0,32) end macro;
macro data3 : signed :=resize(0,32) end macro;


-- STATES --
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


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data1_at_t = data1@t,
	data2_at_t = data2@t,
	data3_at_t = data3@t;
assume:
	at t: state_1;
prove:
	at t_end: state_1;
	at t_end: data1 = data1_at_t;
	at t_end: data2 = data2_at_t;
	at t_end: data3 = data3_at_t;
	at t_end: s_out_1_sig = data1_at_t;
	at t_end: s_out_2_sig = data2_at_t;
	at t_end: s_out_3_sig = data3_at_t;
end property;


