-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro fromMemoryPort_sync : boolean := end macro;
--macro toMemoryPort_sync : boolean := end macro;
--macro fromMemoryPort_notify : boolean := end macro;
--macro toMemoryPort_notify : boolean := end macro;
--macro toRegsPort_notify : boolean := end macro;


-- DP SIGNALS --
macro fromMemoryPort_sig_loadedData : unsigned := fromMemoryPort.loadedData end macro;
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
macro toMemoryPort_sig_addrIn : unsigned := toMemoryPort.addrIn end macro;
macro toMemoryPort_sig_dataIn : unsigned := toMemoryPort.dataIn end macro;
macro toMemoryPort_sig_mask : ME_MaskType := toMemoryPort.mask end macro;
macro toMemoryPort_sig_req : ME_AccessType := toMemoryPort.req end macro;
macro toRegsPort_sig_dst : unsigned := toRegsPort.dst end macro;
macro toRegsPort_sig_dstData : unsigned := toRegsPort.dstData end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro memoryAccess_addrIn : unsigned      := toMemoryPort.addrIn end macro;
macro memoryAccess_dataIn : unsigned      := toMemoryPort.dataIn end macro;
macro memoryAccess_mask   : ME_MaskType   := toMemoryPort.mask   end macro;
macro memoryAccess_req    : ME_AccessType := toMemoryPort.req    end macro;
macro pcReg : unsigned := IF_ISA/pcReg_signal end macro;
macro regfileWrite_dst     : unsigned := toRegsPort.dst     end macro;
macro regfileWrite_dstData : unsigned := toRegsPort.dstData end macro;


-- STATES --
macro state_5 : boolean := (IF_ISA/section = load1) end macro;
macro state_6 : boolean := (IF_ISA/section = load2) end macro;
macro state_1 : boolean := (IF_ISA/section = fetch) end macro;
macro state_2 : boolean := (IF_ISA/section = execute) end macro;
macro state_3 : boolean := (IF_ISA/section = store1) end macro;
macro state_4 : boolean := (IF_ISA/section = store2) end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_W;
	 at t: memoryAccess_req = ME_RD;
	 at t: pcReg = resize(0,32);
	 at t: regfileWrite_dst = resize(0,32);
	 at t: regfileWrite_dstData = resize(0,32);
	 at t: toMemoryPort_sig_addrIn = resize(0,32);
	 at t: toMemoryPort_sig_dataIn = resize(0,32);
	 at t: toMemoryPort_sig_mask = MT_W;
	 at t: toMemoryPort_sig_req = ME_RD;
	 at t: fromMemoryPort_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property state_5_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_5;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_6;
	at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	at t_end: memoryAccess_req = memoryAccess_req_at_t;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_6_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume:
	at t: state_6;
	at t: fromMemoryPort_sync;
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = fromMemoryPort_sig_loadedData_at_t;
	at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = regfileWrite_dst_at_t;
	at t_end: toRegsPort_sig_dstData = fromMemoryPort_sig_loadedData_at_t;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_1;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_2;
	at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	at t_end: memoryAccess_req = memoryAccess_req_at_t;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_R);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t)));
	at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t)));
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_B);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t_end: toMemoryPort_sig_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_2_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_S);
prove:
	at t_end: state_3;
	at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	at t_end: memoryAccess_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	at t_end: memoryAccess_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	at t_end: memoryAccess_req = ME_WR;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_req = ME_WR;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_2_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_U);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = getEncUALUresult(fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: toRegsPort_sig_dstData = getEncUALUresult(fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_2_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_J);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_addrIn = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_2_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_2_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L);
prove:
	at t_end: state_5;
	at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	at t_end: toMemoryPort_sig_req = ME_RD;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J);
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_addrIn = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end-1]: toRegsPort_notify = false;
	at t_end: toRegsPort_notify = true;
end property;


property state_2_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_2;
	at t: fromMemoryPort_sync;
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = pcReg_at_t;
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t_end: toMemoryPort_sig_addrIn = pcReg_at_t;
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_3_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_3;
	at t: toMemoryPort_sync;
prove:
	at t_end: state_4;
	at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	at t_end: memoryAccess_req = memoryAccess_req_at_t;
	at t_end: pcReg = pcReg_at_t;
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	during[t+1, t_end-1]: fromMemoryPort_notify = false;
	at t_end: fromMemoryPort_notify = true;
	during[t+1, t_end]: toMemoryPort_notify = false;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property state_4_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_4;
	at t: fromMemoryPort_sync;
prove:
	at t_end: state_1;
	at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: memoryAccess_dataIn = 0;
	at t_end: memoryAccess_mask = MT_W;
	at t_end: memoryAccess_req = ME_RD;
	at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	at t_end: toMemoryPort_sig_dataIn = 0;
	at t_end: toMemoryPort_sig_mask = MT_W;
	at t_end: toMemoryPort_sig_req = ME_RD;
	during[t+1, t_end]: fromMemoryPort_notify = false;
	during[t+1, t_end-1]: toMemoryPort_notify = false;
	at t_end: toMemoryPort_notify = true;
	during[t+1, t_end]: toRegsPort_notify = false;
end property;


property wait_state_5 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_5;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_5;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_6 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_6;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: state_6;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_1;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_1;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_2;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: state_2;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_3;
	at t: not(toMemoryPort_sync);
prove:
	at t+1: state_3;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	at t+1: fromMemoryPort_notify = false;
	at t+1: toMemoryPort_notify = true;
	at t+1: toRegsPort_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume:
	at t: state_4;
	at t: not(fromMemoryPort_sync);
prove:
	at t+1: state_4;
	at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	at t+1: memoryAccess_req = memoryAccess_req_at_t;
	at t+1: pcReg = pcReg_at_t;
	at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	at t+1: fromMemoryPort_notify = true;
	at t+1: toMemoryPort_notify = false;
	at t+1: toRegsPort_notify = false;
end property;