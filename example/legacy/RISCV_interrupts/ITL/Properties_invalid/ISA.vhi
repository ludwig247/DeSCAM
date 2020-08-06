-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro fromMemoryPort_notify :  boolean  := end macro; 
macro fromMemoryPort_sync   :  boolean  := end macro; 
macro isa_syscall_Port_notify :  boolean  := end macro; 
macro isa_syscall_Port_sync   :  boolean  := end macro; 
macro mip_isa_Port_notify :  boolean  := end macro; 
macro mip_isa_Port_sync   :  boolean  := end macro; 
macro syscall_isa_Port_notify :  boolean  := end macro; 
macro syscall_isa_Port_sync   :  boolean  := end macro; 
macro toMemoryPort_notify :  boolean  := end macro; 
macro toMemoryPort_sync   :  boolean  := end macro; 
macro toRegsPort_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro fromMemoryPort_sig_loadedData : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_01 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_02 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_03 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_04 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_05 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_06 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_07 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_08 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_09 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_10 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_11 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_12 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_13 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_14 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_15 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_16 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_17 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_18 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_19 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_20 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_21 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_22 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_23 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_24 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_25 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_26 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_27 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_28 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_29 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_30 : unsigned := end macro; 
macro fromRegsPort_sig_reg_file_31 : unsigned := end macro; 
macro isa_syscall_Port_sig : bool := end macro; 
macro mip_isa_Port_sig : unsigned := end macro; 
macro syscall_isa_Port_sig : bool := end macro; 
macro toMemoryPort_sig_addrIn : unsigned := end macro; 
macro toMemoryPort_sig_dataIn : unsigned := end macro; 
macro toMemoryPort_sig_mask : ME_MaskType := end macro; 
macro toMemoryPort_sig_req : ME_AccessType := end macro; 
macro toRegsPort_sig_dst : unsigned := end macro; 
macro toRegsPort_sig_dstData : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro csrfile_mcause : unsigned := end macro; 
macro csrfile_mepc : unsigned := end macro; 
macro csrfile_mie : unsigned := end macro; 
macro csrfile_mip : unsigned := end macro; 
macro csrfile_mstatus : unsigned := end macro; 
macro csrfile_mtvec : unsigned := end macro; 
macro pcReg : unsigned := end macro; 
macro regfileWrite_dst : unsigned := end macro; 
macro regfileWrite_dstData : unsigned := end macro; 
macro toMemoryData_addrIn : unsigned := end macro; 
macro toMemoryData_dataIn : unsigned := end macro; 
macro toMemoryData_mask : ME_MaskType := end macro; 
macro toMemoryData_req : ME_AccessType := end macro; 


-- STATES -- 
macro execute_2 : boolean := true end macro;
macro execute_5 : boolean := true end macro;
macro execute_11 : boolean := true end macro;
macro execute_12 : boolean := true end macro;
macro execute_19 : boolean := true end macro;
macro execute_20 : boolean := true end macro;
macro fetch_21 : boolean := true end macro;
macro fetch_22 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_21;
	 at t: csrfile_mcause = resize(0,32);
	 at t: csrfile_mepc = resize(0,32);
	 at t: csrfile_mie = resize(0,32);
	 at t: csrfile_mip = resize(0,32);
	 at t: csrfile_mstatus = resize(0,32);
	 at t: csrfile_mtvec = resize(0,32);
	 at t: pcReg = resize(0,32);
	 at t: regfileWrite_dst = resize(0,32);
	 at t: regfileWrite_dstData = resize(0,32);
	 at t: toMemoryData_addrIn = resize(0,32);
	 at t: toMemoryData_dataIn = resize(0,32);
	 at t: toMemoryData_mask = MT_W;
	 at t: toMemoryData_req = ME_RD;
	 at t: toMemoryPort_sig_addrIn = resize(0,32);
	 at t: toMemoryPort_sig_dataIn = resize(0,32);
	 at t: toMemoryPort_sig_mask = MT_W;
	 at t: toMemoryPort_sig_req = ME_RD;
	 at t: fromMemoryPort_notify = false;
	 at t: isa_syscall_Port_notify = false;
	 at t: mip_isa_Port_notify = false;
	 at t: syscall_isa_Port_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property execute_2_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	mip_isa_Port_sig_at_t = mip_isa_Port_sig@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_2;
	 at t: mip_isa_Port_sync;
prove:
	 at t_end: fetch_21;
	 at t_end: csrfile_mcause = updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t);
	 at t_end: csrfile_mepc = updateMEPC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t),csrfile_mepc_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t,pcReg_at_t);
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = mip_isa_Port_sig_at_t;
	 at t_end: csrfile_mstatus = updateMSTATUS(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t);
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: toMemoryPort_sig_addrIn = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,mip_isa_Port_sig_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_2_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_2;
	 at t: not(mip_isa_Port_sync);
prove:
	 at t_end: fetch_21;
	 at t_end: csrfile_mcause = updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t);
	 at t_end: csrfile_mepc = updateMEPC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t),csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,pcReg_at_t);
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = updateMSTATUS(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t);
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = MT_W;
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: toMemoryPort_sig_addrIn = updatePC(updateMCAUSE(csrfile_mcause_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t),csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,pcReg_at_t);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_5_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_5;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_11_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_11;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_12;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_12_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_12;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = regfileWrite_dst_at_t;
	 at t_end: toRegsPort_sig_dstData = fromMemoryPort_sig_loadedData_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property execute_19_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_19;
	 at t: isa_syscall_Port_sync;
