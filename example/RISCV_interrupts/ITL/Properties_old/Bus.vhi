--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18
--

-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro BUStoCLINT_port_notify :  boolean  := BUS_CLINT_Port_notify end macro;
macro BUStoCLINT_port_sync   :  boolean  := BUS_CLINT_Port_sync end macro;
macro BUStoCO_port_notify :  boolean  := BUS_CPU_Port_notify end macro;
macro BUStoCO_port_sync   :  boolean  := BUS_CPU_Port_sync end macro;
macro BUStoMEM_port_notify :  boolean  := BUS_MEM_Port_notify end macro;
macro BUStoMEM_port_sync   :  boolean  := BUS_MEM_Port_sync end macro;
macro BUStoPLIC_port_notify :  boolean  := BUS_PLIC_Port_notify end macro;
macro BUStoPLIC_port_sync   :  boolean  := BUS_PLIC_Port_sync end macro;
macro CLINTtoBUS_port_notify :  boolean  := CLINT_BUS_Port_notify end macro;
macro CLINTtoBUS_port_sync   :  boolean  := CLINT_BUS_Port_sync end macro;
macro COtoBUS_port_notify :  boolean  := CPU_BUS_Port_notify end macro;
macro COtoBUS_port_sync   :  boolean  := CPU_BUS_Port_sync end macro;
macro MEMtoBUS_port_notify :  boolean  := MEM_BUS_Port_notify end macro;
macro MEMtoBUS_port_sync   :  boolean  := MEM_BUS_Port_sync end macro;
macro PLICtoBUS_port_notify :  boolean  := PLIC_BUS_Port_notify end macro;
macro PLICtoBUS_port_sync   :  boolean  := PLIC_BUS_Port_sync end macro;


-- DP SIGNALS -- 
macro BUStoCLINT_port_sig_addrIn : unsigned := BUS_CLINT_Port.addrIn end macro;
macro BUStoCLINT_port_sig_dataIn : unsigned := BUS_CLINT_Port.dataIn end macro;
macro BUStoCLINT_port_sig_mask : ME_MaskType := BUS_CLINT_Port.mask end macro;
macro BUStoCLINT_port_sig_req : ME_AccessType := BUS_CLINT_Port.req end macro;
macro BUStoCO_port_sig_loadedData : unsigned := BUS_CPU_Port.loadedData end macro;
macro BUStoMEM_port_sig_addrIn : unsigned := BUS_MEM_Port.addrIn end macro;
macro BUStoMEM_port_sig_dataIn : unsigned := BUS_MEM_Port.dataIn end macro;
macro BUStoMEM_port_sig_mask : ME_MaskType := BUS_MEM_Port.mask end macro;
macro BUStoMEM_port_sig_req : ME_AccessType := BUS_MEM_Port.req end macro;
macro BUStoPLIC_port_sig_addrIn : unsigned := BUS_PLIC_Port.addrIn end macro;
macro BUStoPLIC_port_sig_dataIn : unsigned := BUS_PLIC_Port.dataIn end macro;
macro BUStoPLIC_port_sig_mask : ME_MaskType := BUS_PLIC_Port.mask end macro;
macro BUStoPLIC_port_sig_req : ME_AccessType := BUS_PLIC_Port.req end macro;
macro CLINTtoBUS_port_sig_loadedData : unsigned := CLINT_BUS_Port.loadedData end macro;
macro COtoBUS_port_sig_addrIn : unsigned := CPU_BUS_Port.addrIn end macro;
macro COtoBUS_port_sig_dataIn : unsigned := CPU_BUS_Port.dataIn end macro;
macro COtoBUS_port_sig_mask : ME_MaskType := CPU_BUS_Port.mask end macro;
macro COtoBUS_port_sig_req : ME_AccessType := CPU_BUS_Port.req end macro;
macro MEMtoBUS_port_sig_loadedData : unsigned := MEM_BUS_Port.loadedData end macro;
macro PLICtoBUS_port_sig_loadedData : unsigned := PLIC_BUS_Port.loadedData end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro CPtoME_data_addrIn : unsigned := memoryRequest.addrIn end macro;
macro CPtoME_data_dataIn : unsigned := memoryRequest.dataIn end macro;
macro CPtoME_data_mask : ME_MaskType := memoryRequest.mask end macro;
macro CPtoME_data_req : ME_AccessType := memoryRequest.req end macro;
macro MEtoCP_data_loadedData : unsigned := memoryResponse.loadedData end macro;


