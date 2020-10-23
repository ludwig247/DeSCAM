-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro isa_mmu_notify :  boolean  := end macro; 
macro isa_mmu_sync   :  boolean  := end macro; 
macro mem_mmu_notify :  boolean  := end macro; 
macro mem_mmu_sync   :  boolean  := end macro; 
macro mmu_isa_notify :  boolean  := end macro; 
macro mmu_isa_sync   :  boolean  := end macro; 
macro mmu_mem_notify :  boolean  := end macro; 
macro mmu_mem_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro isa_mmu_sig_accesstype : MMUaccessType := end macro; 
macro isa_mmu_sig_data : unsigned := end macro; 
macro isa_mmu_sig_exception_in : unsigned := end macro; 
macro isa_mmu_sig_lrsc : LR_SC := end macro; 
macro isa_mmu_sig_mask : ME_MaskType := end macro; 
macro isa_mmu_sig_mstatus : unsigned := end macro; 
macro isa_mmu_sig_prv : unsigned := end macro; 
macro isa_mmu_sig_reset_lrsc : unsigned := end macro; 
macro isa_mmu_sig_satp : unsigned := end macro; 
macro isa_mmu_sig_v_addr : unsigned := end macro; 
macro mem_mmu_sig_loadedData : unsigned := end macro; 
macro mmu_isa_sig_data : unsigned := end macro; 
macro mmu_isa_sig_exception : unsigned := end macro; 
macro mmu_isa_sig_sc_success : unsigned := end macro; 
macro mmu_mem_sig_addrIn : unsigned := end macro; 
macro mmu_mem_sig_dataIn : unsigned := end macro; 
macro mmu_mem_sig_mask : ME_MaskType := end macro; 
macro mmu_mem_sig_req : ME_AccessType := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro i : unsigned := end macro; 
macro lr_sc_addr : unsigned := end macro; 
macro mem_req_addrIn : unsigned := end macro; 
macro mem_req_dataIn : unsigned := end macro; 
macro mem_req_mask : ME_MaskType := end macro; 
macro mem_req_req : ME_AccessType := end macro; 
macro returndata_data : unsigned := end macro; 
macro returndata_exception : unsigned := end macro; 
macro returndata_sc_success : unsigned := end macro; 
macro vm_request_accesstype : MMUaccessType := end macro; 
macro vm_request_data : unsigned := end macro; 
macro vm_request_exception_in : unsigned := end macro; 
macro vm_request_lrsc : LR_SC := end macro; 
macro vm_request_mask : ME_MaskType := end macro; 
macro vm_request_mstatus : unsigned := end macro; 
macro vm_request_prv : unsigned := end macro; 
macro vm_request_reset_lrsc : unsigned := end macro; 
macro vm_request_satp : unsigned := end macro; 
macro vm_request_v_addr : unsigned := end macro; 


-- STATES -- 
macro MEMORY_OP_0 : boolean := true end macro;
macro MEMORY_OP_1 : boolean := true end macro;
macro MEMORY_OP_2 : boolean := true end macro;
macro PTE_FETCH_3 : boolean := true end macro;
macro PTE_FETCH_4 : boolean := true end macro;
macro REQUEST_5 : boolean := true end macro;
macro RESPONSE_6 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: REQUEST_5;
	 at t: i = resize(0,32);
	 at t: lr_sc_addr = resize(0,32);
	 at t: mem_req_addrIn = resize(0,32);
	 at t: mem_req_dataIn = resize(0,32);
	 at t: mem_req_mask = MT_B;
	 at t: mem_req_req = ME_RD;
	 at t: returndata_data = resize(0,32);
	 at t: returndata_exception = resize(0,32);
	 at t: returndata_sc_success = resize(0,32);
	 at t: vm_request_accesstype = FETCH;
	 at t: vm_request_data = resize(0,32);
	 at t: vm_request_exception_in = resize(0,32);
	 at t: vm_request_lrsc = LR;
	 at t: vm_request_mask = MT_B;
	 at t: vm_request_mstatus = resize(0,32);
	 at t: vm_request_prv = resize(0,32);
	 at t: vm_request_reset_lrsc = resize(0,32);
	 at t: vm_request_satp = resize(0,32);
	 at t: vm_request_v_addr = resize(0,32);
	 at t: isa_mmu_notify = true;
	 at t: mem_mmu_notify = false;
	 at t: mmu_isa_notify = false;
	 at t: mmu_mem_notify = false;