prove:
	 at t_end: execute_20;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end-1]: syscall_isa_Port_notify = false;
	 at t_end: syscall_isa_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_20_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_20;
	 at t: syscall_isa_Port_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_21_write_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_21;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: fetch_22;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_PRIV));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_PRIV);
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_ECALL));
	 at t: (getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_EBREAK);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_PRIV);
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_ECALL));
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_EBREAK));
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_MRET));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_PRIV);
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_ECALL));
	 at t: not((getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_EBREAK));
	 at t: (getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_MRET);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = 0;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = (csrfile_mstatus_at_t or 8);
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = csrfile_mepc_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_PRIV);
	 at t: (getPrivInstrType(fromMemoryPort_sig_loadedData) = INSTR_ECALL);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_19;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: isa_syscall_Port_sig = true;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_syscall_Port_notify = false;
	 at t_end: isa_syscall_Port_notify = true;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_R);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t)));
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_B);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = getBranchresult(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_S);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_5;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_req = ME_WR;
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_req = ME_WR;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_U);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getALUresult_U(fromMemoryPort_sig_loadedData_at_t,getImmediate(fromMemoryPort_sig_loadedData_at_t),pcReg_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getALUresult_U(fromMemoryPort_sig_loadedData_at_t,getImmediate(fromMemoryPort_sig_loadedData_at_t),pcReg_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_J);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig_loadedData_at_t)),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	 at t: fetch_22;
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
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryData_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_dataIn = 0;
	 at t_end: toMemoryData_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryData_req = ME_RD;
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)),getImmediate(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_22_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
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
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)) + getImmediate(fromMemoryPort_sig_loadedData_at_t))(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(836,32)));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
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
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(836,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_32 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_33 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_34 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_35 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(836,32)));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = csrfile_mip_at_t;
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_22_read_36 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_R));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_B));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_S));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_U));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_L));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(fromMemoryPort_sig_loadedData) = ENC_I_M));
	 at t: (getEncType(fromMemoryPort_sig_loadedData) = ENC_I_S);
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRW));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRS));
	 at t: not((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRC));
	 at t: (((getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRWI) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRSI)) or (getInstrType(fromMemoryPort_sig_loadedData) = INSTR_CSRRCI));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(768,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(772,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(773,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(833,32)));
	 at t: not((getImmediate(fromMemoryPort_sig_loadedData) = resize(834,32)));
	 at t: (getImmediate(fromMemoryPort_sig_loadedData) = resize(836,32));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_2;
	 at t_end: csrfile_mcause = csrfile_mcause_at_t;
	 at t_end: csrfile_mepc = csrfile_mepc_at_t;
	 at t_end: csrfile_mie = csrfile_mie_at_t;
	 at t_end: csrfile_mip = getCSRresult(getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t),getInstrType(fromMemoryPort_sig_loadedData_at_t),getRs1Addr(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t_end: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: regfileWrite_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t_end: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t_end: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t_end: toMemoryData_req = toMemoryData_req_at_t;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t);
	 at t_end: toRegsPort_sig_dstData = getCSR(csrfile_mcause_at_t,csrfile_mepc_at_t,csrfile_mie_at_t,csrfile_mip_at_t,csrfile_mstatus_at_t,csrfile_mtvec_at_t,fromMemoryPort_sig_loadedData_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_syscall_Port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
	 during[t+1, t_end]: syscall_isa_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property wait_execute_5 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_5;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_5;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: toMemoryPort_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryPort_sig_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_11 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_11;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_11;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: toMemoryPort_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryPort_sig_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_12 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_12;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_12;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_19 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_19;
	 at t: not(isa_syscall_Port_sync);
prove:
	 at t+1: execute_19;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: isa_syscall_Port_sig = true;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = true;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_20 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: execute_20;
	 at t: not(syscall_isa_Port_sync);
prove:
	 at t+1: execute_20;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_21 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_21;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: fetch_21;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: toMemoryPort_sig_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryPort_sig_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_22 is
dependencies: no_reset;
freeze:
	csrfile_mcause_at_t = csrfile_mcause@t,
	csrfile_mepc_at_t = csrfile_mepc@t,
	csrfile_mie_at_t = csrfile_mie@t,
	csrfile_mip_at_t = csrfile_mip@t,
	csrfile_mstatus_at_t = csrfile_mstatus@t,
	csrfile_mtvec_at_t = csrfile_mtvec@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t,
	toMemoryData_addrIn_at_t = toMemoryData_addrIn@t,
	toMemoryData_dataIn_at_t = toMemoryData_dataIn@t,
	toMemoryData_mask_at_t = toMemoryData_mask@t,
	toMemoryData_req_at_t = toMemoryData_req@t;
assume: 
	 at t: fetch_22;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: fetch_22;
	 at t+1: csrfile_mcause = csrfile_mcause_at_t;
	 at t+1: csrfile_mepc = csrfile_mepc_at_t;
	 at t+1: csrfile_mie = csrfile_mie_at_t;
	 at t+1: csrfile_mip = csrfile_mip_at_t;
	 at t+1: csrfile_mstatus = csrfile_mstatus_at_t;
	 at t+1: csrfile_mtvec = csrfile_mtvec_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryData_addrIn = toMemoryData_addrIn_at_t;
	 at t+1: toMemoryData_dataIn = toMemoryData_dataIn_at_t;
	 at t+1: toMemoryData_mask = toMemoryData_mask_at_t;
	 at t+1: toMemoryData_req = toMemoryData_req_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: isa_syscall_Port_notify = false;
	 at t+1: mip_isa_Port_notify = false;
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;