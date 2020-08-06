--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
-- macro syscall_reg_Port_sync   :  boolean  := end macro;
-- macro toRegsPort_sync   :  boolean  := end macro;


-- DP SIGNALS -- 
macro fromRegsPort_sig_reg_file_01 : unsigned := fromRegsPort.reg_file_01 end macro;
macro fromRegsPort_sig_reg_file_02 : unsigned := fromRegsPort.reg_file_02 end macro;
macro fromRegsPort_sig_reg_file_03 : unsigned := fromRegsPort.reg_file_03 end macro;
macro fromRegsPort_sig_reg_file_04 : unsigned := fromRegsPort.reg_file_04 end macro;
macro fromRegsPort_sig_reg_file_05 : unsigned := fromRegsPort.reg_file_05 end macro;
macro fromRegsPort_sig_reg_file_06 : unsigned := fromRegsPort.reg_file_06 end macro;
macro fromRegsPort_sig_reg_file_07 : unsigned := fromRegsPort.reg_file_07 end macro;
macro fromRegsPort_sig_reg_file_08 : unsigned := fromRegsPort.reg_file_08 end macro;
macro fromRegsPort_sig_reg_file_09 : unsigned := fromRegsPort.reg_file_09 end macro;
macro fromRegsPort_sig_reg_file_10 : unsigned := fromRegsPort.reg_file_10 end macro;
macro fromRegsPort_sig_reg_file_11 : unsigned := fromRegsPort.reg_file_11 end macro;
macro fromRegsPort_sig_reg_file_12 : unsigned := fromRegsPort.reg_file_12 end macro;
macro fromRegsPort_sig_reg_file_13 : unsigned := fromRegsPort.reg_file_13 end macro;
macro fromRegsPort_sig_reg_file_14 : unsigned := fromRegsPort.reg_file_14 end macro;
macro fromRegsPort_sig_reg_file_15 : unsigned := fromRegsPort.reg_file_15 end macro;
macro fromRegsPort_sig_reg_file_16 : unsigned := fromRegsPort.reg_file_16 end macro;
macro fromRegsPort_sig_reg_file_17 : unsigned := fromRegsPort.reg_file_17 end macro;
macro fromRegsPort_sig_reg_file_18 : unsigned := fromRegsPort.reg_file_18 end macro;
macro fromRegsPort_sig_reg_file_19 : unsigned := fromRegsPort.reg_file_19 end macro;
macro fromRegsPort_sig_reg_file_20 : unsigned := fromRegsPort.reg_file_20 end macro;
macro fromRegsPort_sig_reg_file_21 : unsigned := fromRegsPort.reg_file_21 end macro;
macro fromRegsPort_sig_reg_file_22 : unsigned := fromRegsPort.reg_file_22 end macro;
macro fromRegsPort_sig_reg_file_23 : unsigned := fromRegsPort.reg_file_23 end macro;
macro fromRegsPort_sig_reg_file_24 : unsigned := fromRegsPort.reg_file_24 end macro;
macro fromRegsPort_sig_reg_file_25 : unsigned := fromRegsPort.reg_file_25 end macro;
macro fromRegsPort_sig_reg_file_26 : unsigned := fromRegsPort.reg_file_26 end macro;
macro fromRegsPort_sig_reg_file_27 : unsigned := fromRegsPort.reg_file_27 end macro;
macro fromRegsPort_sig_reg_file_28 : unsigned := fromRegsPort.reg_file_28 end macro;
macro fromRegsPort_sig_reg_file_29 : unsigned := fromRegsPort.reg_file_29 end macro;
macro fromRegsPort_sig_reg_file_30 : unsigned := fromRegsPort.reg_file_30 end macro;
macro fromRegsPort_sig_reg_file_31 : unsigned := fromRegsPort.reg_file_31 end macro;
macro reg_syscall_Port_sig_reg_file_10 : unsigned := fromRegsPort.reg_file_10 end macro;
macro reg_syscall_Port_sig_reg_file_11 : unsigned := fromRegsPort.reg_file_11 end macro;
macro reg_syscall_Port_sig_reg_file_12 : unsigned := fromRegsPort.reg_file_12 end macro;
macro reg_syscall_Port_sig_reg_file_17 : unsigned := fromRegsPort.reg_file_17 end macro;
macro syscall_reg_Port_sig_dst : unsigned := syscall_reg_Port.dst end macro;
macro syscall_reg_Port_sig_dstData : unsigned := syscall_reg_Port.dstData end macro;
macro toRegsPort_sig_dst : unsigned := toRegsPort.dst end macro;
macro toRegsPort_sig_dstData : unsigned := toRegsPort.dstData end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro reg_file_01 : unsigned := fromRegsPort.reg_file_01 end macro;
macro reg_file_02 : unsigned := fromRegsPort.reg_file_02 end macro;
macro reg_file_03 : unsigned := fromRegsPort.reg_file_03 end macro;
macro reg_file_04 : unsigned := fromRegsPort.reg_file_04 end macro;
macro reg_file_05 : unsigned := fromRegsPort.reg_file_05 end macro;
macro reg_file_06 : unsigned := fromRegsPort.reg_file_06 end macro;
macro reg_file_07 : unsigned := fromRegsPort.reg_file_07 end macro;
macro reg_file_08 : unsigned := fromRegsPort.reg_file_08 end macro;
macro reg_file_09 : unsigned := fromRegsPort.reg_file_09 end macro;
macro reg_file_10 : unsigned := fromRegsPort.reg_file_10 end macro;
macro reg_file_11 : unsigned := fromRegsPort.reg_file_11 end macro;
macro reg_file_12 : unsigned := fromRegsPort.reg_file_12 end macro;
macro reg_file_13 : unsigned := fromRegsPort.reg_file_13 end macro;
macro reg_file_14 : unsigned := fromRegsPort.reg_file_14 end macro;
macro reg_file_15 : unsigned := fromRegsPort.reg_file_15 end macro;
macro reg_file_16 : unsigned := fromRegsPort.reg_file_16 end macro;
macro reg_file_17 : unsigned := fromRegsPort.reg_file_17 end macro;
macro reg_file_18 : unsigned := fromRegsPort.reg_file_18 end macro;
macro reg_file_19 : unsigned := fromRegsPort.reg_file_19 end macro;
macro reg_file_20 : unsigned := fromRegsPort.reg_file_20 end macro;
macro reg_file_21 : unsigned := fromRegsPort.reg_file_21 end macro;
macro reg_file_22 : unsigned := fromRegsPort.reg_file_22 end macro;
macro reg_file_23 : unsigned := fromRegsPort.reg_file_23 end macro;
macro reg_file_24 : unsigned := fromRegsPort.reg_file_24 end macro;
macro reg_file_25 : unsigned := fromRegsPort.reg_file_25 end macro;
macro reg_file_26 : unsigned := fromRegsPort.reg_file_26 end macro;
macro reg_file_27 : unsigned := fromRegsPort.reg_file_27 end macro;
macro reg_file_28 : unsigned := fromRegsPort.reg_file_28 end macro;
macro reg_file_29 : unsigned := fromRegsPort.reg_file_29 end macro;
macro reg_file_30 : unsigned := fromRegsPort.reg_file_30 end macro;
macro reg_file_31 : unsigned := fromRegsPort.reg_file_31 end macro;


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: fromRegsPort_sig_reg_file_01 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_02 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_03 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_04 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_05 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_06 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_07 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_08 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_09 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_10 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_11 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_12 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_13 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_14 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_15 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_16 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_17 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_18 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_19 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_20 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_21 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_22 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_23 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_24 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_25 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_26 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_27 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_28 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_29 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_30 = resize(0,32);
	 at t: fromRegsPort_sig_reg_file_31 = resize(0,32);
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


