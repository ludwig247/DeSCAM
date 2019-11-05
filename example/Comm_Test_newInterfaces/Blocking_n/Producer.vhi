-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_1_sync : boolean := end macro;
macro out_2_sync : boolean := end macro;
macro out_3_sync : boolean := end macro;
macro out_4_sync : boolean := end macro;
macro out_1_notify : boolean := end macro;
macro out_2_notify : boolean := end macro;
macro out_3_notify : boolean := end macro;
macro out_4_notify : boolean := end macro;


-- DP SIGNALS --
macro out_1_sig : signed := end macro;
macro out_2_sig : signed := end macro;
macro out_3_sig : signed := end macro;
macro out_4_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro cnt : signed := end macro;
macro out_1_data : signed := end macro;
macro out_2_data : signed := end macro;
macro out_3_data : signed := end macro;
macro out_4_data : signed := end macro;


-- STATES --
macro state_12 : boolean := true end macro;
macro state_15 : boolean := true end macro;
macro state_18 : boolean := true end macro;
macro state_21 : boolean := true end macro;
macro state_28 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_12;
	 at t: cnt = resize(0,32);
	 at t: out_1_data = resize(1,32);
	 at t: out_1_sig = resize(1,32);
	 at t: out_2_data = resize(1,32);
	 at t: out_3_data = resize(1,32);
	 at t: out_4_data = resize(1,32);
	 at t: out_1_notify = true;
	 at t: out_2_notify = false;
	 at t: out_3_notify = false;
	 at t: out_4_notify = false;
end property;


property state_12_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_12;
	at t: out_1_sync;
prove:
	at t_end: state_15;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = (1 + out_1_data_at_t)(31 downto 0);
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_2_sig = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end-1]: out_2_notify = false;
	at t_end: out_2_notify = true;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_12_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_12;
	at t: not(out_1_sync);
prove:
	at t_end: state_15;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_2_sig = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end-1]: out_2_notify = false;
	at t_end: out_2_notify = true;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_15_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_15;
	at t: out_2_sync;
prove:
	at t_end: state_18;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = (1 + out_2_data_at_t)(31 downto 0);
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_3_sig = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end-1]: out_3_notify = false;
	at t_end: out_3_notify = true;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_15_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_15;
	at t: not(out_2_sync);
prove:
	at t_end: state_18;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_3_sig = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end-1]: out_3_notify = false;
	at t_end: out_3_notify = true;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_18_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_18;
	at t: out_3_sync;
prove:
	at t_end: state_21;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = (1 + out_3_data_at_t)(31 downto 0);
	at t_end: out_4_data = out_4_data_at_t;
	at t_end: out_4_sig = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end-1]: out_4_notify = false;
	at t_end: out_4_notify = true;
end property;


property state_18_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_18;
	at t: not(out_3_sync);
prove:
	at t_end: state_21;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	at t_end: out_4_sig = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end-1]: out_4_notify = false;
	at t_end: out_4_notify = true;
end property;


property state_21_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_21;
	at t: out_4_sync;
	at t: (out_1_data >= resize(10000001,32));
	at t: (out_2_data >= resize(10000001,32));
	at t: (out_3_data >= resize(10000001,32));
	at t: (out_4_data >= resize(10000000,32));
prove:
	at t_end: state_28;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = (1 + out_4_data_at_t)(31 downto 0);
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_21_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_21;
	at t: out_4_sync;
	at t: not((((not((out_1_data <= resize(10000000,32))) and not((out_2_data <= resize(10000000,32)))) and not((out_3_data <= resize(10000000,32)))) and not((out_4_data <= resize(9999999,32)))));
prove:
	at t_end: state_12;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_1_sig = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = (1 + out_4_data_at_t)(31 downto 0);
	during[t+1, t_end-1]: out_1_notify = false;
	at t_end: out_1_notify = true;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_21_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_21;
	at t: not(out_4_sync);
	at t: (out_1_data >= resize(10000001,32));
	at t: (out_2_data >= resize(10000001,32));
	at t: (out_3_data >= resize(10000001,32));
	at t: (out_4_data >= resize(10000001,32));
prove:
	at t_end: state_28;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end]: out_1_notify = false;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_21_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_21;
	at t: not(out_4_sync);
	at t: not((((not((out_1_data <= resize(10000000,32))) and not((out_2_data <= resize(10000000,32)))) and not((out_3_data <= resize(10000000,32)))) and not((out_4_data <= resize(10000000,32)))));
prove:
	at t_end: state_12;
	at t_end: cnt = (1 + cnt_at_t)(31 downto 0);
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_1_sig = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end-1]: out_1_notify = false;
	at t_end: out_1_notify = true;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


property state_28_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	out_1_data_at_t = out_1_data@t,
	out_2_data_at_t = out_2_data@t,
	out_3_data_at_t = out_3_data@t,
	out_4_data_at_t = out_4_data@t;
assume:
	at t: state_28;
prove:
	at t_end: state_12;
	at t_end: cnt = cnt_at_t;
	at t_end: out_1_data = out_1_data_at_t;
	at t_end: out_1_sig = out_1_data_at_t;
	at t_end: out_2_data = out_2_data_at_t;
	at t_end: out_3_data = out_3_data_at_t;
	at t_end: out_4_data = out_4_data_at_t;
	during[t+1, t_end-1]: out_1_notify = false;
	at t_end: out_1_notify = true;
	during[t+1, t_end]: out_2_notify = false;
	during[t+1, t_end]: out_3_notify = false;
	during[t+1, t_end]: out_4_notify = false;
end property;


