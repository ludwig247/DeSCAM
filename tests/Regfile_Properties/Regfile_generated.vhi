-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out0_sync : boolean := true end macro;
macro out1_sync : boolean := true end macro;
macro out10_sync : boolean := true end macro;
macro out11_sync : boolean := true end macro;
macro out12_sync : boolean := true end macro;
macro out13_sync : boolean := true end macro;
macro out14_sync : boolean := true end macro;
macro out15_sync : boolean := true end macro;
macro out16_sync : boolean := true end macro;
macro out17_sync : boolean := true end macro;
macro out18_sync : boolean := true end macro;
macro out19_sync : boolean := true end macro;
macro out2_sync : boolean := true end macro;
macro out20_sync : boolean := true end macro;
macro out21_sync : boolean := true end macro;
macro out22_sync : boolean := true end macro;
macro out23_sync : boolean := true end macro;
macro out24_sync : boolean := true end macro;
macro out25_sync : boolean := true end macro;
macro out26_sync : boolean := true end macro;
macro out27_sync : boolean := true end macro;
macro out28_sync : boolean := true end macro;
macro out29_sync : boolean := true end macro;
macro out3_sync : boolean := true end macro;
macro out30_sync : boolean := true end macro;
macro out31_sync : boolean := true end macro;
macro out4_sync : boolean := true end macro;
macro out5_sync : boolean := true end macro;
macro out6_sync : boolean := true end macro;
macro out7_sync : boolean := true end macro;
macro out8_sync : boolean := true end macro;
macro out9_sync : boolean := true end macro;
macro val_sync : boolean := Control_sync end macro;
macro out0_notify : boolean := true end  macro;
macro out1_notify : boolean := true end  macro;
macro out10_notify : boolean := true end  macro;
macro out11_notify : boolean := true end  macro;
macro out12_notify : boolean := true end  macro;
macro out13_notify : boolean := true end  macro;
macro out14_notify : boolean := true end  macro;
macro out15_notify : boolean := true end  macro;
macro out16_notify : boolean := true end  macro;
macro out17_notify : boolean := true end  macro;
macro out18_notify : boolean := true end  macro;
macro out19_notify : boolean := true end  macro;
macro out2_notify : boolean := true end  macro;
macro out20_notify : boolean := true end  macro;
macro out21_notify : boolean := true end  macro;
macro out22_notify : boolean := true end  macro;
macro out23_notify : boolean := true end  macro;
macro out24_notify : boolean := true end  macro;
macro out25_notify : boolean := true end  macro;
macro out26_notify : boolean := true end  macro;
macro out27_notify : boolean := true end  macro;
macro out28_notify : boolean := true end  macro;
macro out29_notify : boolean := true end  macro;
macro out3_notify : boolean := true end  macro;
macro out30_notify : boolean := true end  macro;
macro out31_notify : boolean := true end  macro;
macro out4_notify : boolean := true end  macro;
macro out5_notify : boolean := true end  macro;
macro out6_notify : boolean := true end  macro;
macro out7_notify : boolean := true end  macro;
macro out8_notify : boolean := true end  macro;
macro out9_notify : boolean := true end  macro;
macro val_notify : boolean := Control_notify end  macro;


