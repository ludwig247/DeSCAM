-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro ISAtoRF_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro RFtoISA_port_sig_reg_file_01 : unsigned := RFtoISA_port_sig.reg_file_01 end macro; 
macro RFtoISA_port_sig_reg_file_02 : unsigned := RFtoISA_port_sig.reg_file_02 end macro; 
macro RFtoISA_port_sig_reg_file_06 : unsigned := RFtoISA_port_sig.reg_file_06 end macro; 
macro RFtoISA_port_sig_reg_file_07 : unsigned := RFtoISA_port_sig.reg_file_07 end macro; 
macro RFtoISA_port_sig_reg_file_08 : unsigned := RFtoISA_port_sig.reg_file_08 end macro; 
macro RFtoISA_port_sig_reg_file_09 : unsigned := RFtoISA_port_sig.reg_file_09 end macro; 
macro RFtoISA_port_sig_reg_file_10 : unsigned := RFtoISA_port_sig.reg_file_10 end macro; 
macro RFtoISA_port_sig_reg_file_11 : unsigned := RFtoISA_port_sig.reg_file_11 end macro; 
macro RFtoISA_port_sig_reg_file_12 : unsigned := RFtoISA_port_sig.reg_file_12 end macro; 
macro RFtoISA_port_sig_reg_file_13 : unsigned := RFtoISA_port_sig.reg_file_13 end macro; 
macro RFtoISA_port_sig_reg_file_14 : unsigned := RFtoISA_port_sig.reg_file_14 end macro; 
macro RFtoISA_port_sig_reg_file_15 : unsigned := RFtoISA_port_sig.reg_file_15 end macro; 
macro RFtoISA_port_sig_reg_file_16 : unsigned := RFtoISA_port_sig.reg_file_16 end macro; 
macro RFtoISA_port_sig_reg_file_17 : unsigned := RFtoISA_port_sig.reg_file_17 end macro; 
macro RFtoISA_port_sig_reg_file_18 : unsigned := RFtoISA_port_sig.reg_file_18 end macro; 
macro RFtoISA_port_sig_reg_file_19 : unsigned := RFtoISA_port_sig.reg_file_19 end macro; 
macro RFtoISA_port_sig_reg_file_20 : unsigned := RFtoISA_port_sig.reg_file_20 end macro; 
macro RFtoISA_port_sig_reg_file_21 : unsigned := RFtoISA_port_sig.reg_file_21 end macro; 
macro RFtoISA_port_sig_reg_file_22 : unsigned := RFtoISA_port_sig.reg_file_22 end macro; 
macro RFtoISA_port_sig_reg_file_23 : unsigned := RFtoISA_port_sig.reg_file_23 end macro; 
macro RFtoISA_port_sig_reg_file_24 : unsigned := RFtoISA_port_sig.reg_file_24 end macro; 
macro RFtoISA_port_sig_reg_file_25 : unsigned := RFtoISA_port_sig.reg_file_25 end macro; 
macro RFtoISA_port_sig_reg_file_26 : unsigned := RFtoISA_port_sig.reg_file_26 end macro; 
macro RFtoISA_port_sig_reg_file_27 : unsigned := RFtoISA_port_sig.reg_file_27 end macro; 
macro ISAtoRF_port_sig_dst : unsigned := ISAtoRF_port_sig.dst end macro; 
macro ISAtoRF_port_sig_dstData : unsigned := ISAtoRF_port_sig.dstData end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro reg_file_01 : unsigned := RFtoISA_port_sig.reg_file_01 end macro; 
macro reg_file_02 : unsigned := RFtoISA_port_sig.reg_file_02 end macro; 
macro reg_file_06 : unsigned := RFtoISA_port_sig.reg_file_06 end macro; 
macro reg_file_07 : unsigned := RFtoISA_port_sig.reg_file_07 end macro; 
macro reg_file_08 : unsigned := RFtoISA_port_sig.reg_file_08 end macro; 
macro reg_file_09 : unsigned := RFtoISA_port_sig.reg_file_09 end macro; 
macro reg_file_10 : unsigned := RFtoISA_port_sig.reg_file_10 end macro; 
macro reg_file_11 : unsigned := RFtoISA_port_sig.reg_file_11 end macro; 
macro reg_file_12 : unsigned := RFtoISA_port_sig.reg_file_12 end macro; 
macro reg_file_13 : unsigned := RFtoISA_port_sig.reg_file_13 end macro; 
macro reg_file_14 : unsigned := RFtoISA_port_sig.reg_file_14 end macro; 
macro reg_file_15 : unsigned := RFtoISA_port_sig.reg_file_15 end macro; 
macro reg_file_16 : unsigned := RFtoISA_port_sig.reg_file_16 end macro; 
macro reg_file_17 : unsigned := RFtoISA_port_sig.reg_file_17 end macro; 
macro reg_file_18 : unsigned := RFtoISA_port_sig.reg_file_18 end macro; 
macro reg_file_19 : unsigned := RFtoISA_port_sig.reg_file_19 end macro; 
macro reg_file_20 : unsigned := RFtoISA_port_sig.reg_file_20 end macro; 
macro reg_file_21 : unsigned := RFtoISA_port_sig.reg_file_21 end macro; 
macro reg_file_22 : unsigned := RFtoISA_port_sig.reg_file_22 end macro; 
macro reg_file_23 : unsigned := RFtoISA_port_sig.reg_file_23 end macro; 
macro reg_file_24 : unsigned := RFtoISA_port_sig.reg_file_24 end macro; 
macro reg_file_25 : unsigned := RFtoISA_port_sig.reg_file_25 end macro; 
macro reg_file_26 : unsigned := RFtoISA_port_sig.reg_file_26 end macro; 
macro reg_file_27 : unsigned := RFtoISA_port_sig.reg_file_27 end macro; 


