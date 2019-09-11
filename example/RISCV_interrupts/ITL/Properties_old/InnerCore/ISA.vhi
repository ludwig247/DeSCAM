--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro fromMemoryPort_notify :  boolean  := fromMemoryPort_notify end macro;
--macro fromMemoryPort_sync   :  boolean  := fromMemoryPort_sync end macro;
--macro isa_syscall_Port_notify :  boolean  := isa_syscall_Port_notify end macro;
--macro isa_syscall_Port_sync   :  boolean  := isa_syscall_Port_sync end macro;
--macro syscall_isa_Port_notify :  boolean  := syscall_isa_Port_notify end macro;
--macro syscall_isa_Port_sync   :  boolean  := syscall_isa_Port_sync end macro;
--macro toMemoryPort_notify :  boolean  := toMemoryPort_notify end macro;
--macro toMemoryPort_sync   :  boolean  := toMemoryPort_sync end macro;
--macro toRegsPort_notify :  boolean  := toRegsPort_notify end macro;


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
macro isa_syscall_Port_sig : bool := isa_syscall_Port end macro;
macro mip_isa_Port_sig : unsigned := mip_isa_Port end macro;
macro syscall_isa_Port_sig : bool := syscall_isa_Port end macro;
macro toMemoryPort_sig_addrIn : unsigned := toMemoryPort.addrIn end macro;
macro toMemoryPort_sig_dataIn : unsigned := toMemoryPort.dataIn end macro;
macro toMemoryPort_sig_mask : ME_MaskType := toMemoryPort.mask end macro;
macro toMemoryPort_sig_req : ME_AccessType := toMemoryPort.req end macro;
macro toRegsPort_sig_dst : unsigned := toRegsPort.dst end macro;
macro toRegsPort_sig_dstData : unsigned := toRegsPort.dstData end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;





-- VISIBLE REGISTERS --
macro csrfile_mcause : unsigned := csr_mcause_signal end macro;
macro csrfile_mepc : unsigned := csr_mepc_signal end macro;
macro csrfile_mie : unsigned := csr_mie_signal end macro;
macro csrfile_mip : unsigned := csr_mip_signal end macro;
macro csrfile_mstatus : unsigned := csr_mstatus_signal end macro;
macro csrfile_mtvec : unsigned := csr_mtvec_signal end macro;
macro pcReg : unsigned := pcReg_signal end macro;
macro regfileWrite_dst     : unsigned := toRegsPort.dst     end macro;
macro regfileWrite_dstData : unsigned := toRegsPort.dstData end macro;
macro toMemoryData_addrIn : unsigned := toMemoryPort.addrIn end macro;
macro toMemoryData_dataIn : unsigned := toMemoryPort.dataIn end macro;
macro toMemoryData_mask : ME_MaskType := toMemoryPort.mask end macro;
macro toMemoryData_req : ME_AccessType := toMemoryPort.req end macro;


-- STATES --
macro execute_6 : boolean := (section = store) end macro;
macro execute_16 : boolean := (section = load1) end macro;
macro execute_17 : boolean := (section = load2) end macro;
macro execute_28 : boolean := (section = syscall1) end macro;
macro execute_29 : boolean := (section = syscall2) end macro;
macro fetch_30 : boolean := (section = fetch) end macro;
macro fetch_31 : boolean := (section = execute) end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_30;
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
	 at t: syscall_isa_Port_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;




property wait_execute_6 is
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
	 at t: execute_6;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_6;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_16 is
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
	 at t: execute_16;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_16;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_17 is
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
	 at t: execute_17;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_17;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_28 is
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
	 at t: execute_28;
	 at t: not(isa_syscall_Port_sync);
prove:
	 at t+1: execute_28;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_29 is
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
	 at t: execute_29;
	 at t: not(syscall_isa_Port_sync);
prove:
	 at t+1: execute_29;
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
	 at t+1: syscall_isa_Port_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_30 is
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
	 at t: fetch_30;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: fetch_30;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_31 is
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
	 at t: fetch_31;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: fetch_31;
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
	 at t+1: syscall_isa_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;