-- DP SIGNALS --
macro out0_sig : signed := Regs_to_Control(0) end macro;
macro out1_sig : signed :=Regs_to_Control(1) end macro;
macro out10_sig : signed :=Regs_to_Control(10) end macro;
macro out11_sig : signed :=Regs_to_Control(11) end macro;
macro out12_sig : signed :=Regs_to_Control(12) end macro;
macro out13_sig : signed :=Regs_to_Control(13) end macro;
macro out14_sig : signed :=Regs_to_Control(14) end macro;
macro out15_sig : signed :=Regs_to_Control(15) end macro;
macro out16_sig : signed :=Regs_to_Control(16) end macro;
macro out17_sig : signed :=Regs_to_Control(17) end macro;
macro out18_sig : signed :=Regs_to_Control(18) end macro;
macro out19_sig : signed :=Regs_to_Control(19) end macro;
macro out2_sig : signed :=Regs_to_Control(2) end macro;
macro out20_sig : signed :=Regs_to_Control(20) end macro;
macro out21_sig : signed :=Regs_to_Control(21) end macro;
macro out22_sig : signed :=Regs_to_Control(22) end macro;
macro out23_sig : signed :=Regs_to_Control(23) end macro;
macro out24_sig : signed :=Regs_to_Control(24) end macro;
macro out25_sig : signed :=Regs_to_Control(25) end macro;
macro out26_sig : signed :=Regs_to_Control(26) end macro;
macro out27_sig : signed :=Regs_to_Control(27) end macro;
macro out28_sig : signed :=Regs_to_Control(28) end macro;
macro out29_sig : signed :=Regs_to_Control(29) end macro;
macro out3_sig : signed :=Regs_to_Control(3) end macro;
macro out30_sig : signed :=Regs_to_Control(30) end macro;
macro out31_sig : signed :=Regs_to_Control(31) end macro;
macro out4_sig : signed :=Regs_to_Control(4) end macro;
macro out5_sig : signed :=Regs_to_Control(5) end macro;
macro out6_sig : signed :=Regs_to_Control(6) end macro;
macro out7_sig : signed :=Regs_to_Control(7) end macro;
macro out8_sig : signed :=Regs_to_Control(8) end macro;
macro out9_sig : signed :=Regs_to_Control(9) end macro;
macro val_sig : signed :=Control_to_Regs_data end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro address : unsigned := Control_to_Regs_address end macro;
macro regs : int_array :=Regs_to_Control end macro;


-- STATES --
macro start_state : boolean := address < 32 end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: regs(0) = resize(0,32);
	 at t: regs(10) = resize(0,32);
	 at t: regs(11) = resize(0,32);
	 at t: regs(12) = resize(0,32);
	 at t: regs(13) = resize(0,32);
	 at t: regs(14) = resize(0,32);
	 at t: regs(15) = resize(0,32);
	 at t: regs(16) = resize(0,32);
	 at t: regs(17) = resize(0,32);
	 at t: regs(18) = resize(0,32);
	 at t: regs(19) = resize(0,32);
	 at t: regs(1) = resize(0,32);
	 at t: regs(20) = resize(0,32);
	 at t: regs(21) = resize(0,32);
	 at t: regs(22) = resize(0,32);
	 at t: regs(23) = resize(0,32);
	 at t: regs(24) = resize(0,32);
	 at t: regs(25) = resize(0,32);
	 at t: regs(26) = resize(0,32);
	 at t: regs(27) = resize(0,32);
	 at t: regs(28) = resize(0,32);
	 at t: regs(29) = resize(0,32);
	 at t: regs(2) = resize(0,32);
	 at t: regs(30) = resize(0,32);
	 at t: regs(31) = resize(0,32);
	 at t: regs(3) = resize(0,32);
	 at t: regs(4) = resize(0,32);
	 at t: regs(5) = resize(0,32);
	 at t: regs(6) = resize(0,32);
	 at t: regs(7) = resize(0,32);
	 at t: regs(8) = resize(0,32);
	 at t: regs(9) = resize(0,32);
	 at t: val_notify = false;
end property;


