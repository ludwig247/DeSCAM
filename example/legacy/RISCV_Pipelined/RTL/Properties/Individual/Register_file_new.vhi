-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro DPtoRF_port_sync : boolean := end macro;


-- DP SIGNALS --
macro DPtoRF_port_sig_dst : unsigned := DPtoRF_port.dst end macro;
macro DPtoRF_port_sig_dstData : unsigned := DPtoRF_port.dstData end macro;
macro DPtoRF_port_sig_wrReq : RF_WR_AccessType := DPtoRF_port.wrReq end macro;
macro RFtoDP_port_sig_reg_file_01 : unsigned := reg_file(1) end macro;
macro RFtoDP_port_sig_reg_file_02 : unsigned := reg_file(2) end macro;
macro RFtoDP_port_sig_reg_file_03 : unsigned := reg_file(3) end macro;
macro RFtoDP_port_sig_reg_file_04 : unsigned := reg_file(4) end macro;
macro RFtoDP_port_sig_reg_file_05 : unsigned := reg_file(5) end macro;
macro RFtoDP_port_sig_reg_file_06 : unsigned := reg_file(6) end macro;
macro RFtoDP_port_sig_reg_file_07 : unsigned := reg_file(7) end macro;
macro RFtoDP_port_sig_reg_file_08 : unsigned := reg_file(8) end macro;
macro RFtoDP_port_sig_reg_file_09 : unsigned := reg_file(9) end macro;
macro RFtoDP_port_sig_reg_file_10 : unsigned := reg_file(10) end macro;
macro RFtoDP_port_sig_reg_file_11 : unsigned := reg_file(11) end macro;
macro RFtoDP_port_sig_reg_file_12 : unsigned := reg_file(12) end macro;
macro RFtoDP_port_sig_reg_file_13 : unsigned := reg_file(13) end macro;
macro RFtoDP_port_sig_reg_file_14 : unsigned := reg_file(14) end macro;
macro RFtoDP_port_sig_reg_file_15 : unsigned := reg_file(15) end macro;
macro RFtoDP_port_sig_reg_file_16 : unsigned := reg_file(16) end macro;
macro RFtoDP_port_sig_reg_file_17 : unsigned := reg_file(17) end macro;
macro RFtoDP_port_sig_reg_file_18 : unsigned := reg_file(18) end macro;
macro RFtoDP_port_sig_reg_file_19 : unsigned := reg_file(19) end macro;
macro RFtoDP_port_sig_reg_file_20 : unsigned := reg_file(20) end macro;
macro RFtoDP_port_sig_reg_file_21 : unsigned := reg_file(21) end macro;
macro RFtoDP_port_sig_reg_file_22 : unsigned := reg_file(22) end macro;
macro RFtoDP_port_sig_reg_file_23 : unsigned := reg_file(23) end macro;
macro RFtoDP_port_sig_reg_file_24 : unsigned := reg_file(24) end macro;
macro RFtoDP_port_sig_reg_file_25 : unsigned := reg_file(25) end macro;
macro RFtoDP_port_sig_reg_file_26 : unsigned := reg_file(26) end macro;
macro RFtoDP_port_sig_reg_file_27 : unsigned := reg_file(27) end macro;
macro RFtoDP_port_sig_reg_file_28 : unsigned := reg_file(28) end macro;
macro RFtoDP_port_sig_reg_file_29 : unsigned := reg_file(29) end macro;
macro RFtoDP_port_sig_reg_file_30 : unsigned := reg_file(30) end macro;
macro RFtoDP_port_sig_reg_file_31 : unsigned := reg_file(31) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro reg_file_01 : unsigned := reg_file( 1) end macro;
macro reg_file_02 : unsigned := reg_file( 2) end macro;
macro reg_file_03 : unsigned := reg_file( 3) end macro;
macro reg_file_04 : unsigned := reg_file( 4) end macro;
macro reg_file_05 : unsigned := reg_file( 5) end macro;
macro reg_file_06 : unsigned := reg_file( 6) end macro;
macro reg_file_07 : unsigned := reg_file( 7) end macro;
macro reg_file_08 : unsigned := reg_file( 8) end macro;
macro reg_file_09 : unsigned := reg_file( 9) end macro;
macro reg_file_10 : unsigned := reg_file(10) end macro;
macro reg_file_11 : unsigned := reg_file(11) end macro;
macro reg_file_12 : unsigned := reg_file(12) end macro;
macro reg_file_13 : unsigned := reg_file(13) end macro;
macro reg_file_14 : unsigned := reg_file(14) end macro;
macro reg_file_15 : unsigned := reg_file(15) end macro;
macro reg_file_16 : unsigned := reg_file(16) end macro;
macro reg_file_17 : unsigned := reg_file(17) end macro;
macro reg_file_18 : unsigned := reg_file(18) end macro;
macro reg_file_19 : unsigned := reg_file(19) end macro;
macro reg_file_20 : unsigned := reg_file(20) end macro;
macro reg_file_21 : unsigned := reg_file(21) end macro;
macro reg_file_22 : unsigned := reg_file(22) end macro;
macro reg_file_23 : unsigned := reg_file(23) end macro;
macro reg_file_24 : unsigned := reg_file(24) end macro;
macro reg_file_25 : unsigned := reg_file(25) end macro;
macro reg_file_26 : unsigned := reg_file(26) end macro;
macro reg_file_27 : unsigned := reg_file(27) end macro;
macro reg_file_28 : unsigned := reg_file(28) end macro;
macro reg_file_29 : unsigned := reg_file(29) end macro;
macro reg_file_30 : unsigned := reg_file(30) end macro;
macro reg_file_31 : unsigned := reg_file(31) end macro;


