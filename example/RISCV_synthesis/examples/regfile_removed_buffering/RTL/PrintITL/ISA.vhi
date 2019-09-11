-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro MEtoCO_port_notify :  boolean  := end macro; 
--macro MEtoCO_port_sync   :  boolean  := end macro; 
--macro COtoME_port_notify :  boolean  := end macro; 
--macro COtoME_port_sync   :  boolean  := end macro; 
--macro ISAtoRF_port_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro MEtoCO_port_sig_loadedData : unsigned := MEtoCO_port_sig.loadedData end macro; 
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
macro COtoME_port_sig_addrIn : unsigned := COtoME_port_sig.addrIn end macro; 
macro COtoME_port_sig_dataIn : unsigned := COtoME_port_sig.dataIn end macro; 
macro COtoME_port_sig_mask : ME_MaskType := COtoME_port_sig.mask end macro; 
macro COtoME_port_sig_req : ME_AccessType := COtoME_port_sig.req end macro; 
macro ISAtoRF_port_sig_dst : unsigned := ISAtoRF_port_sig.dst end macro; 
macro ISAtoRF_port_sig_dstData : unsigned := ISAtoRF_port_sig.dstData end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
--macro pcReg : unsigned := end macro; 
macro toMemoryData_addrIn : unsigned := toMemoryData.addrIn end macro; 
macro toMemoryData_dataIn : unsigned := toMemoryData.dataIn end macro; 
macro toMemoryData_mask : ME_MaskType := toMemoryData.mask end macro; 
macro toMemoryData_req : ME_AccessType := toMemoryData.req end macro; 
macro toRegsData_dst : unsigned := toRegsData.dst end macro; 


-- STATES -- 
--macro execute_6 : boolean := true end macro;
--macro execute_7 : boolean := true end macro;
--macro execute_10 : boolean := true end macro;
--macro fetch_15 : boolean := true end macro;
--macro fetch_16 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_15;
	 at t: pcReg = resize(0,32);
	 at t: toMemoryData_addrIn = resize(0,32);
	 at t: toMemoryData_dataIn = resize(0,32);
	 at t: toMemoryData_mask = MT_W;
	 at t: toMemoryData_req = ME_RD;
	 at t: COtoME_port_sig_addrIn = resize(0,32);
	 at t: COtoME_port_sig_dataIn = resize(0,32);
	 at t: COtoME_port_sig_mask = MT_W;
	 at t: COtoME_port_sig_req = ME_RD;
	 at t: toRegsData_dst = resize(0,32);
	 at t: MEtoCO_port_notify = false;
	 at t: COtoME_port_notify = true;
	 at t: ISAtoRF_port_notify = false;
end property;


property execute_6_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_6;
	 at t: COtoME_port_sync;
prove:
	 at t_end: execute_7;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property execute_7_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_7;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 at t_end: ISAtoRF_port_sig_dst = toRegsData_dst_at_t;
	 at t_end: ISAtoRF_port_sig_dstData = MEtoCO_port_sig_loadedData_at_t;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property execute_10_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_10;
	 at t: COtoME_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_15_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_15;
	 at t: COtoME_port_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_16_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_R));
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_16_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_U);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), getImmediate(MEtoCO_port_sig_loadedData_at_t), pcReg_at_t);
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property fetch_16_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_J);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: toMemoryData_addrIn = (pcReg_at_t + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (pcReg_at_t + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dstData = (pcReg_at_t + 4)(31 downto 0);
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property fetch_16_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)) + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: toMemoryData_addrIn = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)) + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)) + getImmediate(MEtoCO_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dstData = (pcReg_at_t + 4)(31 downto 0);
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property fetch_16_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_B);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31))), MEtoCO_port_sig_loadedData_at_t, pcReg_at_t);
	 at t_end: toMemoryData_addrIn = getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31))), MEtoCO_port_sig_loadedData_at_t, pcReg_at_t);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31))), MEtoCO_port_sig_loadedData_at_t, pcReg_at_t);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_16_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_B));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_I_L);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: execute_6;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: toMemoryData_addrIn = getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), getImmediate(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = getMemoryMask(getInstrType(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), getImmediate(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = getMemoryMask(getInstrType(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_16_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_L));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_S);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: execute_10;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: toMemoryData_addrIn = getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), getImmediate(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: toMemoryData_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31));
	 at t_end: toMemoryData_mask = getMemoryMask(getInstrType(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: toMemoryData_req = ME_WR;
	 at t_end: COtoME_port_sig_addrIn = getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), getImmediate(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: COtoME_port_sig_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31));
	 at t_end: COtoME_port_sig_mask = getMemoryMask(getInstrType(MEtoCO_port_sig_loadedData_at_t));
	 at t_end: COtoME_port_sig_req = ME_WR;
	 at t_end: toRegsData_dst = toRegsData_dst_at_t;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
