-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_sync : boolean := true end macro;
macro val_sync : boolean := true end macro;
macro out_notify : boolean := true end  macro;
macro val_notify : boolean := true end  macro;


-- DP SIGNALS --
macro out_sig : int_32 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;
macro out_sig_0 : signed :=resize(0,32) end macro;
macro out_sig_1 : signed :=resize(0,32) end macro;
macro out_sig_10 : signed :=resize(0,32) end macro;
macro out_sig_11 : signed :=resize(0,32) end macro;
macro out_sig_12 : signed :=resize(0,32) end macro;
macro out_sig_13 : signed :=resize(0,32) end macro;
macro out_sig_14 : signed :=resize(0,32) end macro;
macro out_sig_15 : signed :=resize(0,32) end macro;
macro out_sig_16 : signed :=resize(0,32) end macro;
macro out_sig_17 : signed :=resize(0,32) end macro;
macro out_sig_18 : signed :=resize(0,32) end macro;
macro out_sig_19 : signed :=resize(0,32) end macro;
macro out_sig_2 : signed :=resize(0,32) end macro;
macro out_sig_20 : signed :=resize(0,32) end macro;
macro out_sig_21 : signed :=resize(0,32) end macro;
macro out_sig_22 : signed :=resize(0,32) end macro;
macro out_sig_23 : signed :=resize(0,32) end macro;
macro out_sig_24 : signed :=resize(0,32) end macro;
macro out_sig_25 : signed :=resize(0,32) end macro;
macro out_sig_26 : signed :=resize(0,32) end macro;
macro out_sig_27 : signed :=resize(0,32) end macro;
macro out_sig_28 : signed :=resize(0,32) end macro;
macro out_sig_29 : signed :=resize(0,32) end macro;
macro out_sig_3 : signed :=resize(0,32) end macro;
macro out_sig_30 : signed :=resize(0,32) end macro;
macro out_sig_31 : signed :=resize(0,32) end macro;
macro out_sig_4 : signed :=resize(0,32) end macro;
macro out_sig_5 : signed :=resize(0,32) end macro;
macro out_sig_6 : signed :=resize(0,32) end macro;
macro out_sig_7 : signed :=resize(0,32) end macro;
macro out_sig_8 : signed :=resize(0,32) end macro;
macro out_sig_9 : signed :=resize(0,32) end macro;
macro val_sig : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro address : signed :=resize(0,32) end macro;
macro regs : int_32 :={resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32), resize(0,32)} end macro;


-- STATES --
macro start_state : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: address = address;
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
	 at t: out_notify = false;
	 at t: val_notify = false;
	 at t: out_notify = true;
	 at t: val_notify = false;
end property;