property start_state_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	address_at_t = address@t,
	regs_0_at_t = regs(0)@t,
	regs_1_at_t = regs(1)@t,
	regs_10_at_t = regs(10)@t,
	regs_11_at_t = regs(11)@t,
	regs_12_at_t = regs(12)@t,
	regs_13_at_t = regs(13)@t,
	regs_14_at_t = regs(14)@t,
	regs_15_at_t = regs(15)@t,
	regs_16_at_t = regs(16)@t,
	regs_17_at_t = regs(17)@t,
	regs_18_at_t = regs(18)@t,
	regs_19_at_t = regs(19)@t,
	regs_2_at_t = regs(2)@t,
	regs_20_at_t = regs(20)@t,
	regs_21_at_t = regs(21)@t,
	regs_22_at_t = regs(22)@t,
	regs_23_at_t = regs(23)@t,
	regs_24_at_t = regs(24)@t,
	regs_25_at_t = regs(25)@t,
	regs_26_at_t = regs(26)@t,
	regs_27_at_t = regs(27)@t,
	regs_28_at_t = regs(28)@t,
	regs_29_at_t = regs(29)@t,
	regs_3_at_t = regs(3)@t,
	regs_30_at_t = regs(30)@t,
	regs_31_at_t = regs(31)@t,
	regs_4_at_t = regs(4)@t,
	regs_5_at_t = regs(5)@t,
	regs_6_at_t = regs(6)@t,
	regs_7_at_t = regs(7)@t,
	regs_8_at_t = regs(8)@t,
	regs_9_at_t = regs(9)@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: start_state;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: regs(0) = (((address_at_t = 0))?val_sig_at_t:regs_0_at_t);
	at t_end: regs(10) = (((address_at_t = 10))?val_sig_at_t:regs_10_at_t);
	at t_end: regs(11) = (((address_at_t = 11))?val_sig_at_t:regs_11_at_t);
	at t_end: regs(12) = (((address_at_t = 12))?val_sig_at_t:regs_12_at_t);
	at t_end: regs(13) = (((address_at_t = 13))?val_sig_at_t:regs_13_at_t);
	at t_end: regs(14) = (((address_at_t = 14))?val_sig_at_t:regs_14_at_t);
	at t_end: regs(15) = (((address_at_t = 15))?val_sig_at_t:regs_15_at_t);
	at t_end: regs(16) = (((address_at_t = 16))?val_sig_at_t:regs_16_at_t);
	at t_end: regs(17) = (((address_at_t = 17))?val_sig_at_t:regs_17_at_t);
	at t_end: regs(18) = (((address_at_t = 18))?val_sig_at_t:regs_18_at_t);
	at t_end: regs(19) = (((address_at_t = 19))?val_sig_at_t:regs_19_at_t);
	at t_end: regs(1) = (((address_at_t = 1))?val_sig_at_t:regs_1_at_t);
	at t_end: regs(20) = (((address_at_t = 20))?val_sig_at_t:regs_20_at_t);
	at t_end: regs(21) = (((address_at_t = 21))?val_sig_at_t:regs_21_at_t);
	at t_end: regs(22) = (((address_at_t = 22))?val_sig_at_t:regs_22_at_t);
	at t_end: regs(23) = (((address_at_t = 23))?val_sig_at_t:regs_23_at_t);
	at t_end: regs(24) = (((address_at_t = 24))?val_sig_at_t:regs_24_at_t);
	at t_end: regs(25) = (((address_at_t = 25))?val_sig_at_t:regs_25_at_t);
	at t_end: regs(26) = (((address_at_t = 26))?val_sig_at_t:regs_26_at_t);
	at t_end: regs(27) = (((address_at_t = 27))?val_sig_at_t:regs_27_at_t);
	at t_end: regs(28) = (((address_at_t = 28))?val_sig_at_t:regs_28_at_t);
	at t_end: regs(29) = (((address_at_t = 29))?val_sig_at_t:regs_29_at_t);
	at t_end: regs(2) = (((address_at_t = 2))?val_sig_at_t:regs_2_at_t);
	at t_end: regs(30) = (((address_at_t = 30))?val_sig_at_t:regs_30_at_t);
	at t_end: regs(31) = (((address_at_t = 31))?val_sig_at_t:regs_31_at_t);
	at t_end: regs(3) = (((address_at_t = 3))?val_sig_at_t:regs_3_at_t);
	at t_end: regs(4) = (((address_at_t = 4))?val_sig_at_t:regs_4_at_t);
	at t_end: regs(5) = (((address_at_t = 5))?val_sig_at_t:regs_5_at_t);
	at t_end: regs(6) = (((address_at_t = 6))?val_sig_at_t:regs_6_at_t);
	at t_end: regs(7) = (((address_at_t = 7))?val_sig_at_t:regs_7_at_t);
	at t_end: regs(8) = (((address_at_t = 8))?val_sig_at_t:regs_8_at_t);
	at t_end: regs(9) = (((address_at_t = 9))?val_sig_at_t:regs_9_at_t);
	at t_end: val_notify = true;
end property;