property run_0_write_0 is
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
	 at t: run_0;
	 at t: not(toRegsPort_sync);
	 at t: not(syscall_reg_Port_sync);
	 at t: not(toRegsPort_sync);
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_1 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: syscall_reg_Port_sync;
	 at t: not(toRegsPort_sync);
	 at t: syscall_reg_Port_sync;
	 at t: not(toRegsPort_sync);
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_2 is
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
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(0,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_3 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(0,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_4 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(1,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_5 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(1,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_6 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(2,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_7 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(2,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_8 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(3,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_9 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(3,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_10 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(4,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_11 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(4,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_12 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(5,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_13 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(5,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_14 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(6,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_15 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(6,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_16 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(7,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_17 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(7,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_18 is
dependencies: no_reset;
freeze:
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(8,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_19 is
dependencies: no_reset;
freeze:
	reg_file_01_at_t = reg_file_01@t,
	reg_file_02_at_t = reg_file_02@t,
	reg_file_03_at_t = reg_file_03@t,
	reg_file_04_at_t = reg_file_04@t,
	reg_file_05_at_t = reg_file_05@t,
	reg_file_06_at_t = reg_file_06@t,
	reg_file_07_at_t = reg_file_07@t,
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(8,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_20 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(9,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_21 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(9,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_22 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(10,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_23 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(10,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_24 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(11,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_11 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_25 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(11,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_26 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(12,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_12 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_27 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(12,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_28 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(13,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_13 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_29 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(13,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_30 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(14,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_14 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_31 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(14,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_32 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(15,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_15 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_33 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(15,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_34 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(16,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_16 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_35 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(16,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = reg_file_15_at_t;
	 at t+1: reg_file_16 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_36 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(17,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_17 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = toRegsPort_sig_dstData_at_t;
end property;

property run_0_write_37 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(17,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = reg_file_15_at_t;
	 at t+1: reg_file_16 = reg_file_16_at_t;
	 at t+1: reg_file_17 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = toRegsPort_sig_dstData_at_t;
end property;

property run_0_write_38 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(18,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_18 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_39 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(18,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = reg_file_15_at_t;
	 at t+1: reg_file_16 = reg_file_16_at_t;
	 at t+1: reg_file_17 = reg_file_17_at_t;
	 at t+1: reg_file_18 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_40 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(19,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_19 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_41 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(19,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = reg_file_15_at_t;
	 at t+1: reg_file_16 = reg_file_16_at_t;
	 at t+1: reg_file_17 = reg_file_17_at_t;
	 at t+1: reg_file_18 = reg_file_18_at_t;
	 at t+1: reg_file_19 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_42 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(20,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_20 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_43 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(20,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_file_13 = reg_file_13_at_t;
	 at t+1: reg_file_14 = reg_file_14_at_t;
	 at t+1: reg_file_15 = reg_file_15_at_t;
	 at t+1: reg_file_16 = reg_file_16_at_t;
	 at t+1: reg_file_17 = reg_file_17_at_t;
	 at t+1: reg_file_18 = reg_file_18_at_t;
	 at t+1: reg_file_19 = reg_file_19_at_t;
	 at t+1: reg_file_20 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_44 is
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
	reg_file_22_at_t = reg_file_22@t,
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(21,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_21 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_45 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(21,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_21 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_46 is
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
	reg_file_23_at_t = reg_file_23@t,
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(22,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_22 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_47 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(22,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_22 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_23 = reg_file_23_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_48 is
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
	reg_file_24_at_t = reg_file_24@t,
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(23,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_23 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_49 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(23,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_23 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_24 = reg_file_24_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_50 is
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
	reg_file_25_at_t = reg_file_25@t,
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(24,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_24 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_51 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(24,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_24 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_25 = reg_file_25_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_52 is
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
	reg_file_26_at_t = reg_file_26@t,
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(25,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_25 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_53 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(25,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_25 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_26 = reg_file_26_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_54 is
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
	reg_file_27_at_t = reg_file_27@t,
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(26,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_26 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_55 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(26,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_26 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_27 = reg_file_27_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_56 is
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
	reg_file_28_at_t = reg_file_28@t,
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(27,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_27 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_57 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(27,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_27 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_28 = reg_file_28_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_58 is
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
	reg_file_29_at_t = reg_file_29@t,
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(28,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_28 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_59 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(28,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_28 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_29 = reg_file_29_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_60 is
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
	reg_file_30_at_t = reg_file_30@t,
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(29,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_29 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_61 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(29,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_29 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_30 = reg_file_30_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_62 is
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
	reg_file_31_at_t = reg_file_31@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: (toRegsPort_sig_dst = resize(30,32));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
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
	 at t+1: reg_file_30 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_63 is
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
	reg_file_31_at_t = reg_file_31@t,
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: (toRegsPort_sig_dst = resize(30,32));
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = toRegsPort_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_30 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_31 = reg_file_31_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_64 is
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
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: not((toRegsPort_sig_dst = resize(0,32)));
	 at t: not((toRegsPort_sig_dst = resize(1,32)));
	 at t: not((toRegsPort_sig_dst = resize(2,32)));
	 at t: not((toRegsPort_sig_dst = resize(3,32)));
	 at t: not((toRegsPort_sig_dst = resize(4,32)));
	 at t: not((toRegsPort_sig_dst = resize(5,32)));
	 at t: not((toRegsPort_sig_dst = resize(6,32)));
	 at t: not((toRegsPort_sig_dst = resize(7,32)));
	 at t: not((toRegsPort_sig_dst = resize(8,32)));
	 at t: not((toRegsPort_sig_dst = resize(9,32)));
	 at t: not((toRegsPort_sig_dst = resize(10,32)));
	 at t: not((toRegsPort_sig_dst = resize(11,32)));
	 at t: not((toRegsPort_sig_dst = resize(12,32)));
	 at t: not((toRegsPort_sig_dst = resize(13,32)));
	 at t: not((toRegsPort_sig_dst = resize(14,32)));
	 at t: not((toRegsPort_sig_dst = resize(15,32)));
	 at t: not((toRegsPort_sig_dst = resize(16,32)));
	 at t: not((toRegsPort_sig_dst = resize(17,32)));
	 at t: not((toRegsPort_sig_dst = resize(18,32)));
	 at t: not((toRegsPort_sig_dst = resize(19,32)));
	 at t: not((toRegsPort_sig_dst = resize(20,32)));
	 at t: not((toRegsPort_sig_dst = resize(21,32)));
	 at t: not((toRegsPort_sig_dst = resize(22,32)));
	 at t: not((toRegsPort_sig_dst = resize(23,32)));
	 at t: not((toRegsPort_sig_dst = resize(24,32)));
	 at t: not((toRegsPort_sig_dst = resize(25,32)));
	 at t: not((toRegsPort_sig_dst = resize(26,32)));
	 at t: not((toRegsPort_sig_dst = resize(27,32)));
	 at t: not((toRegsPort_sig_dst = resize(28,32)));
	 at t: not((toRegsPort_sig_dst = resize(29,32)));
	 at t: not((toRegsPort_sig_dst = resize(30,32)));
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
	 at t: toRegsPort_sync;
	 at t: not(syscall_reg_Port_sync);
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = toRegsPort_sig_dstData_at_t;
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
	 at t+1: reg_file_31 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = reg_file_10_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;

property run_0_write_65 is
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
	syscall_reg_Port_sig_dstData_at_t = syscall_reg_Port_sig_dstData@t,
	toRegsPort_sig_dstData_at_t = toRegsPort_sig_dstData@t;
assume: 
	 at t: run_0;
	 at t: toRegsPort_sync;
	 at t: not((toRegsPort_sig_dst = resize(0,32)));
	 at t: not((toRegsPort_sig_dst = resize(1,32)));
	 at t: not((toRegsPort_sig_dst = resize(2,32)));
	 at t: not((toRegsPort_sig_dst = resize(3,32)));
	 at t: not((toRegsPort_sig_dst = resize(4,32)));
	 at t: not((toRegsPort_sig_dst = resize(5,32)));
	 at t: not((toRegsPort_sig_dst = resize(6,32)));
	 at t: not((toRegsPort_sig_dst = resize(7,32)));
	 at t: not((toRegsPort_sig_dst = resize(8,32)));
	 at t: not((toRegsPort_sig_dst = resize(9,32)));
	 at t: not((toRegsPort_sig_dst = resize(10,32)));
	 at t: not((toRegsPort_sig_dst = resize(11,32)));
	 at t: not((toRegsPort_sig_dst = resize(12,32)));
	 at t: not((toRegsPort_sig_dst = resize(13,32)));
	 at t: not((toRegsPort_sig_dst = resize(14,32)));
	 at t: not((toRegsPort_sig_dst = resize(15,32)));
	 at t: not((toRegsPort_sig_dst = resize(16,32)));
	 at t: not((toRegsPort_sig_dst = resize(17,32)));
	 at t: not((toRegsPort_sig_dst = resize(18,32)));
	 at t: not((toRegsPort_sig_dst = resize(19,32)));
	 at t: not((toRegsPort_sig_dst = resize(20,32)));
	 at t: not((toRegsPort_sig_dst = resize(21,32)));
	 at t: not((toRegsPort_sig_dst = resize(22,32)));
	 at t: not((toRegsPort_sig_dst = resize(23,32)));
	 at t: not((toRegsPort_sig_dst = resize(24,32)));
	 at t: not((toRegsPort_sig_dst = resize(25,32)));
	 at t: not((toRegsPort_sig_dst = resize(26,32)));
	 at t: not((toRegsPort_sig_dst = resize(27,32)));
	 at t: not((toRegsPort_sig_dst = resize(28,32)));
	 at t: not((toRegsPort_sig_dst = resize(29,32)));
	 at t: not((toRegsPort_sig_dst = resize(30,32)));
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
	 at t: toRegsPort_sync;
	 at t: syscall_reg_Port_sync;
prove:
	 at t+1: run_0;
	 at t+1: fromRegsPort_sig_reg_file_01 = reg_file_01_at_t;
	 at t+1: fromRegsPort_sig_reg_file_02 = reg_file_02_at_t;
	 at t+1: fromRegsPort_sig_reg_file_03 = reg_file_03_at_t;
	 at t+1: fromRegsPort_sig_reg_file_04 = reg_file_04_at_t;
	 at t+1: fromRegsPort_sig_reg_file_05 = reg_file_05_at_t;
	 at t+1: fromRegsPort_sig_reg_file_06 = reg_file_06_at_t;
	 at t+1: fromRegsPort_sig_reg_file_07 = reg_file_07_at_t;
	 at t+1: fromRegsPort_sig_reg_file_08 = reg_file_08_at_t;
	 at t+1: fromRegsPort_sig_reg_file_09 = reg_file_09_at_t;
	 at t+1: fromRegsPort_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: fromRegsPort_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: fromRegsPort_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: fromRegsPort_sig_reg_file_13 = reg_file_13_at_t;
	 at t+1: fromRegsPort_sig_reg_file_14 = reg_file_14_at_t;
	 at t+1: fromRegsPort_sig_reg_file_15 = reg_file_15_at_t;
	 at t+1: fromRegsPort_sig_reg_file_16 = reg_file_16_at_t;
	 at t+1: fromRegsPort_sig_reg_file_17 = reg_file_17_at_t;
	 at t+1: fromRegsPort_sig_reg_file_18 = reg_file_18_at_t;
	 at t+1: fromRegsPort_sig_reg_file_19 = reg_file_19_at_t;
	 at t+1: fromRegsPort_sig_reg_file_20 = reg_file_20_at_t;
	 at t+1: fromRegsPort_sig_reg_file_21 = reg_file_21_at_t;
	 at t+1: fromRegsPort_sig_reg_file_22 = reg_file_22_at_t;
	 at t+1: fromRegsPort_sig_reg_file_23 = reg_file_23_at_t;
	 at t+1: fromRegsPort_sig_reg_file_24 = reg_file_24_at_t;
	 at t+1: fromRegsPort_sig_reg_file_25 = reg_file_25_at_t;
	 at t+1: fromRegsPort_sig_reg_file_26 = reg_file_26_at_t;
	 at t+1: fromRegsPort_sig_reg_file_27 = reg_file_27_at_t;
	 at t+1: fromRegsPort_sig_reg_file_28 = reg_file_28_at_t;
	 at t+1: fromRegsPort_sig_reg_file_29 = reg_file_29_at_t;
	 at t+1: fromRegsPort_sig_reg_file_30 = reg_file_30_at_t;
	 at t+1: fromRegsPort_sig_reg_file_31 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_file_01 = reg_file_01_at_t;
	 at t+1: reg_file_02 = reg_file_02_at_t;
	 at t+1: reg_file_03 = reg_file_03_at_t;
	 at t+1: reg_file_04 = reg_file_04_at_t;
	 at t+1: reg_file_05 = reg_file_05_at_t;
	 at t+1: reg_file_06 = reg_file_06_at_t;
	 at t+1: reg_file_07 = reg_file_07_at_t;
	 at t+1: reg_file_08 = reg_file_08_at_t;
	 at t+1: reg_file_09 = reg_file_09_at_t;
	 at t+1: reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
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
	 at t+1: reg_file_31 = toRegsPort_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_10 = syscall_reg_Port_sig_dstData_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_11 = reg_file_11_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_12 = reg_file_12_at_t;
	 at t+1: reg_syscall_Port_sig_reg_file_17 = reg_file_17_at_t;
end property;