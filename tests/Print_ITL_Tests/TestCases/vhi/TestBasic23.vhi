-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro b_out_sync : boolean := end macro;
macro b_out2_sync : boolean := end macro;
macro b_out_notify : boolean := end macro;
macro b_out2_notify : boolean := end macro;


-- DP SIGNALS --
macro b_out_sig : unsigned := end macro;
macro b_out2_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro phase : Phases := end macro;
macro val_signed : signed := end macro;
macro val_unsigned : unsigned := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;
macro state_6 : boolean := true end macro;
macro state_7 : boolean := true end macro;
macro state_8 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: b_out_sig = resize(3,32);
	 at t: phase = SECTION_A;
	 at t: val_signed = resize(-7,32);
	 at t: val_unsigned = resize(13,32);
	 at t: b_out_notify = true;
	 at t: b_out2_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_1;
	at t: b_out_sync;
prove:
	at t_end: state_2;
	at t_end: b_out_sig = (shift_left(val_unsigned_at_t,2));
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_2;
	at t: b_out_sync;
prove:
	at t_end: state_3;
	at t_end: b_out_sig = (val_unsigned_at_t and 2);
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_3_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_3;
	at t: b_out_sync;
prove:
	at t_end: state_4;
	at t_end: b_out_sig = (val_unsigned_at_t or 2);
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_4_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	at t: ((shift_left(val_unsigned,resize(2,32))) = resize(0,32));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: ((shift_left(val_unsigned,resize(2,32))) = resize(0,32));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_4_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: b_out_sync;
	at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	at t: not((phase = SECTION_B));
	at t: not((SECTION_B = SECTION_A));
	at t: (SECTION_B = SECTION_B);
prove:
	at t_end: state_5;
	at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	at t_end: phase = SECTION_B;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_5_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_5;
	at t: b_out2_sync;
prove:
	at t_end: state_6;
	at t_end: b_out2_sig = (shift_left(val_signed_at_t,2));
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_6_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_6;
	at t: b_out2_sync;
prove:
	at t_end: state_7;
	at t_end: b_out2_sig = (val_signed_at_t and 2);
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_7_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_7;
	at t: b_out2_sync;
prove:
	at t_end: state_8;
	at t_end: b_out2_sig = (val_signed_at_t or 2);
	at t_end: phase = phase_at_t;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end]: b_out_notify = false;
	during[t+1, t_end-1]: b_out2_notify = false;
	at t_end: b_out2_notify = true;
end property;


property state_8_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_signed and resize(2,32)) = resize(0,32));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	at t: ((shift_left(val_signed,resize(2,32))) = resize(0,32));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_signed and resize(2,32)) = resize(0,32));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	at t: ((shift_left(val_signed,resize(2,32))) = resize(0,32));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: ((val_signed and resize(2,32)) = resize(0,32));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: ((val_signed and resize(2,32)) = resize(0,32));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: ((val_signed and resize(2,32)) = resize(0,32));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property state_8_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: b_out2_sync;
	at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	at t: (SECTION_A = SECTION_A);
prove:
	at t_end: state_1;
	at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	at t_end: phase = SECTION_A;
	at t_end: val_signed = val_signed_at_t;
	at t_end: val_unsigned = val_unsigned_at_t;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
	during[t+1, t_end]: b_out2_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_1;
	at t: not(b_out_sync);
prove:
	at t+1: state_1;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = true;
	at t+1: b_out2_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_2;
	at t: not(b_out_sync);
prove:
	at t+1: state_2;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = true;
	at t+1: b_out2_notify = false;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_3;
	at t: not(b_out_sync);
prove:
	at t+1: state_3;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = true;
	at t+1: b_out2_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_4;
	at t: not(b_out_sync);
prove:
	at t+1: state_4;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = true;
	at t+1: b_out2_notify = false;
end property;


property wait_state_5 is
dependencies: no_reset;
freeze:
	b_out2_sig_at_t = b_out2_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_5;
	at t: not(b_out2_sync);
prove:
	at t+1: state_5;
	at t+1: b_out2_sig = b_out2_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = false;
	at t+1: b_out2_notify = true;
end property;


property wait_state_6 is
dependencies: no_reset;
freeze:
	b_out2_sig_at_t = b_out2_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_6;
	at t: not(b_out2_sync);
prove:
	at t+1: state_6;
	at t+1: b_out2_sig = b_out2_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = false;
	at t+1: b_out2_notify = true;
end property;


property wait_state_7 is
dependencies: no_reset;
freeze:
	b_out2_sig_at_t = b_out2_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_7;
	at t: not(b_out2_sync);
prove:
	at t+1: state_7;
	at t+1: b_out2_sig = b_out2_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = false;
	at t+1: b_out2_notify = true;
end property;


property wait_state_8 is
dependencies: no_reset;
freeze:
	b_out2_sig_at_t = b_out2_sig@t,
	phase_at_t = phase@t,
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume:
	at t: state_8;
	at t: not(b_out2_sync);
prove:
	at t+1: state_8;
	at t+1: b_out2_sig = b_out2_sig_at_t;
	at t+1: phase = phase_at_t;
	at t+1: val_signed = val_signed_at_t;
	at t+1: val_unsigned = val_unsigned_at_t;
	at t+1: b_out_notify = false;
	at t+1: b_out2_notify = true;
end property;