property start_state_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	regs_0_at_t = regs(0)@t,
	regs_1_at_t = regs(1)@t,
	regs_10_at_t = regs(10)@t,
	regs_11_at_t = regs(11)@t,
	regs_12_at_t = regs(12)@t,
	regs_13_at_t = regs(13)@t,
	regs_14_at_t = regs(14)@t,
	regs_15_at_t = regs(15)@t,
	regs_16_at_t = regs(16)@t,
	regs_17_at_t = regs(17)@t,
	regs_18_at_t = regs(18)@t,
	regs_19_at_t = regs(19)@t,
	regs_2_at_t = regs(2)@t,
	regs_20_at_t = regs(20)@t,
	regs_21_at_t = regs(21)@t,
	regs_22_at_t = regs(22)@t,
	regs_23_at_t = regs(23)@t,
	regs_24_at_t = regs(24)@t,
	regs_25_at_t = regs(25)@t,
	regs_26_at_t = regs(26)@t,
	regs_27_at_t = regs(27)@t,
	regs_28_at_t = regs(28)@t,
	regs_29_at_t = regs(29)@t,
	regs_3_at_t = regs(3)@t,
	regs_30_at_t = regs(30)@t,
	regs_31_at_t = regs(31)@t,
	regs_4_at_t = regs(4)@t,
	regs_5_at_t = regs(5)@t,
	regs_6_at_t = regs(6)@t,
	regs_7_at_t = regs(7)@t,
	regs_8_at_t = regs(8)@t,
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: regs(0) = regs_0_at_t;
	at t_end: regs(10) = regs_10_at_t;
	at t_end: regs(11) = regs_11_at_t;
	at t_end: regs(12) = regs_12_at_t;
	at t_end: regs(13) = regs_13_at_t;
	at t_end: regs(14) = regs_14_at_t;
	at t_end: regs(15) = regs_15_at_t;
	at t_end: regs(16) = regs_16_at_t;
	at t_end: regs(17) = regs_17_at_t;
	at t_end: regs(18) = regs_18_at_t;
	at t_end: regs(19) = regs_19_at_t;
	at t_end: regs(1) = regs_1_at_t;
	at t_end: regs(20) = regs_20_at_t;
	at t_end: regs(21) = regs_21_at_t;
	at t_end: regs(22) = regs_22_at_t;
	at t_end: regs(23) = regs_23_at_t;
	at t_end: regs(24) = regs_24_at_t;
	at t_end: regs(25) = regs_25_at_t;
	at t_end: regs(26) = regs_26_at_t;
	at t_end: regs(27) = regs_27_at_t;
	at t_end: regs(28) = regs_28_at_t;
	at t_end: regs(29) = regs_29_at_t;
	at t_end: regs(2) = regs_2_at_t;
	at t_end: regs(30) = regs_30_at_t;
	at t_end: regs(31) = regs_31_at_t;
	at t_end: regs(3) = regs_3_at_t;
	at t_end: regs(4) = regs_4_at_t;
	at t_end: regs(5) = regs_5_at_t;
	at t_end: regs(6) = regs_6_at_t;
	at t_end: regs(7) = regs_7_at_t;
	at t_end: regs(8) = regs_8_at_t;
	at t_end: regs(9) = regs_9_at_t;
	at t_end: val_notify = false;
end property;