-- STATES --
macro state_102 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_102;
	 at t: RFtoDP_port_sig_reg_file_01 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_02 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_03 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_04 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_05 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_06 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_07 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_08 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_09 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_10 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_11 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_12 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_13 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_14 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_15 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_16 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_17 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_18 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_19 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_20 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_21 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_22 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_23 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_24 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_25 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_26 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_27 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_28 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_29 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_30 = resize(0,32);
	 at t: RFtoDP_port_sig_reg_file_31 = resize(0,32);
	 at t: reg_file_01 = resize(0,32);
	 at t: reg_file_02 = resize(0,32);
	 at t: reg_file_03 = resize(0,32);
	 at t: reg_file_04 = resize(0,32);
	 at t: reg_file_05 = resize(0,32);
	 at t: reg_file_06 = resize(0,32);
	 at t: reg_file_07 = resize(0,32);
	 at t: reg_file_08 = resize(0,32);
	 at t: reg_file_09 = resize(0,32);
	 at t: reg_file_10 = resize(0,32);
	 at t: reg_file_11 = resize(0,32);
	 at t: reg_file_12 = resize(0,32);
	 at t: reg_file_13 = resize(0,32);
	 at t: reg_file_14 = resize(0,32);
	 at t: reg_file_15 = resize(0,32);
	 at t: reg_file_16 = resize(0,32);
	 at t: reg_file_17 = resize(0,32);
	 at t: reg_file_18 = resize(0,32);
	 at t: reg_file_19 = resize(0,32);
	 at t: reg_file_20 = resize(0,32);
	 at t: reg_file_21 = resize(0,32);
	 at t: reg_file_22 = resize(0,32);
	 at t: reg_file_23 = resize(0,32);
	 at t: reg_file_24 = resize(0,32);
	 at t: reg_file_25 = resize(0,32);
	 at t: reg_file_26 = resize(0,32);
	 at t: reg_file_27 = resize(0,32);
	 at t: reg_file_28 = resize(0,32);
	 at t: reg_file_29 = resize(0,32);
	 at t: reg_file_30 = resize(0,32);
	 at t: reg_file_31 = resize(0,32);
end property;