-- STATES -- 
macro run_0 : boolean := (section = read) end macro;
macro run_1 : boolean := (section = write_mem) end macro;
macro run_2 : boolean := (section = read_mem) end macro;
macro run_3 : boolean := (section = write) end macro;
macro run_4 : boolean := (section = write_clint) end macro;
macro run_5 : boolean := (section = read_clint) end macro;
macro run_6 : boolean := (section = write) end macro;
macro run_7 : boolean := (section = write_plic) end macro;
macro run_8 : boolean := (section = read_plic) end macro;
macro run_9 : boolean := (section = write) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: CPtoME_data_addrIn = resize(0,32);
	 at t: CPtoME_data_dataIn = resize(0,32);
	 at t: CPtoME_data_mask = MT_B;
	 at t: CPtoME_data_req = ME_RD;
	 at t: MEtoCP_data_loadedData = resize(0,32);
	 at t: BUStoCLINT_port_notify = false;
	 at t: BUStoCO_port_notify = false;
	 at t: BUStoMEM_port_notify = false;
	 at t: BUStoPLIC_port_notify = false;
	 at t: CLINTtoBUS_port_notify = false;
	 at t: COtoBUS_port_notify = true;
	 at t: MEMtoBUS_port_notify = false;
	 at t: PLICtoBUS_port_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoBUS_port_sig_addrIn_at_t = COtoBUS_port_sig_addrIn@t,
	COtoBUS_port_sig_dataIn_at_t = COtoBUS_port_sig_dataIn@t,
	COtoBUS_port_sig_mask_at_t = COtoBUS_port_sig_mask@t,
	COtoBUS_port_sig_req_at_t = COtoBUS_port_sig_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_0;
	 at t: (resize(33619967,32) <= COtoBUS_port_sig_addrIn);
	 at t: not(((resize(1073741824,32) <= COtoBUS_port_sig_addrIn) and not((resize(1073745920,32) <= COtoBUS_port_sig_addrIn))));
	 at t: COtoBUS_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = COtoBUS_port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoBUS_port_sig_addrIn_at_t = COtoBUS_port_sig_addrIn@t,
	COtoBUS_port_sig_dataIn_at_t = COtoBUS_port_sig_dataIn@t,
	COtoBUS_port_sig_mask_at_t = COtoBUS_port_sig_mask@t,
	COtoBUS_port_sig_req_at_t = COtoBUS_port_sig_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_0;
	 at t: not((resize(33554432,32) <= COtoBUS_port_sig_addrIn));
	 at t: COtoBUS_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: BUStoMEM_port_sig_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: BUStoMEM_port_sig_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: BUStoMEM_port_sig_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: BUStoMEM_port_sig_req = COtoBUS_port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = COtoBUS_port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end-1]: BUStoMEM_port_notify = false;
	 at t_end: BUStoMEM_port_notify = true;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoBUS_port_sig_addrIn_at_t = COtoBUS_port_sig_addrIn@t,
	COtoBUS_port_sig_dataIn_at_t = COtoBUS_port_sig_dataIn@t,
	COtoBUS_port_sig_mask_at_t = COtoBUS_port_sig_mask@t,
	COtoBUS_port_sig_req_at_t = COtoBUS_port_sig_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_0;
	 at t: (resize(33554432,32) <= COtoBUS_port_sig_addrIn);
	 at t: not((resize(33619967,32) <= COtoBUS_port_sig_addrIn));
	 at t: COtoBUS_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: BUStoCLINT_port_sig_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: BUStoCLINT_port_sig_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: BUStoCLINT_port_sig_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: BUStoCLINT_port_sig_req = COtoBUS_port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = COtoBUS_port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end-1]: BUStoCLINT_port_notify = false;
	 at t_end: BUStoCLINT_port_notify = true;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoBUS_port_sig_addrIn_at_t = COtoBUS_port_sig_addrIn@t,
	COtoBUS_port_sig_dataIn_at_t = COtoBUS_port_sig_dataIn@t,
	COtoBUS_port_sig_mask_at_t = COtoBUS_port_sig_mask@t,
	COtoBUS_port_sig_req_at_t = COtoBUS_port_sig_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_0;
	 at t: (resize(1073741824,32) <= COtoBUS_port_sig_addrIn);
	 at t: not((resize(1073745920,32) <= COtoBUS_port_sig_addrIn));
	 at t: COtoBUS_port_sync;