property start_state_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	regs_0_at_t = regs(0)@t,
	regs_1_at_t = regs(1)@t,
	regs_10_at_t = regs(10)@t,
	regs_11_at_t = regs(11)@t,
	regs_12_at_t = regs(12)@t,
	regs_13_at_t = regs(13)@t,
	regs_14_at_t = regs(14)@t,
	regs_15_at_t = regs(15)@t,
	regs_16_at_t = regs(16)@t,
	regs_17_at_t = regs(17)@t,
	regs_18_at_t = regs(18)@t,
	regs_19_at_t = regs(19)@t,
	regs_2_at_t = regs(2)@t,
	regs_20_at_t = regs(20)@t,
	regs_21_at_t = regs(21)@t,
	regs_22_at_t = regs(22)@t,
	regs_23_at_t = regs(23)@t,
	regs_24_at_t = regs(24)@t,
	regs_25_at_t = regs(25)@t,
	regs_26_at_t = regs(26)@t,
	regs_27_at_t = regs(27)@t,
	regs_28_at_t = regs(28)@t,
	regs_29_at_t = regs(29)@t,
	regs_3_at_t = regs(3)@t,
	regs_30_at_t = regs(30)@t,
	regs_31_at_t = regs(31)@t,
	regs_4_at_t = regs(4)@t,
	regs_5_at_t = regs(5)@t,
	regs_6_at_t = regs(6)@t,
	regs_7_at_t = regs(7)@t,
	regs_8_at_t = regs(8)@t,
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: out0_sig = regs_0_at_t;
	at t_end: out10_sig = regs_10_at_t;
	at t_end: out11_sig = regs_11_at_t;
	at t_end: out12_sig = regs_12_at_t;
	at t_end: out13_sig = regs_13_at_t;
	at t_end: out14_sig = regs_14_at_t;
	at t_end: out15_sig = regs_15_at_t;
	at t_end: out16_sig = regs_16_at_t;
	at t_end: out17_sig = regs_17_at_t;
	at t_end: out18_sig = regs_18_at_t;
	at t_end: out19_sig = regs_19_at_t;
	at t_end: out1_sig = regs_1_at_t;
	at t_end: out20_sig = regs_20_at_t;
	at t_end: out21_sig = regs_21_at_t;
	at t_end: out22_sig = regs_22_at_t;
	at t_end: out23_sig = regs_23_at_t;
	at t_end: out24_sig = regs_24_at_t;
	at t_end: out25_sig = regs_25_at_t;
	at t_end: out26_sig = regs_26_at_t;
	at t_end: out27_sig = regs_27_at_t;
	at t_end: out28_sig = regs_28_at_t;
	at t_end: out29_sig = regs_29_at_t;
	at t_end: out2_sig = regs_2_at_t;
	at t_end: out30_sig = regs_30_at_t;
	at t_end: out31_sig = regs_31_at_t;
	at t_end: out3_sig = regs_3_at_t;
	at t_end: out4_sig = regs_4_at_t;
	at t_end: out5_sig = regs_5_at_t;
	at t_end: out6_sig = regs_6_at_t;
	at t_end: out7_sig = regs_7_at_t;
	at t_end: out8_sig = regs_8_at_t;
	at t_end: out9_sig = regs_9_at_t;
	at t_end: regs(0) = regs_0_at_t;
	at t_end: regs(10) = regs_10_at_t;
	at t_end: regs(11) = regs_11_at_t;
	at t_end: regs(12) = regs_12_at_t;
	at t_end: regs(13) = regs_13_at_t;
	at t_end: regs(14) = regs_14_at_t;
	at t_end: regs(15) = regs_15_at_t;
	at t_end: regs(16) = regs_16_at_t;
	at t_end: regs(17) = regs_17_at_t;
	at t_end: regs(18) = regs_18_at_t;
	at t_end: regs(19) = regs_19_at_t;
	at t_end: regs(1) = regs_1_at_t;
	at t_end: regs(20) = regs_20_at_t;
	at t_end: regs(21) = regs_21_at_t;
	at t_end: regs(22) = regs_22_at_t;
	at t_end: regs(23) = regs_23_at_t;
	at t_end: regs(24) = regs_24_at_t;
	at t_end: regs(25) = regs_25_at_t;
	at t_end: regs(26) = regs_26_at_t;
	at t_end: regs(27) = regs_27_at_t;
	at t_end: regs(28) = regs_28_at_t;
	at t_end: regs(29) = regs_29_at_t;
	at t_end: regs(2) = regs_2_at_t;
	at t_end: regs(30) = regs_30_at_t;
	at t_end: regs(31) = regs_31_at_t;
	at t_end: regs(3) = regs_3_at_t;
	at t_end: regs(4) = regs_4_at_t;
	at t_end: regs(5) = regs_5_at_t;
	at t_end: regs(6) = regs_6_at_t;
	at t_end: regs(7) = regs_7_at_t;
	at t_end: regs(8) = regs_8_at_t;
	at t_end: regs(9) = regs_9_at_t;
	at t_end: val_notify = false;
end property;