end property;


property MEMORY_OP_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_0;
	 at t: (vm_request_exception_in = resize(0,32));
	 at t: mmu_mem_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,returndata_exception_at_t);
	 at t_end: mmu_isa_sig_sc_success = 1;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,returndata_exception_at_t);
	 at t_end: returndata_sc_success = 1;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property MEMORY_OP_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_0;
	 at t: not((vm_request_exception_in = resize(0,32)));
	 at t: mmu_mem_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = 1;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = 1;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property MEMORY_OP_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_1;
	 at t: mmu_mem_sync;
prove:
	 at t_end: MEMORY_OP_2;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = returndata_exception_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end-1]: mem_mmu_notify = false;
	 at t_end: mem_mmu_notify = true;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property MEMORY_OP_2_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_2;
	 at t: (vm_request_exception_in = resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = mem_mmu_sig_loadedData_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,returndata_exception_at_t);
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = mem_mmu_sig_loadedData_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,returndata_exception_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property MEMORY_OP_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_2;
	 at t: not((vm_request_exception_in = resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = mem_mmu_sig_loadedData_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = mem_mmu_sig_loadedData_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_3_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_3;
	 at t: mmu_mem_sync;
prove:
	 at t_end: PTE_FETCH_4;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = returndata_exception_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end-1]: mem_mmu_notify = false;
	 at t_end: mem_mmu_notify = true;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: ((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = ((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32))));
	 at t: not((vm_request_lrsc = SC));
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_0;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = vm_request_data_at_t;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_WR;
	 at t_end: mmu_mem_sig_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = vm_request_data_at_t;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_WR;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: ((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = (((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32))));
	 at t: not((vm_request_lrsc = SC));
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_0;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = vm_request_data_at_t;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_WR;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = vm_request_data_at_t;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_WR;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: ((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = ((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32))));
	 at t: (vm_request_lrsc = SC);
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_0;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = 0;
	 at t_end: mem_req_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = vm_request_data_at_t;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_WR;
	 at t_end: mmu_mem_sig_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = vm_request_data_at_t;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_WR;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: ((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = (((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32))));
	 at t: (vm_request_lrsc = SC);
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_0;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = 0;
	 at t_end: mem_req_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = vm_request_data_at_t;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_WR;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = vm_request_data_at_t;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_WR;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: not((vm_request_accesstype = STORE));
	 at t: not((vm_request_lrsc = LR));
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_1;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: not((vm_request_accesstype = STORE));
	 at t: not((vm_request_lrsc = LR));
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_1;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: not((vm_request_accesstype = STORE));
	 at t: (vm_request_lrsc = LR);
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_1;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = ((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: not((vm_request_accesstype = STORE));
	 at t: (vm_request_lrsc = LR);
	 at t: mem_mmu_sync;
prove:
	 at t_end: MEMORY_OP_1;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = vm_request_mask_at_t;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095));
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = vm_request_mask_at_t;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: (((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: PTE_FETCH_3;
	 at t_end: i = 0;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) + (((shift_right(vm_request_v_addr_at_t,12)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = MT_W;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) + (((shift_right(vm_request_v_addr_at_t,12)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = MT_W;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PTE_fault_check(vm_request_accesstype_at_t,i_at_t,vm_request_mstatus_at_t,vm_request_prv_at_t,mem_mmu_sig_loadedData_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property PTE_FETCH_4_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: not((PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32)));
	 at t: (vm_request_exception_in = resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,PTE_fault_check(vm_request_accesstype_at_t,i_at_t,vm_request_mstatus_at_t,vm_request_prv_at_t,mem_mmu_sig_loadedData_at_t));
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,PTE_fault_check(vm_request_accesstype_at_t,i_at_t,vm_request_mstatus_at_t,vm_request_prv_at_t,mem_mmu_sig_loadedData_at_t));
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: not((PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32)));
	 at t: not((vm_request_exception_in = resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: not((PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32)));
	 at t: not((vm_request_exception_in /= resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: not((PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32)));
	 at t: not((vm_request_exception_in /= resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: not((PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32)));
	 at t: (vm_request_exception_in /= resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: not((PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32)));
	 at t: (vm_request_exception_in /= resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: not(((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = ((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32)))));
	 at t: not((vm_request_exception_in /= resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = 0;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,PMA_check(((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4194304)) or (vm_request_v_addr_at_t and 4190208)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: returndata_sc_success = 0;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_mmu_sig_loadedData_at_t = mem_mmu_sig_loadedData@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: not(((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = (((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32)))));
	 at t: not((vm_request_exception_in /= resize(0,32)));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(vm_request_accesstype_at_t,PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = 0;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(vm_request_accesstype_at_t,PMA_check((((shift_left(mem_mmu_sig_loadedData_at_t,2)) and unsigned(-4096)) or (vm_request_v_addr_at_t and 4095)),vm_request_prv_at_t,vm_request_accesstype_at_t));
	 at t_end: returndata_sc_success = 0;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: (i > resize(0,32));
	 at t: (PMA_check(((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: not(((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = ((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4194304,32))) or (vm_request_v_addr and resize(4190208,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32)))));
	 at t: (vm_request_exception_in /= resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = 0;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = 0;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property PTE_FETCH_4_read_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: (PTE_fault_check(vm_request_accesstype,i,vm_request_mstatus,vm_request_prv,mem_mmu_sig_loadedData) = resize(0,32));
	 at t: not((((mem_mmu_sig_loadedData and resize(2,32)) = resize(0,32)) and ((mem_mmu_sig_loadedData and resize(8,32)) = resize(0,32))));
	 at t: not((i > resize(0,32)));
	 at t: (PMA_check((((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))),vm_request_prv,vm_request_accesstype) = resize(0,32));
	 at t: (vm_request_accesstype = STORE);
	 at t: not(((vm_request_lrsc /= SC) or (((vm_request_lrsc = SC) and (lr_sc_addr = (((shift_left(mem_mmu_sig_loadedData,resize(2,32))) and unsigned(resize(-4096,32))) or (vm_request_v_addr and resize(4095,32))))) and (vm_request_reset_lrsc = resize(0,32)))));
	 at t: (vm_request_exception_in /= resize(0,32));
	 at t: mem_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = vm_request_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = 0;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = vm_request_exception_in_at_t;
	 at t_end: returndata_sc_success = 0;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property REQUEST_5_read_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_prv_at_t = isa_mmu_sig_prv@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: not((((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH)));
	 at t: (((isa_mmu_sig_prv /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),isa_mmu_sig_prv,isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32)));
	 at t: isa_mmu_sync;
prove:
	 at t_end: PTE_FETCH_3;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = (((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = MT_W;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = MT_W;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),isa_mmu_sig_prv_at_t,isa_mmu_sig_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = isa_mmu_sig_prv_at_t;
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property REQUEST_5_read_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: (((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH));
	 at t: (((((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)) /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)),isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32)));
	 at t: isa_mmu_sync;
prove:
	 at t_end: PTE_FETCH_3;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = (((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mem_req_dataIn = 0;
	 at t_end: mem_req_mask = MT_W;
	 at t_end: mem_req_req = ME_RD;
	 at t_end: mmu_mem_sig_addrIn = (((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0);
	 at t_end: mmu_mem_sig_dataIn = 0;
	 at t_end: mmu_mem_sig_mask = MT_W;
	 at t_end: mmu_mem_sig_req = ME_RD;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3),isa_mmu_sig_accesstype_at_t);
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = ((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3);
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end-1]: mmu_mem_notify = false;
	 at t_end: mmu_mem_notify = true;
end property;

property REQUEST_5_read_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_prv_at_t = isa_mmu_sig_prv@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: not((((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH)));
	 at t: not((((isa_mmu_sig_prv /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),isa_mmu_sig_prv,isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32))));
	 at t: not((isa_mmu_sig_exception_in /= resize(0,32)));
	 at t: isa_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(isa_mmu_sig_accesstype_at_t,PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),isa_mmu_sig_prv_at_t,isa_mmu_sig_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(isa_mmu_sig_accesstype_at_t,PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),isa_mmu_sig_prv_at_t,isa_mmu_sig_accesstype_at_t));
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = isa_mmu_sig_prv_at_t;
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property REQUEST_5_read_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: (((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH));
	 at t: not((((((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)) /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)),isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32))));
	 at t: not((isa_mmu_sig_exception_in /= resize(0,32)));
	 at t: isa_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = errorType(isa_mmu_sig_accesstype_at_t,PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3),isa_mmu_sig_accesstype_at_t));
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = errorType(isa_mmu_sig_accesstype_at_t,PMA_check((((shift_left(isa_mmu_sig_satp_at_t,12)) and unsigned(-4096)) + (((shift_right(isa_mmu_sig_v_addr_at_t,22)) and 1023) * 4)(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3),isa_mmu_sig_accesstype_at_t));
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = ((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3);
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property REQUEST_5_read_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_prv_at_t = isa_mmu_sig_prv@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: not((((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH)));
	 at t: not((((isa_mmu_sig_prv /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),isa_mmu_sig_prv,isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32))));
	 at t: (isa_mmu_sig_exception_in /= resize(0,32));
	 at t: isa_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = isa_mmu_sig_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = isa_mmu_sig_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = isa_mmu_sig_prv_at_t;
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property REQUEST_5_read_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	isa_mmu_sig_accesstype_at_t = isa_mmu_sig_accesstype@t,
	isa_mmu_sig_data_at_t = isa_mmu_sig_data@t,
	isa_mmu_sig_exception_in_at_t = isa_mmu_sig_exception_in@t,
	isa_mmu_sig_lrsc_at_t = isa_mmu_sig_lrsc@t,
	isa_mmu_sig_mask_at_t = isa_mmu_sig_mask@t,
	isa_mmu_sig_mstatus_at_t = isa_mmu_sig_mstatus@t,
	isa_mmu_sig_reset_lrsc_at_t = isa_mmu_sig_reset_lrsc@t,
	isa_mmu_sig_satp_at_t = isa_mmu_sig_satp@t,
	isa_mmu_sig_v_addr_at_t = isa_mmu_sig_v_addr@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_sc_success_at_t = returndata_sc_success@t;
assume: 
	 at t: REQUEST_5;
	 at t: (((isa_mmu_sig_mstatus and resize(131072,32)) /= resize(0,32)) and (isa_mmu_sig_accesstype /= FETCH));
	 at t: not((((((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)) /= resize(3,32)) and (PMA_check((((shift_left(isa_mmu_sig_satp,resize(12,32))) and unsigned(resize(-4096,32))) + (((shift_right(isa_mmu_sig_v_addr,resize(22,32))) and resize(1023,32)) * resize(4,32))(31 downto 0))(31 downto 0),((shift_right(isa_mmu_sig_mstatus,resize(11,32))) and resize(3,32)),isa_mmu_sig_accesstype) = resize(0,32))) and (isa_mmu_sig_exception_in = resize(0,32))));
	 at t: (isa_mmu_sig_exception_in /= resize(0,32));
	 at t: isa_mmu_sync;
prove:
	 at t_end: RESPONSE_6;
	 at t_end: i = 1;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: mmu_isa_sig_data = returndata_data_at_t;
	 at t_end: mmu_isa_sig_exception = isa_mmu_sig_exception_in_at_t;
	 at t_end: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = isa_mmu_sig_exception_in_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = isa_mmu_sig_accesstype_at_t;
	 at t_end: vm_request_data = isa_mmu_sig_data_at_t;
	 at t_end: vm_request_exception_in = isa_mmu_sig_exception_in_at_t;
	 at t_end: vm_request_lrsc = isa_mmu_sig_lrsc_at_t;
	 at t_end: vm_request_mask = isa_mmu_sig_mask_at_t;
	 at t_end: vm_request_mstatus = isa_mmu_sig_mstatus_at_t;
	 at t_end: vm_request_prv = ((shift_right(isa_mmu_sig_mstatus_at_t,11)) and 3);
	 at t_end: vm_request_reset_lrsc = isa_mmu_sig_reset_lrsc_at_t;
	 at t_end: vm_request_satp = isa_mmu_sig_satp_at_t;
	 at t_end: vm_request_v_addr = isa_mmu_sig_v_addr_at_t;
	 during[t+1, t_end]: isa_mmu_notify = false;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end-1]: mmu_isa_notify = false;
	 at t_end: mmu_isa_notify = true;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property RESPONSE_6_write_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: RESPONSE_6;
	 at t: mmu_isa_sync;
prove:
	 at t_end: REQUEST_5;
	 at t_end: i = i_at_t;
	 at t_end: lr_sc_addr = lr_sc_addr_at_t;
	 at t_end: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t_end: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t_end: mem_req_mask = mem_req_mask_at_t;
	 at t_end: mem_req_req = mem_req_req_at_t;
	 at t_end: returndata_data = returndata_data_at_t;
	 at t_end: returndata_exception = returndata_exception_at_t;
	 at t_end: returndata_sc_success = returndata_sc_success_at_t;
	 at t_end: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t_end: vm_request_data = vm_request_data_at_t;
	 at t_end: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t_end: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t_end: vm_request_mask = vm_request_mask_at_t;
	 at t_end: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t_end: vm_request_prv = vm_request_prv_at_t;
	 at t_end: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t_end: vm_request_satp = vm_request_satp_at_t;
	 at t_end: vm_request_v_addr = vm_request_v_addr_at_t;
	 during[t+1, t_end-1]: isa_mmu_notify = false;
	 at t_end: isa_mmu_notify = true;
	 during[t+1, t_end]: mem_mmu_notify = false;
	 during[t+1, t_end]: mmu_isa_notify = false;
	 during[t+1, t_end]: mmu_mem_notify = false;
end property;

property wait_MEMORY_OP_0 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_0;
	 at t: not(mmu_mem_sync);
prove:
	 at t+1: MEMORY_OP_0;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: mmu_mem_sig_addrIn = mem_req_addrIn_at_t;
	 at t+1: mmu_mem_sig_dataIn = mem_req_dataIn_at_t;
	 at t+1: mmu_mem_sig_mask = mem_req_mask_at_t;
	 at t+1: mmu_mem_sig_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = false;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = true;
end property;

property wait_MEMORY_OP_1 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_1;
	 at t: not(mmu_mem_sync);
prove:
	 at t+1: MEMORY_OP_1;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: mmu_mem_sig_addrIn = mem_req_addrIn_at_t;
	 at t+1: mmu_mem_sig_dataIn = mem_req_dataIn_at_t;
	 at t+1: mmu_mem_sig_mask = mem_req_mask_at_t;
	 at t+1: mmu_mem_sig_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = false;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = true;
end property;

property wait_MEMORY_OP_2 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: MEMORY_OP_2;
	 at t: not(mem_mmu_sync);
prove:
	 at t+1: MEMORY_OP_2;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = true;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = false;
end property;

property wait_PTE_FETCH_3 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_3;
	 at t: not(mmu_mem_sync);
prove:
	 at t+1: PTE_FETCH_3;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: mmu_mem_sig_addrIn = mem_req_addrIn_at_t;
	 at t+1: mmu_mem_sig_dataIn = mem_req_dataIn_at_t;
	 at t+1: mmu_mem_sig_mask = mem_req_mask_at_t;
	 at t+1: mmu_mem_sig_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = false;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = true;
end property;

property wait_PTE_FETCH_4 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: PTE_FETCH_4;
	 at t: not(mem_mmu_sync);
prove:
	 at t+1: PTE_FETCH_4;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = true;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = false;
end property;

property wait_REQUEST_5 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: REQUEST_5;
	 at t: not(isa_mmu_sync);
prove:
	 at t+1: REQUEST_5;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = true;
	 at t+1: mem_mmu_notify = false;
	 at t+1: mmu_isa_notify = false;
	 at t+1: mmu_mem_notify = false;
end property;

property wait_RESPONSE_6 is
dependencies: no_reset;
freeze:
	i_at_t = i@t,
	lr_sc_addr_at_t = lr_sc_addr@t,
	mem_req_addrIn_at_t = mem_req_addrIn@t,
	mem_req_dataIn_at_t = mem_req_dataIn@t,
	mem_req_mask_at_t = mem_req_mask@t,
	mem_req_req_at_t = mem_req_req@t,
	returndata_data_at_t = returndata_data@t,
	returndata_exception_at_t = returndata_exception@t,
	returndata_sc_success_at_t = returndata_sc_success@t,
	vm_request_accesstype_at_t = vm_request_accesstype@t,
	vm_request_data_at_t = vm_request_data@t,
	vm_request_exception_in_at_t = vm_request_exception_in@t,
	vm_request_lrsc_at_t = vm_request_lrsc@t,
	vm_request_mask_at_t = vm_request_mask@t,
	vm_request_mstatus_at_t = vm_request_mstatus@t,
	vm_request_prv_at_t = vm_request_prv@t,
	vm_request_reset_lrsc_at_t = vm_request_reset_lrsc@t,
	vm_request_satp_at_t = vm_request_satp@t,
	vm_request_v_addr_at_t = vm_request_v_addr@t;
assume: 
	 at t: RESPONSE_6;
	 at t: not(mmu_isa_sync);
prove:
	 at t+1: RESPONSE_6;
	 at t+1: i = i_at_t;
	 at t+1: lr_sc_addr = lr_sc_addr_at_t;
	 at t+1: mem_req_addrIn = mem_req_addrIn_at_t;
	 at t+1: mem_req_dataIn = mem_req_dataIn_at_t;
	 at t+1: mem_req_mask = mem_req_mask_at_t;
	 at t+1: mem_req_req = mem_req_req_at_t;
	 at t+1: mmu_isa_sig_data = returndata_data_at_t;
	 at t+1: mmu_isa_sig_exception = returndata_exception_at_t;
	 at t+1: mmu_isa_sig_sc_success = returndata_sc_success_at_t;
	 at t+1: returndata_data = returndata_data_at_t;
	 at t+1: returndata_exception = returndata_exception_at_t;
	 at t+1: returndata_sc_success = returndata_sc_success_at_t;
	 at t+1: vm_request_accesstype = vm_request_accesstype_at_t;
	 at t+1: vm_request_data = vm_request_data_at_t;
	 at t+1: vm_request_exception_in = vm_request_exception_in_at_t;
	 at t+1: vm_request_lrsc = vm_request_lrsc_at_t;
	 at t+1: vm_request_mask = vm_request_mask_at_t;
	 at t+1: vm_request_mstatus = vm_request_mstatus_at_t;
	 at t+1: vm_request_prv = vm_request_prv_at_t;
	 at t+1: vm_request_reset_lrsc = vm_request_reset_lrsc_at_t;
	 at t+1: vm_request_satp = vm_request_satp_at_t;
	 at t+1: vm_request_v_addr = vm_request_v_addr_at_t;
	 at t+1: isa_mmu_notify = false;
	 at t+1: mem_mmu_notify = false;
	 at t+1: mmu_isa_notify = true;
	 at t+1: mmu_mem_notify = false;
end property;