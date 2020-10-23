--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
-- macro bus_isa_Port_notify :  boolean  := end macro;
-- macro bus_isa_Port_sync   :  boolean  := end macro;
-- macro bus_syscall_Port_notify :  boolean  := end macro;
-- macro bus_syscall_Port_sync   :  boolean  := end macro;
-- macro fromMemoryPort_notify :  boolean  := end macro;
-- macro fromMemoryPort_sync   :  boolean  := end macro;
-- macro isa_bus_Port_notify :  boolean  := end macro;
-- macro isa_bus_Port_sync   :  boolean  := end macro;
-- macro syscall_bus_Port_notify :  boolean  := end macro;
-- macro syscall_bus_Port_sync   :  boolean  := end macro;
-- macro toMemoryPort_notify :  boolean  := end macro;
-- macro toMemoryPort_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro bus_isa_Port_sig_loadedData : unsigned := bus_isa_Port.loadedData end macro;
macro bus_syscall_Port_sig_loadedData : unsigned := bus_syscall_Port.loadedData end macro;
macro fromMemoryPort_sig_loadedData : unsigned := fromMemoryPort.loadedData end macro;
macro isa_bus_Port_sig_addrIn : unsigned := isa_bus_Port.addrIn end macro;
macro isa_bus_Port_sig_dataIn : unsigned := isa_bus_Port.dataIn end macro;
macro isa_bus_Port_sig_mask : ME_MaskType := isa_bus_Port.mask end macro;
macro isa_bus_Port_sig_req : ME_AccessType := isa_bus_Port.req end macro;
macro syscall_bus_Port_sig_addrIn : unsigned := syscall_bus_Port.addrIn end macro;
macro syscall_bus_Port_sig_dataIn : unsigned := syscall_bus_Port.dataIn end macro;
macro syscall_bus_Port_sig_mask : ME_MaskType := syscall_bus_Port.mask end macro;
macro syscall_bus_Port_sig_req : ME_AccessType := syscall_bus_Port.req end macro;
macro toMemoryPort_sig_addrIn : unsigned := toMemoryPort.addrIn end macro;
macro toMemoryPort_sig_dataIn : unsigned := toMemoryPort.dataIn end macro;
macro toMemoryPort_sig_mask : ME_MaskType := toMemoryPort.mask end macro;
macro toMemoryPort_sig_req : ME_AccessType := toMemoryPort.req end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro fromMemoryData_loadedData : unsigned := memoryResponse.loadedData end macro;
macro memoryAccess_addrIn : unsigned := memoryRequest.addrIn end macro;
macro memoryAccess_dataIn : unsigned := memoryRequest.dataIn end macro;
macro memoryAccess_mask : ME_MaskType := memoryRequest.mask end macro;
macro memoryAccess_req : ME_AccessType := memoryRequest.req end macro;

-- STATES --
macro run_0 : boolean := (section = isa_bus_read) end macro;
macro run_1 : boolean := (section = isa_bus_mem_read) end macro;
macro run_2 : boolean := (section = isa_bus_mem_write) end macro;
macro run_3 : boolean := (section = isa_bus_write) end macro;
macro run_4 : boolean := (section = syscall_bus_read) end macro;
macro run_5 : boolean := (section = syscall_bus_mem_read) end macro;
macro run_6 : boolean := (section = syscall_bus_mem_write) end macro;
macro run_7 : boolean := (section = syscall_bus_write) end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: fromMemoryData_loadedData = resize(0,32);
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_B;
	 at t: memoryAccess_req = ME_RD;
	 at t: bus_isa_Port_notify = false;
	 at t: bus_syscall_Port_notify = false;
	 at t: fromMemoryPort_notify = false;
	 at t: isa_bus_Port_notify = true;
	 at t: syscall_bus_Port_notify = false;
	 at t: toMemoryPort_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	isa_bus_Port_sig_addrIn_at_t = isa_bus_Port_sig_addrIn@t,
	isa_bus_Port_sig_dataIn_at_t = isa_bus_Port_sig_dataIn@t,
	isa_bus_Port_sig_mask_at_t = isa_bus_Port_sig_mask@t,
	isa_bus_Port_sig_req_at_t = isa_bus_Port_sig_req@t;