property start_state_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	address_at_t = address@t,
	regs_0_at_t = regs(0)@t,
	regs_1_at_t = regs(1)@t,
	regs_10_at_t = regs(10)@t,
	regs_11_at_t = regs(11)@t,
	regs_12_at_t = regs(12)@t,
	regs_13_at_t = regs(13)@t,
	regs_14_at_t = regs(14)@t,
	regs_15_at_t = regs(15)@t,
	regs_16_at_t = regs(16)@t,
	regs_17_at_t = regs(17)@t,
	regs_18_at_t = regs(18)@t,
	regs_19_at_t = regs(19)@t,
	regs_2_at_t = regs(2)@t,
	regs_20_at_t = regs(20)@t,
	regs_21_at_t = regs(21)@t,
	regs_22_at_t = regs(22)@t,
	regs_23_at_t = regs(23)@t,
	regs_24_at_t = regs(24)@t,
	regs_25_at_t = regs(25)@t,
	regs_26_at_t = regs(26)@t,
	regs_27_at_t = regs(27)@t,
	regs_28_at_t = regs(28)@t,
	regs_29_at_t = regs(29)@t,
	regs_3_at_t = regs(3)@t,
	regs_30_at_t = regs(30)@t,
	regs_31_at_t = regs(31)@t,
	regs_4_at_t = regs(4)@t,
	regs_5_at_t = regs(5)@t,
	regs_6_at_t = regs(6)@t,
	regs_7_at_t = regs(7)@t,
	regs_8_at_t = regs(8)@t,
	regs_9_at_t = regs(9)@t,
	val_sig_at_t = val_sig@t;
