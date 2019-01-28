-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 
macro b_out2_notify :  boolean  := end macro; 
macro b_out2_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_out_sig : unsigned := end macro; 
macro b_out2_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro val_signed : int := end macro; 
macro val_unsigned : unsigned := end macro; 


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_A_1 : boolean := true end macro;
macro SECTION_A_2 : boolean := true end macro;
macro SECTION_A_3 : boolean := true end macro;
macro SECTION_B_4 : boolean := true end macro;
macro SECTION_B_5 : boolean := true end macro;
macro SECTION_B_6 : boolean := true end macro;
macro SECTION_B_7 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: b_out_sig = resize(3,32);
	 at t: val_signed = resize(-7,32);
	 at t: val_unsigned = resize(13,32);
	 at t: b_out_notify = true;
	 at t: b_out2_notify = false;
end property;


property SECTION_A_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_0;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_1;
	 at t_end: b_out_sig = (shift_left(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_A_1_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_1;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_2;
	 at t_end: b_out_sig = (val_unsigned_at_t and 2);
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_A_2_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_2;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_3;
	 at t_end: b_out_sig = (val_unsigned_at_t or 2);
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_A_3_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: not(((val_unsigned and resize(2,32)) = resize(0,32)));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: not(((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_unsigned,resize(2,32))) = resize(0,32)));
	 at t: ((shift_left(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_A_3_write_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: ((val_unsigned mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_unsigned and resize(2,32)) = resize(0,32));
	 at t: not(((val_unsigned or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: ((shift_left(val_unsigned,resize(2,32))) = resize(0,32));
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_B_4;
	 at t_end: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_B_4_write_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_4;
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_B_5;
	 at t_end: b_out2_sig = (shift_left(val_signed_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_B_5_write_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_5;
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_B_6;
	 at t_end: b_out2_sig = (val_signed_at_t and 2);
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_B_6_write_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_6;
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_B_7;
	 at t_end: b_out2_sig = (val_signed_at_t or 2);
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end]: b_out_notify = false;
	 during[t+1, t_end-1]: b_out2_notify = false;
	 at t_end: b_out2_notify = true;
end property;

property SECTION_B_7_write_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: ((val_signed and resize(2,32)) = resize(0,32));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_signed and resize(2,32)) = resize(0,32));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: not(((val_signed and resize(2,32)) = resize(0,32)));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: not(((val_signed mod resize(2,32))(31 downto 0) = resize(0,32)));
	 at t: ((val_signed and resize(2,32)) = resize(0,32));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	 at t: not(((shift_left(val_signed,resize(2,32))) = resize(0,32)));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_signed and resize(2,32)) = resize(0,32));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: not(((shift_right(val_signed,resize(2,32))) = resize(0,32)));
	 at t: ((shift_left(val_signed,resize(2,32))) = resize(0,32));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property SECTION_B_7_write_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: ((val_signed mod resize(2,32))(31 downto 0) = resize(0,32));
	 at t: ((val_signed and resize(2,32)) = resize(0,32));
	 at t: not(((val_signed or resize(2,32)) = resize(0,32)));
	 at t: ((shift_right(val_signed,resize(2,32))) = resize(0,32));
	 at t: ((shift_left(val_signed,resize(2,32))) = resize(0,32));
	 at t: b_out2_sync;
prove:
	 at t_end: SECTION_A_0;
	 at t_end: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t_end: val_signed = val_signed_at_t;
	 at t_end: val_unsigned = val_unsigned_at_t;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
	 during[t+1, t_end]: b_out2_notify = false;
end property;

property wait_SECTION_A_0 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(b_out_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: b_out_sig = (shift_right(val_unsigned_at_t,2));
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = true;
	 at t+1: b_out2_notify = false;
end property;

property wait_SECTION_A_1 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_1;
	 at t: not(b_out_sync);
prove:
	 at t+1: SECTION_A_1;
	 at t+1: b_out_sig = (shift_left(val_unsigned_at_t,2));
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = true;
	 at t+1: b_out2_notify = false;
end property;

property wait_SECTION_A_2 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_2;
	 at t: not(b_out_sync);
prove:
	 at t+1: SECTION_A_2;
	 at t+1: b_out_sig = (val_unsigned_at_t and 2);
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = true;
	 at t+1: b_out2_notify = false;
end property;

property wait_SECTION_A_3 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_A_3;
	 at t: not(b_out_sync);
prove:
	 at t+1: SECTION_A_3;
	 at t+1: b_out_sig = (val_unsigned_at_t or 2);
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = true;
	 at t+1: b_out2_notify = false;
end property;

property wait_SECTION_B_4 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_4;
	 at t: not(b_out2_sync);
prove:
	 at t+1: SECTION_B_4;
	 at t+1: b_out2_sig = (shift_right(val_signed_at_t,2));
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = false;
	 at t+1: b_out2_notify = true;
end property;

property wait_SECTION_B_5 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_5;
	 at t: not(b_out2_sync);
prove:
	 at t+1: SECTION_B_5;
	 at t+1: b_out2_sig = (shift_left(val_signed_at_t,2));
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = false;
	 at t+1: b_out2_notify = true;
end property;

property wait_SECTION_B_6 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_6;
	 at t: not(b_out2_sync);
prove:
	 at t+1: SECTION_B_6;
	 at t+1: b_out2_sig = (val_signed_at_t and 2);
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = false;
	 at t+1: b_out2_notify = true;
end property;

property wait_SECTION_B_7 is
dependencies: no_reset;
freeze:
	val_signed_at_t = val_signed@t,
	val_unsigned_at_t = val_unsigned@t;
assume: 
	 at t: SECTION_B_7;
	 at t: not(b_out2_sync);
prove:
	 at t+1: SECTION_B_7;
	 at t+1: b_out2_sig = (val_signed_at_t or 2);
	 at t+1: val_signed = val_signed_at_t;
	 at t+1: val_unsigned = val_unsigned_at_t;
	 at t+1: b_out_notify = false;
	 at t+1: b_out2_notify = true;
end property;