-- STATES -- 
--macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: RFtoISA_port_sig_reg_file_01 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_02 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_06 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_07 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_08 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_09 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_10 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_11 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_12 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_13 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_14 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_15 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_16 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_17 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_18 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_19 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_20 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_21 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_22 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_23 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_24 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_25 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_26 = resize(0,32);
	 at t: RFtoISA_port_sig_reg_file_27 = resize(0,32);
	 at t: reg_file_01 = resize(0,32);
	 at t: reg_file_02 = resize(0,32);
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
end property;


property run_0_write_0 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	reg_file_27_at_t = reg_file_27@t;
assume: 
	 at t: run_0;
	 at t: not(ISAtoRF_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
end property;

property run_0_write_1 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	reg_file_27_at_t = reg_file_27@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(0,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
end property;

property run_0_write_2 is
dependencies: no_reset;
freeze:
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(1,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
end property;

property run_0_write_3 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(2,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_4 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(6,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_5 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(7,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_6 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(8,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_7 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(9,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_8 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(10,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_9 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(11,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_file_11 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_10 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(12,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_11 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(13,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_12 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(14,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_13 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(15,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_14 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(16,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_16 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_15 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(17,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_17 = ISAtoRF_port_sig_dstData_at_t;
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
end property;

property run_0_write_16 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(18,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_18 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_19 = reg_file_19_at_t;
	 at t+1: reg_file_20 = reg_file_20_at_t;
	 at t+1: reg_file_21 = reg_file_21_at_t;
	 at t+1: reg_file_22 = reg_file_22_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_17 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(19,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_19 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_20 = reg_file_20_at_t;
	 at t+1: reg_file_21 = reg_file_21_at_t;
	 at t+1: reg_file_22 = reg_file_22_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_18 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(20,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_20 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_21 = reg_file_21_at_t;
	 at t+1: reg_file_22 = reg_file_22_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_19 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(21,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_21 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_22 = reg_file_22_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_20 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(22,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_22 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_21 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(23,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_23 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_22 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(24,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_24 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_23 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(25,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_25 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_24 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: (ISAtoRF_port_sig_dst = resize(26,32));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_26 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
end property;

property run_0_write_25 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	ISAtoRF_port_sig_dstData_at_t = ISAtoRF_port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: ISAtoRF_port_sync;
	 at t: not((ISAtoRF_port_sig_dst = resize(0,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(1,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(2,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(6,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(7,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(8,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(9,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(10,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(11,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(12,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(13,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(14,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(15,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(16,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(17,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(18,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(19,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(20,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(21,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(22,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(23,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(24,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(25,32)));
	 at t: not((ISAtoRF_port_sig_dst = resize(26,32)));
	 at t: ISAtoRF_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: RFtoISA_port_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: RFtoISA_port_sig_reg_file_27 = ISAtoRF_port_sig_dstData_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
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
	 at t+1: reg_file_27 = ISAtoRF_port_sig_dstData_at_t;
end property;