assume:
	at t: start_state;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: out0_sig = (((address_at_t = 0))?val_sig_at_t:regs_0_at_t);
	at t_end: out10_sig = (((address_at_t = 10))?val_sig_at_t:regs_10_at_t);
	at t_end: out11_sig = (((address_at_t = 11))?val_sig_at_t:regs_11_at_t);
	at t_end: out12_sig = (((address_at_t = 12))?val_sig_at_t:regs_12_at_t);
	at t_end: out13_sig = (((address_at_t = 13))?val_sig_at_t:regs_13_at_t);
	at t_end: out14_sig = (((address_at_t = 14))?val_sig_at_t:regs_14_at_t);
	at t_end: out15_sig = (((address_at_t = 15))?val_sig_at_t:regs_15_at_t);
	at t_end: out16_sig = (((address_at_t = 16))?val_sig_at_t:regs_16_at_t);
	at t_end: out17_sig = (((address_at_t = 17))?val_sig_at_t:regs_17_at_t);
	at t_end: out18_sig = (((address_at_t = 18))?val_sig_at_t:regs_18_at_t);
	at t_end: out19_sig = (((address_at_t = 19))?val_sig_at_t:regs_19_at_t);
	at t_end: out1_sig = (((address_at_t = 1))?val_sig_at_t:regs_1_at_t);
	at t_end: out20_sig = (((address_at_t = 20))?val_sig_at_t:regs_20_at_t);
	at t_end: out21_sig = (((address_at_t = 21))?val_sig_at_t:regs_21_at_t);
	at t_end: out22_sig = (((address_at_t = 22))?val_sig_at_t:regs_22_at_t);
	at t_end: out23_sig = (((address_at_t = 23))?val_sig_at_t:regs_23_at_t);
	at t_end: out24_sig = (((address_at_t = 24))?val_sig_at_t:regs_24_at_t);
	at t_end: out25_sig = (((address_at_t = 25))?val_sig_at_t:regs_25_at_t);
	at t_end: out26_sig = (((address_at_t = 26))?val_sig_at_t:regs_26_at_t);
	at t_end: out27_sig = (((address_at_t = 27))?val_sig_at_t:regs_27_at_t);
	at t_end: out28_sig = (((address_at_t = 28))?val_sig_at_t:regs_28_at_t);
	at t_end: out29_sig = (((address_at_t = 29))?val_sig_at_t:regs_29_at_t);
	at t_end: out2_sig = (((address_at_t = 2))?val_sig_at_t:regs_2_at_t);
	at t_end: out30_sig = (((address_at_t = 30))?val_sig_at_t:regs_30_at_t);
	at t_end: out31_sig = (((address_at_t = 31))?val_sig_at_t:regs_31_at_t);
	at t_end: out3_sig = (((address_at_t = 3))?val_sig_at_t:regs_3_at_t);
	at t_end: out4_sig = (((address_at_t = 4))?val_sig_at_t:regs_4_at_t);
	at t_end: out5_sig = (((address_at_t = 5))?val_sig_at_t:regs_5_at_t);
	at t_end: out6_sig = (((address_at_t = 6))?val_sig_at_t:regs_6_at_t);
	at t_end: out7_sig = (((address_at_t = 7))?val_sig_at_t:regs_7_at_t);
	at t_end: out8_sig = (((address_at_t = 8))?val_sig_at_t:regs_8_at_t);
	at t_end: out9_sig = (((address_at_t = 9))?val_sig_at_t:regs_9_at_t);
	at t_end: regs(0) = (((address_at_t = 0))?val_sig_at_t:regs_0_at_t);
	at t_end: regs(10) = (((address_at_t = 10))?val_sig_at_t:regs_10_at_t);
	at t_end: regs(11) = (((address_at_t = 11))?val_sig_at_t:regs_11_at_t);
	at t_end: regs(12) = (((address_at_t = 12))?val_sig_at_t:regs_12_at_t);
	at t_end: regs(13) = (((address_at_t = 13))?val_sig_at_t:regs_13_at_t);
	at t_end: regs(14) = (((address_at_t = 14))?val_sig_at_t:regs_14_at_t);
	at t_end: regs(15) = (((address_at_t = 15))?val_sig_at_t:regs_15_at_t);
	at t_end: regs(16) = (((address_at_t = 16))?val_sig_at_t:regs_16_at_t);
	at t_end: regs(17) = (((address_at_t = 17))?val_sig_at_t:regs_17_at_t);
	at t_end: regs(18) = (((address_at_t = 18))?val_sig_at_t:regs_18_at_t);
	at t_end: regs(19) = (((address_at_t = 19))?val_sig_at_t:regs_19_at_t);
	at t_end: regs(1) = (((address_at_t = 1))?val_sig_at_t:regs_1_at_t);
	at t_end: regs(20) = (((address_at_t = 20))?val_sig_at_t:regs_20_at_t);
	at t_end: regs(21) = (((address_at_t = 21))?val_sig_at_t:regs_21_at_t);
	at t_end: regs(22) = (((address_at_t = 22))?val_sig_at_t:regs_22_at_t);
	at t_end: regs(23) = (((address_at_t = 23))?val_sig_at_t:regs_23_at_t);
	at t_end: regs(24) = (((address_at_t = 24))?val_sig_at_t:regs_24_at_t);
	at t_end: regs(25) = (((address_at_t = 25))?val_sig_at_t:regs_25_at_t);
	at t_end: regs(26) = (((address_at_t = 26))?val_sig_at_t:regs_26_at_t);
	at t_end: regs(27) = (((address_at_t = 27))?val_sig_at_t:regs_27_at_t);
	at t_end: regs(28) = (((address_at_t = 28))?val_sig_at_t:regs_28_at_t);
	at t_end: regs(29) = (((address_at_t = 29))?val_sig_at_t:regs_29_at_t);
	at t_end: regs(2) = (((address_at_t = 2))?val_sig_at_t:regs_2_at_t);
	at t_end: regs(30) = (((address_at_t = 30))?val_sig_at_t:regs_30_at_t);
	at t_end: regs(31) = (((address_at_t = 31))?val_sig_at_t:regs_31_at_t);
	at t_end: regs(3) = (((address_at_t = 3))?val_sig_at_t:regs_3_at_t);
	at t_end: regs(4) = (((address_at_t = 4))?val_sig_at_t:regs_4_at_t);
	at t_end: regs(5) = (((address_at_t = 5))?val_sig_at_t:regs_5_at_t);
	at t_end: regs(6) = (((address_at_t = 6))?val_sig_at_t:regs_6_at_t);
	at t_end: regs(7) = (((address_at_t = 7))?val_sig_at_t:regs_7_at_t);
	at t_end: regs(8) = (((address_at_t = 8))?val_sig_at_t:regs_8_at_t);
	at t_end: regs(9) = (((address_at_t = 9))?val_sig_at_t:regs_9_at_t);
	at t_end: val_notify = true;
end property;