end property;

property fetch_16_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_S));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_I_I);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), getImmediate(MEtoCO_port_sig_loadedData_at_t));
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property fetch_16_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCO_port_sig_loadedData_at_t = MEtoCO_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_16;
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEtoCO_port_sig_loadedData) = ENC_I_I));
	 at t: (getEncType(MEtoCO_port_sig_loadedData) = ENC_R);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: fetch_15;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: COtoME_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: COtoME_port_sig_dataIn = 0;
	 at t_end: COtoME_port_sig_mask = MT_W;
	 at t_end: COtoME_port_sig_req = ME_RD;
	 at t_end: toRegsData_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dst = ((shift_right(MEtoCO_port_sig_loadedData_at_t,7)) and 31);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,15)) and 31)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t, ((shift_right(MEtoCO_port_sig_loadedData_at_t,20)) and 31)));
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
end property;

property wait_execute_6 is
dependencies: no_reset;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_6;
	 at t: not(COtoME_port_sync);
prove:
	 at t+1: execute_6;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: COtoME_port_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: COtoME_port_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: COtoME_port_sig_mask = toMemoryData_mask_at_t;
	 at t+1: COtoME_port_sig_req = toMemoryData_req_at_t;
	 at t+1: toRegsData_dst = toRegsData_dst_at_t;
	 at t+1: MEtoCO_port_notify = false;
	 at t+1: COtoME_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
end property;

property wait_execute_7 is
dependencies: no_reset;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_7;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: execute_7;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: toRegsData_dst = toRegsData_dst_at_t;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: COtoME_port_notify = false;
	 at t+1: ISAtoRF_port_notify = false;
end property;

property wait_execute_10 is
dependencies: no_reset;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: execute_10;
	 at t: not(COtoME_port_sync);
prove:
	 at t+1: execute_10;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: COtoME_port_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: COtoME_port_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: COtoME_port_sig_mask = toMemoryData_mask_at_t;
	 at t+1: COtoME_port_sig_req = toMemoryData_req_at_t;
	 at t+1: toRegsData_dst = toRegsData_dst_at_t;
	 at t+1: MEtoCO_port_notify = false;
	 at t+1: COtoME_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
end property;

property wait_fetch_15 is
dependencies: no_reset;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_15;
	 at t: not(COtoME_port_sync);
prove:
	 at t+1: fetch_15;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: COtoME_port_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: COtoME_port_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: COtoME_port_sig_mask = toMemoryData_mask_at_t;
	 at t+1: COtoME_port_sig_req = toMemoryData_req_at_t;
	 at t+1: toRegsData_dst = toRegsData_dst_at_t;
	 at t+1: MEtoCO_port_notify = false;
	 at t+1: COtoME_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
end property;

property wait_fetch_16 is
dependencies: no_reset;
freeze:
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t,
	toRegsData_dst_at_t = toRegsData_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: fetch_16;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: toRegsData_dst = toRegsData_dst_at_t;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: COtoME_port_notify = false;
	 at t+1: ISAtoRF_port_notify = false;
end property;