property start_state_10 is
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
	at t_end: out_sig(0) = regs_0_at_t;
	at t_end: out_sig(10) = regs_10_at_t;
	at t_end: out_sig(11) = regs_11_at_t;
	at t_end: out_sig(12) = regs_12_at_t;
	at t_end: out_sig(13) = regs_13_at_t;
	at t_end: out_sig(14) = regs_14_at_t;
	at t_end: out_sig(15) = regs_15_at_t;
	at t_end: out_sig(16) = regs_16_at_t;
	at t_end: out_sig(17) = regs_17_at_t;
	at t_end: out_sig(18) = regs_18_at_t;
	at t_end: out_sig(19) = regs_19_at_t;
	at t_end: out_sig(1) = regs_1_at_t;
	at t_end: out_sig(20) = regs_20_at_t;
	at t_end: out_sig(21) = regs_21_at_t;
	at t_end: out_sig(22) = regs_22_at_t;
	at t_end: out_sig(23) = regs_23_at_t;
	at t_end: out_sig(24) = regs_24_at_t;
	at t_end: out_sig(25) = regs_25_at_t;
	at t_end: out_sig(26) = regs_26_at_t;
	at t_end: out_sig(27) = regs_27_at_t;
	at t_end: out_sig(28) = regs_28_at_t;
	at t_end: out_sig(29) = regs_29_at_t;
	at t_end: out_sig(2) = regs_2_at_t;
	at t_end: out_sig(30) = regs_30_at_t;
	at t_end: out_sig(31) = regs_31_at_t;
	at t_end: out_sig(3) = regs_3_at_t;
	at t_end: out_sig(4) = regs_4_at_t;
	at t_end: out_sig(5) = regs_5_at_t;
	at t_end: out_sig(6) = regs_6_at_t;
	at t_end: out_sig(7) = regs_7_at_t;
	at t_end: out_sig(8) = regs_8_at_t;
	at t_end: out_sig(9) = regs_9_at_t;
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
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property start_state_11 is
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
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
	at t_end: regs(0) = ((address_at_t = 0))?val_sig_at_t:regs_0_at_t;
	at t_end: regs(10) = ((address_at_t = 10))?val_sig_at_t:regs_10_at_t;
	at t_end: regs(11) = ((address_at_t = 11))?val_sig_at_t:regs_11_at_t;
	at t_end: regs(12) = ((address_at_t = 12))?val_sig_at_t:regs_12_at_t;
	at t_end: regs(13) = ((address_at_t = 13))?val_sig_at_t:regs_13_at_t;
	at t_end: regs(14) = ((address_at_t = 14))?val_sig_at_t:regs_14_at_t;
	at t_end: regs(15) = ((address_at_t = 15))?val_sig_at_t:regs_15_at_t;
	at t_end: regs(16) = ((address_at_t = 16))?val_sig_at_t:regs_16_at_t;
	at t_end: regs(17) = ((address_at_t = 17))?val_sig_at_t:regs_17_at_t;
	at t_end: regs(18) = ((address_at_t = 18))?val_sig_at_t:regs_18_at_t;
	at t_end: regs(19) = ((address_at_t = 19))?val_sig_at_t:regs_19_at_t;
	at t_end: regs(1) = ((address_at_t = 1))?val_sig_at_t:regs_1_at_t;
	at t_end: regs(20) = ((address_at_t = 20))?val_sig_at_t:regs_20_at_t;
	at t_end: regs(21) = ((address_at_t = 21))?val_sig_at_t:regs_21_at_t;
	at t_end: regs(22) = ((address_at_t = 22))?val_sig_at_t:regs_22_at_t;
	at t_end: regs(23) = ((address_at_t = 23))?val_sig_at_t:regs_23_at_t;
	at t_end: regs(24) = ((address_at_t = 24))?val_sig_at_t:regs_24_at_t;
	at t_end: regs(25) = ((address_at_t = 25))?val_sig_at_t:regs_25_at_t;
	at t_end: regs(26) = ((address_at_t = 26))?val_sig_at_t:regs_26_at_t;
	at t_end: regs(27) = ((address_at_t = 27))?val_sig_at_t:regs_27_at_t;
	at t_end: regs(28) = ((address_at_t = 28))?val_sig_at_t:regs_28_at_t;
	at t_end: regs(29) = ((address_at_t = 29))?val_sig_at_t:regs_29_at_t;
	at t_end: regs(2) = ((address_at_t = 2))?val_sig_at_t:regs_2_at_t;
	at t_end: regs(30) = ((address_at_t = 30))?val_sig_at_t:regs_30_at_t;
	at t_end: regs(31) = ((address_at_t = 31))?val_sig_at_t:regs_31_at_t;
	at t_end: regs(3) = ((address_at_t = 3))?val_sig_at_t:regs_3_at_t;
	at t_end: regs(4) = ((address_at_t = 4))?val_sig_at_t:regs_4_at_t;
	at t_end: regs(5) = ((address_at_t = 5))?val_sig_at_t:regs_5_at_t;
	at t_end: regs(6) = ((address_at_t = 6))?val_sig_at_t:regs_6_at_t;
	at t_end: regs(7) = ((address_at_t = 7))?val_sig_at_t:regs_7_at_t;
	at t_end: regs(8) = ((address_at_t = 8))?val_sig_at_t:regs_8_at_t;
	at t_end: regs(9) = ((address_at_t = 9))?val_sig_at_t:regs_9_at_t;
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = false;
	at t_end: val_notify = true;
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
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
	at t_end: out_sig(0) = regs_0_at_t;
	at t_end: out_sig(10) = regs_10_at_t;
	at t_end: out_sig(11) = regs_11_at_t;
	at t_end: out_sig(12) = regs_12_at_t;
	at t_end: out_sig(13) = regs_13_at_t;
	at t_end: out_sig(14) = regs_14_at_t;
	at t_end: out_sig(15) = regs_15_at_t;
	at t_end: out_sig(16) = regs_16_at_t;
	at t_end: out_sig(17) = regs_17_at_t;
	at t_end: out_sig(18) = regs_18_at_t;
	at t_end: out_sig(19) = regs_19_at_t;
	at t_end: out_sig(1) = regs_1_at_t;
	at t_end: out_sig(20) = regs_20_at_t;
	at t_end: out_sig(21) = regs_21_at_t;
	at t_end: out_sig(22) = regs_22_at_t;
	at t_end: out_sig(23) = regs_23_at_t;
	at t_end: out_sig(24) = regs_24_at_t;
	at t_end: out_sig(25) = regs_25_at_t;
	at t_end: out_sig(26) = regs_26_at_t;
	at t_end: out_sig(27) = regs_27_at_t;
	at t_end: out_sig(28) = regs_28_at_t;
	at t_end: out_sig(29) = regs_29_at_t;
	at t_end: out_sig(2) = regs_2_at_t;
	at t_end: out_sig(30) = regs_30_at_t;
	at t_end: out_sig(31) = regs_31_at_t;
	at t_end: out_sig(3) = regs_3_at_t;
	at t_end: out_sig(4) = regs_4_at_t;
	at t_end: out_sig(5) = regs_5_at_t;
	at t_end: out_sig(6) = regs_6_at_t;
	at t_end: out_sig(7) = regs_7_at_t;
	at t_end: out_sig(8) = regs_8_at_t;
	at t_end: out_sig(9) = regs_9_at_t;
	at t_end: regs(0) = ((address_at_t = 0))?val_sig_at_t:regs_0_at_t;
	at t_end: regs(10) = ((address_at_t = 10))?val_sig_at_t:regs_10_at_t;
	at t_end: regs(11) = ((address_at_t = 11))?val_sig_at_t:regs_11_at_t;
	at t_end: regs(12) = ((address_at_t = 12))?val_sig_at_t:regs_12_at_t;
	at t_end: regs(13) = ((address_at_t = 13))?val_sig_at_t:regs_13_at_t;
	at t_end: regs(14) = ((address_at_t = 14))?val_sig_at_t:regs_14_at_t;
	at t_end: regs(15) = ((address_at_t = 15))?val_sig_at_t:regs_15_at_t;
	at t_end: regs(16) = ((address_at_t = 16))?val_sig_at_t:regs_16_at_t;
	at t_end: regs(17) = ((address_at_t = 17))?val_sig_at_t:regs_17_at_t;
	at t_end: regs(18) = ((address_at_t = 18))?val_sig_at_t:regs_18_at_t;
	at t_end: regs(19) = ((address_at_t = 19))?val_sig_at_t:regs_19_at_t;
	at t_end: regs(1) = ((address_at_t = 1))?val_sig_at_t:regs_1_at_t;
	at t_end: regs(20) = ((address_at_t = 20))?val_sig_at_t:regs_20_at_t;
	at t_end: regs(21) = ((address_at_t = 21))?val_sig_at_t:regs_21_at_t;
	at t_end: regs(22) = ((address_at_t = 22))?val_sig_at_t:regs_22_at_t;
	at t_end: regs(23) = ((address_at_t = 23))?val_sig_at_t:regs_23_at_t;
	at t_end: regs(24) = ((address_at_t = 24))?val_sig_at_t:regs_24_at_t;
	at t_end: regs(25) = ((address_at_t = 25))?val_sig_at_t:regs_25_at_t;
	at t_end: regs(26) = ((address_at_t = 26))?val_sig_at_t:regs_26_at_t;
	at t_end: regs(27) = ((address_at_t = 27))?val_sig_at_t:regs_27_at_t;
	at t_end: regs(28) = ((address_at_t = 28))?val_sig_at_t:regs_28_at_t;
	at t_end: regs(29) = ((address_at_t = 29))?val_sig_at_t:regs_29_at_t;
	at t_end: regs(2) = ((address_at_t = 2))?val_sig_at_t:regs_2_at_t;
	at t_end: regs(30) = ((address_at_t = 30))?val_sig_at_t:regs_30_at_t;
	at t_end: regs(31) = ((address_at_t = 31))?val_sig_at_t:regs_31_at_t;
	at t_end: regs(3) = ((address_at_t = 3))?val_sig_at_t:regs_3_at_t;
	at t_end: regs(4) = ((address_at_t = 4))?val_sig_at_t:regs_4_at_t;
	at t_end: regs(5) = ((address_at_t = 5))?val_sig_at_t:regs_5_at_t;
	at t_end: regs(6) = ((address_at_t = 6))?val_sig_at_t:regs_6_at_t;
	at t_end: regs(7) = ((address_at_t = 7))?val_sig_at_t:regs_7_at_t;
	at t_end: regs(8) = ((address_at_t = 8))?val_sig_at_t:regs_8_at_t;
	at t_end: regs(9) = ((address_at_t = 9))?val_sig_at_t:regs_9_at_t;
	at t_end: val_sig = val_sig_at_t;
	at t_end: out_notify = true;
	at t_end: val_notify = true;