prove:
	 at t_end: run_7;
	 at t_end: BUStoPLIC_port_sig_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: BUStoPLIC_port_sig_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: BUStoPLIC_port_sig_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: BUStoPLIC_port_sig_req = COtoBUS_port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = COtoBUS_port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = COtoBUS_port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = COtoBUS_port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = COtoBUS_port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end-1]: BUStoPLIC_port_notify = false;
	 at t_end: BUStoPLIC_port_notify = true;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_1_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_1;
	 at t: not((CPtoME_data_req = ME_RD));
	 at t: BUStoMEM_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_1_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_1;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoMEM_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end-1]: MEMtoBUS_port_notify = false;
	 at t_end: MEMtoBUS_port_notify = true;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_2_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEMtoBUS_port_sig_loadedData_at_t = MEMtoBUS_port_sig_loadedData@t;
assume: 
	 at t: run_2;
	 at t: MEMtoBUS_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: BUStoCO_port_sig_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end-1]: BUStoCO_port_notify = false;
	 at t_end: BUStoCO_port_notify = true;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_3_write_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_3;
	 at t: BUStoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_4_write_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_4;
	 at t: not((CPtoME_data_req = ME_RD));
	 at t: BUStoCLINT_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_4_write_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_4;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoCLINT_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end-1]: CLINTtoBUS_port_notify = false;
	 at t_end: CLINTtoBUS_port_notify = true;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_5_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CLINTtoBUS_port_sig_loadedData_at_t = CLINTtoBUS_port_sig_loadedData@t,
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t;
assume: 
	 at t: run_5;
	 at t: CLINTtoBUS_port_sync;
prove:
	 at t_end: run_6;
	 at t_end: BUStoCO_port_sig_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end-1]: BUStoCO_port_notify = false;
	 at t_end: BUStoCO_port_notify = true;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_6_write_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_6;
	 at t: BUStoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_7_write_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_7;
	 at t: not((CPtoME_data_req = ME_RD));
	 at t: BUStoPLIC_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_7_write_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_7;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoPLIC_port_sync;
prove:
	 at t_end: run_8;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end-1]: PLICtoBUS_port_notify = false;
	 at t_end: PLICtoBUS_port_notify = true;
end property;

property run_8_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	PLICtoBUS_port_sig_loadedData_at_t = PLICtoBUS_port_sig_loadedData@t;
assume: 
	 at t: run_8;
	 at t: PLICtoBUS_port_sync;
prove:
	 at t_end: run_9;
	 at t_end: BUStoCO_port_sig_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end-1]: BUStoCO_port_notify = false;
	 at t_end: BUStoCO_port_notify = true;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: COtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property run_9_write_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_9;
	 at t: BUStoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoCO_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: COtoBUS_port_notify = false;
	 at t_end: COtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_0;
	 at t: not(COtoBUS_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = true;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_1;
	 at t: not(BUStoMEM_port_sync);
prove:
	 at t+1: run_1;
	 at t+1: BUStoMEM_port_sig_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: BUStoMEM_port_sig_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: BUStoMEM_port_sig_mask = CPtoME_data_mask_at_t;
	 at t+1: BUStoMEM_port_sig_req = CPtoME_data_req_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = true;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_2 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_2;
	 at t: not(MEMtoBUS_port_sync);
prove:
	 at t+1: run_2;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = true;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_3;
	 at t: not(BUStoCO_port_sync);
prove:
	 at t+1: run_3;
	 at t+1: BUStoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = true;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_4 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_4;
	 at t: not(BUStoCLINT_port_sync);
prove:
	 at t+1: run_4;
	 at t+1: BUStoCLINT_port_sig_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: BUStoCLINT_port_sig_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: BUStoCLINT_port_sig_mask = CPtoME_data_mask_at_t;
	 at t+1: BUStoCLINT_port_sig_req = CPtoME_data_req_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = true;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_5 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_5;
	 at t: not(CLINTtoBUS_port_sync);
prove:
	 at t+1: run_5;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = true;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_6 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_6;
	 at t: not(BUStoCO_port_sync);
prove:
	 at t+1: run_6;
	 at t+1: BUStoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = true;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_7 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_7;
	 at t: not(BUStoPLIC_port_sync);
prove:
	 at t+1: run_7;
	 at t+1: BUStoPLIC_port_sig_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: BUStoPLIC_port_sig_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: BUStoPLIC_port_sig_mask = CPtoME_data_mask_at_t;
	 at t+1: BUStoPLIC_port_sig_req = CPtoME_data_req_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = true;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;

property wait_run_8 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_8;
	 at t: not(PLICtoBUS_port_sync);
prove:
	 at t+1: run_8;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = true;
end property;

property wait_run_9 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_9;
	 at t: not(BUStoCO_port_sync);
prove:
	 at t+1: run_9;
	 at t+1: BUStoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoCO_port_notify = true;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: COtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
end property;