assume:
	 at t: run_0;
	 at t: isa_bus_Port_sync;
	 at t: isa_bus_Port_sync;
prove:
	 at t_end: run_1;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: memoryAccess_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: memoryAccess_req = isa_bus_Port_sig_req_at_t;
	 at t_end: toMemoryPort_sig_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: toMemoryPort_sig_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: toMemoryPort_sig_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: toMemoryPort_sig_req = isa_bus_Port_sig_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_0;
	 at t: not(isa_bus_Port_sync);
prove:
	 at t_end: run_4;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_1;
	 at t: (memoryAccess_req = ME_RD);
	 at t: toMemoryPort_sync;
prove:
	 at t_end: run_2;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_1;
	 at t: not((memoryAccess_req = ME_RD));
	 at t: toMemoryPort_sync;
prove:
	 at t_end: run_4;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_2;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: run_3;
	 at t_end: bus_isa_Port_sig_loadedData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end-1]: bus_isa_Port_notify = false;
	 at t_end: bus_isa_Port_notify = true;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_3_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_3;
	 at t: bus_isa_Port_sync;
prove:
	 at t_end: run_4;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_4_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_4;
	 at t: not(syscall_bus_Port_sync);
prove:
	 at t_end: run_0;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_4_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	syscall_bus_Port_sig_addrIn_at_t = syscall_bus_Port_sig_addrIn@t,
	syscall_bus_Port_sig_dataIn_at_t = syscall_bus_Port_sig_dataIn@t,
	syscall_bus_Port_sig_mask_at_t = syscall_bus_Port_sig_mask@t,
	syscall_bus_Port_sig_req_at_t = syscall_bus_Port_sig_req@t;
assume:
	 at t: run_4;
	 at t: syscall_bus_Port_sync;
	 at t: syscall_bus_Port_sync;
prove:
	 at t_end: run_5;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: memoryAccess_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: memoryAccess_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: toMemoryPort_sig_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: toMemoryPort_sig_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: toMemoryPort_sig_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: toMemoryPort_sig_req = syscall_bus_Port_sig_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
end property;

property run_5_write_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_5;
	 at t: not((memoryAccess_req = ME_RD));
	 at t: toMemoryPort_sync;
prove:
	 at t_end: run_0;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_5_write_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_5;
	 at t: (memoryAccess_req = ME_RD);
	 at t: toMemoryPort_sync;
prove:
	 at t_end: run_6;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_6_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume:
	 at t: run_6;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: run_7;
	 at t_end: bus_syscall_Port_sig_loadedData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: fromMemoryData_loadedData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end-1]: bus_syscall_Port_notify = false;
	 at t_end: bus_syscall_Port_notify = true;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property run_7_write_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_7;
	 at t: bus_syscall_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
	 during[t+1, t_end]: toMemoryPort_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_1;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: run_1;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
end property;

property wait_run_2 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_2;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: run_2;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_3;
	 at t: not(bus_isa_Port_sync);
prove:
	 at t+1: run_3;
	 at t+1: bus_isa_Port_sig_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = true;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_run_5 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_5;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: run_5;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = true;
end property;

property wait_run_6 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_6;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: run_6;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;

property wait_run_7 is
dependencies: no_reset;
freeze:
	fromMemoryData_loadedData_at_t = fromMemoryData_loadedData@t,
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t;
assume: 
	 at t: run_7;
	 at t: not(bus_syscall_Port_sync);
prove:
	 at t+1: run_7;
	 at t+1: bus_syscall_Port_sig_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: fromMemoryData_loadedData = fromMemoryData_loadedData_at_t;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = true;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
	 at t+1: toMemoryPort_notify = false;
end property;