property state_102_1 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(1,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_3 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(2,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_5 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(3,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_7 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(4,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_9 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(5,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_11 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(6,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_13 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(7,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_15 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(8,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_17 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(9,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_19 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(10,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_21 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(11,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_23 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(12,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_25 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(13,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_27 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(14,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_29 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(15,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_31 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(16,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_33 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(17,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_35 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(18,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_37 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(19,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_39 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(20,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_41 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(21,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_43 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(22,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_45 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(23,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_47 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(24,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_49 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(25,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_51 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(26,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_53 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(27,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_55 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(28,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_57 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(29,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_59 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: (DPtoRF_port_sig_dst = resize(30,32));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = DPtoRF_port_sig_dstData_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_61 is
dependencies: no_reset;
freeze:
	DPtoRF_port_sig_dstData_at_t = DPtoRF_port_sig_dstData@t,
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: (DPtoRF_port_sig_wrReq = RF_WR);
	at t: not((DPtoRF_port_sig_dst = resize(0,32)));
	at t: not((DPtoRF_port_sig_dst = resize(1,32)));
	at t: not((DPtoRF_port_sig_dst = resize(2,32)));
	at t: not((DPtoRF_port_sig_dst = resize(3,32)));
	at t: not((DPtoRF_port_sig_dst = resize(4,32)));
	at t: not((DPtoRF_port_sig_dst = resize(5,32)));
	at t: not((DPtoRF_port_sig_dst = resize(6,32)));
	at t: not((DPtoRF_port_sig_dst = resize(7,32)));
	at t: not((DPtoRF_port_sig_dst = resize(8,32)));
	at t: not((DPtoRF_port_sig_dst = resize(9,32)));
	at t: not((DPtoRF_port_sig_dst = resize(10,32)));
	at t: not((DPtoRF_port_sig_dst = resize(11,32)));
	at t: not((DPtoRF_port_sig_dst = resize(12,32)));
	at t: not((DPtoRF_port_sig_dst = resize(13,32)));
	at t: not((DPtoRF_port_sig_dst = resize(14,32)));
	at t: not((DPtoRF_port_sig_dst = resize(15,32)));
	at t: not((DPtoRF_port_sig_dst = resize(16,32)));
	at t: not((DPtoRF_port_sig_dst = resize(17,32)));
	at t: not((DPtoRF_port_sig_dst = resize(18,32)));
	at t: not((DPtoRF_port_sig_dst = resize(19,32)));
	at t: not((DPtoRF_port_sig_dst = resize(20,32)));
	at t: not((DPtoRF_port_sig_dst = resize(21,32)));
	at t: not((DPtoRF_port_sig_dst = resize(22,32)));
	at t: not((DPtoRF_port_sig_dst = resize(23,32)));
	at t: not((DPtoRF_port_sig_dst = resize(24,32)));
	at t: not((DPtoRF_port_sig_dst = resize(25,32)));
	at t: not((DPtoRF_port_sig_dst = resize(26,32)));
	at t: not((DPtoRF_port_sig_dst = resize(27,32)));
	at t: not((DPtoRF_port_sig_dst = resize(28,32)));
	at t: not((DPtoRF_port_sig_dst = resize(29,32)));
	at t: not((DPtoRF_port_sig_dst = resize(30,32)));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = DPtoRF_port_sig_dstData_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = DPtoRF_port_sig_dstData_at_t;
end property;


property state_102_63 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: DPtoRF_port_sync;
	at t: not(((DPtoRF_port_sig_wrReq = RF_WR) and not((DPtoRF_port_sig_dst = resize(0,32)))));
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


property state_102_66 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
	reg_file_08_at_t = reg_file_08@t,
	reg_file_09_at_t = reg_file_09@t,
	reg_file_10_at_t = reg_file_10@t,
	reg_file_11_at_t = reg_file_11@t,
	reg_file_12_at_t = reg_file_12@t,
	reg_file_13_at_t = reg_file_13@t,
	reg_file_14_at_t = reg_file_14@t,
	reg_file_15_at_t = reg_file_15@t,
	reg_file_16_at_t = reg_file_16@t,
	reg_file_17_at_t = reg_file_17@t,
	reg_file_18_at_t = reg_file_18@t,
	reg_file_19_at_t = reg_file_19@t,
	reg_file_20_at_t = reg_file_20@t,
	reg_file_21_at_t = reg_file_21@t,
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t;
assume:
	at t: state_102;
	at t: not(DPtoRF_port_sync);
prove:
	at t+1: state_102;
	at t+1: RFtoDP_port_sig_reg_file_01 = reg_file_01_at_t;
	at t+1: RFtoDP_port_sig_reg_file_02 = reg_file_02_at_t;
	at t+1: RFtoDP_port_sig_reg_file_03 = reg_file_03_at_t;
	at t+1: RFtoDP_port_sig_reg_file_04 = reg_file_04_at_t;
	at t+1: RFtoDP_port_sig_reg_file_05 = reg_file_05_at_t;
	at t+1: RFtoDP_port_sig_reg_file_06 = reg_file_06_at_t;
	at t+1: RFtoDP_port_sig_reg_file_07 = reg_file_07_at_t;
	at t+1: RFtoDP_port_sig_reg_file_08 = reg_file_08_at_t;
	at t+1: RFtoDP_port_sig_reg_file_09 = reg_file_09_at_t;
	at t+1: RFtoDP_port_sig_reg_file_10 = reg_file_10_at_t;
	at t+1: RFtoDP_port_sig_reg_file_11 = reg_file_11_at_t;
	at t+1: RFtoDP_port_sig_reg_file_12 = reg_file_12_at_t;
	at t+1: RFtoDP_port_sig_reg_file_13 = reg_file_13_at_t;
	at t+1: RFtoDP_port_sig_reg_file_14 = reg_file_14_at_t;
	at t+1: RFtoDP_port_sig_reg_file_15 = reg_file_15_at_t;
	at t+1: RFtoDP_port_sig_reg_file_16 = reg_file_16_at_t;
	at t+1: RFtoDP_port_sig_reg_file_17 = reg_file_17_at_t;
	at t+1: RFtoDP_port_sig_reg_file_18 = reg_file_18_at_t;
	at t+1: RFtoDP_port_sig_reg_file_19 = reg_file_19_at_t;
	at t+1: RFtoDP_port_sig_reg_file_20 = reg_file_20_at_t;
	at t+1: RFtoDP_port_sig_reg_file_21 = reg_file_21_at_t;
	at t+1: RFtoDP_port_sig_reg_file_22 = reg_file_22_at_t;
	at t+1: RFtoDP_port_sig_reg_file_23 = reg_file_23_at_t;
	at t+1: RFtoDP_port_sig_reg_file_24 = reg_file_24_at_t;
	at t+1: RFtoDP_port_sig_reg_file_25 = reg_file_25_at_t;
	at t+1: RFtoDP_port_sig_reg_file_26 = reg_file_26_at_t;
	at t+1: RFtoDP_port_sig_reg_file_27 = reg_file_27_at_t;
	at t+1: RFtoDP_port_sig_reg_file_28 = reg_file_28_at_t;
	at t+1: RFtoDP_port_sig_reg_file_29 = reg_file_29_at_t;
	at t+1: RFtoDP_port_sig_reg_file_30 = reg_file_30_at_t;
	at t+1: RFtoDP_port_sig_reg_file_31 = reg_file_31_at_t;
	at t+1: reg_file_01 = reg_file_01_at_t;
	at t+1: reg_file_02 = reg_file_02_at_t;
	at t+1: reg_file_03 = reg_file_03_at_t;
	at t+1: reg_file_04 = reg_file_04_at_t;
	at t+1: reg_file_05 = reg_file_05_at_t;
	at t+1: reg_file_06 = reg_file_06_at_t;
	at t+1: reg_file_07 = reg_file_07_at_t;
	at t+1: reg_file_08 = reg_file_08_at_t;
	at t+1: reg_file_09 = reg_file_09_at_t;
	at t+1: reg_file_10 = reg_file_10_at_t;
	at t+1: reg_file_11 = reg_file_11_at_t;
	at t+1: reg_file_12 = reg_file_12_at_t;
	at t+1: reg_file_13 = reg_file_13_at_t;
	at t+1: reg_file_14 = reg_file_14_at_t;
	at t+1: reg_file_15 = reg_file_15_at_t;
	at t+1: reg_file_16 = reg_file_16_at_t;
	at t+1: reg_file_17 = reg_file_17_at_t;
	at t+1: reg_file_18 = reg_file_18_at_t;
	at t+1: reg_file_19 = reg_file_19_at_t;
	at t+1: reg_file_20 = reg_file_20_at_t;
	at t+1: reg_file_21 = reg_file_21_at_t;
	at t+1: reg_file_22 = reg_file_22_at_t;
	at t+1: reg_file_23 = reg_file_23_at_t;
	at t+1: reg_file_24 = reg_file_24_at_t;
	at t+1: reg_file_25 = reg_file_25_at_t;
	at t+1: reg_file_26 = reg_file_26_at_t;
	at t+1: reg_file_27 = reg_file_27_at_t;
	at t+1: reg_file_28 = reg_file_28_at_t;
	at t+1: reg_file_29 = reg_file_29_at_t;
	at t+1: reg_file_30 = reg_file_30_at_t;
	at t+1: reg_file_31 = reg_file_31_at_t;
end property;


