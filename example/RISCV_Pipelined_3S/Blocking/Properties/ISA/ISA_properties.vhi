--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_16;
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_W;
	 at t: memoryAccess_req = ME_RD;
	 at t: pcReg = resize(0,32);
	 at t: temp_dst = resize(0,32);
	 at t: toMemoryPort_sig_addrIn = resize(0,32);
	 at t: toMemoryPort_sig_dataIn = resize(0,32);
	 at t: toMemoryPort_sig_mask = MT_W;
	 at t: toMemoryPort_sig_req = ME_RD;
	 at t: fromMemoryPort_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property execute_4_write_0 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_4;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_5;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: temp_dst = temp_dst_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_5_read_1 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_5;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = pcReg_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: temp_dst = temp_dst_at_t;
	 at t_end: toMemoryPort_sig_addrIn = pcReg_at_t;
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_11_write_2 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_11;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_12;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: temp_dst = temp_dst_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_12_read_3 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_12;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = pcReg_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: temp_dst = 0;
	 at t_end: toMemoryPort_sig_addrIn = pcReg_at_t;
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = temp_dst_at_t;
	 at t_end: toRegsPort_sig_dstData = fromMemoryPort_sig_loadedData_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_16_write_4 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_16;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: fetch_17;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: temp_dst = temp_dst_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_5 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_6 is
dependencies: no_reset, no_wait;
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
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_R);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
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

property fetch_17_read_7 is
dependencies: no_reset, no_wait;
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
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_B);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: temp_dst = temp_dst_at_t;
	 at t_end: toMemoryPort_sig_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_8 is
dependencies: no_reset, no_wait;
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
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_S);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_4;
	 at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: memoryAccess_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: memoryAccess_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: memoryAccess_req = ME_WR;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_req = ME_WR;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_9 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_U);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
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

property fetch_17_read_10 is
dependencies: no_reset, no_wait;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_J);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
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

property fetch_17_read_11 is
dependencies: no_reset, no_wait;
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
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
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

property fetch_17_read_12 is
dependencies: no_reset, no_wait;
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
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_11;
	 at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: temp_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_13 is
dependencies: no_reset, no_wait;
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
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: temp_dst = temp_dst_at_t;
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

property wait_execute_4 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_4;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_4;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_5 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_5;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_5;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_11 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_11;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_11;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_12 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: execute_12;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_12;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_16 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: fetch_16;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_17 is
dependencies: no_reset, no_wait;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	temp_dst_at_t = temp_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: fetch_17;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: temp_dst = temp_dst_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;