end property;


property start_state_13 is
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
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
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;


property start_state_6 is
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: out_sync;
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
	at t_end: out_sig(0) = regs_0_at_t;
	at t_end: out_sig(10) = regs_10_at_t;
	at t_end: out_sig(11) = regs_11_at_t;
	at t_end: out_sig(12) = regs_12_at_t;
	at t_end: out_sig(13) = regs_13_at_t;
	at t_end: out_sig(14) = regs_14_at_t;
	at t_end: out_sig(15) = regs_15_at_t;
	at t_end: out_sig(16) = regs_16_at_t;
	at t_end: out_sig(17) = regs_17_at_t;
	at t_end: out_sig(18) = regs_18_at_t;
	at t_end: out_sig(19) = regs_19_at_t;
	at t_end: out_sig(1) = regs_1_at_t;
	at t_end: out_sig(20) = regs_20_at_t;
	at t_end: out_sig(21) = regs_21_at_t;
	at t_end: out_sig(22) = regs_22_at_t;
	at t_end: out_sig(23) = regs_23_at_t;
	at t_end: out_sig(24) = regs_24_at_t;
	at t_end: out_sig(25) = regs_25_at_t;
	at t_end: out_sig(26) = regs_26_at_t;
	at t_end: out_sig(27) = regs_27_at_t;
	at t_end: out_sig(28) = regs_28_at_t;
	at t_end: out_sig(29) = regs_29_at_t;
	at t_end: out_sig(2) = regs_2_at_t;
	at t_end: out_sig(30) = regs_30_at_t;
	at t_end: out_sig(31) = regs_31_at_t;
	at t_end: out_sig(3) = regs_3_at_t;
	at t_end: out_sig(4) = regs_4_at_t;
	at t_end: out_sig(5) = regs_5_at_t;
	at t_end: out_sig(6) = regs_6_at_t;
	at t_end: out_sig(7) = regs_7_at_t;
	at t_end: out_sig(8) = regs_8_at_t;
	at t_end: out_sig(9) = regs_9_at_t;
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
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property start_state_7 is
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
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
	at t_end: out_notify = false;
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: out_sync;
	at t: val_sync;
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
	at t_end: out_sig(0) = regs_0_at_t;
	at t_end: out_sig(10) = regs_10_at_t;
	at t_end: out_sig(11) = regs_11_at_t;
	at t_end: out_sig(12) = regs_12_at_t;
	at t_end: out_sig(13) = regs_13_at_t;
	at t_end: out_sig(14) = regs_14_at_t;
	at t_end: out_sig(15) = regs_15_at_t;
	at t_end: out_sig(16) = regs_16_at_t;
	at t_end: out_sig(17) = regs_17_at_t;
	at t_end: out_sig(18) = regs_18_at_t;
	at t_end: out_sig(19) = regs_19_at_t;
	at t_end: out_sig(1) = regs_1_at_t;
	at t_end: out_sig(20) = regs_20_at_t;
	at t_end: out_sig(21) = regs_21_at_t;
	at t_end: out_sig(22) = regs_22_at_t;
	at t_end: out_sig(23) = regs_23_at_t;
	at t_end: out_sig(24) = regs_24_at_t;
	at t_end: out_sig(25) = regs_25_at_t;
	at t_end: out_sig(26) = regs_26_at_t;
	at t_end: out_sig(27) = regs_27_at_t;
	at t_end: out_sig(28) = regs_28_at_t;
	at t_end: out_sig(29) = regs_29_at_t;
	at t_end: out_sig(2) = regs_2_at_t;
	at t_end: out_sig(30) = regs_30_at_t;
	at t_end: out_sig(31) = regs_31_at_t;
	at t_end: out_sig(3) = regs_3_at_t;
	at t_end: out_sig(4) = regs_4_at_t;
	at t_end: out_sig(5) = regs_5_at_t;
	at t_end: out_sig(6) = regs_6_at_t;
	at t_end: out_sig(7) = regs_7_at_t;
	at t_end: out_sig(8) = regs_8_at_t;
	at t_end: out_sig(9) = regs_9_at_t;
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
	at t_end: out_notify = true;
	at t_end: val_notify = false;
end property;


property start_state_9 is
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
	regs_9_at_t = regs(9)@t;
assume:
	at t: start_state;
	at t: not(out_sync);
	at t: not(val_sync);
prove:
	at t_end: start_state;
	at t_end: address = address_at_t;
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
	at t_end: out_notify = false;
	at t_end: val_notify = false;
end property;



