-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro BUStoCLINT_port_notify :  boolean  := end macro; 
macro BUStoCLINT_port_sync   :  boolean  := end macro; 
macro BUStoMEM_port_notify :  boolean  := end macro; 
macro BUStoMEM_port_sync   :  boolean  := end macro; 
macro BUStoPLIC_port_notify :  boolean  := end macro; 
macro BUStoPLIC_port_sync   :  boolean  := end macro; 
macro CLINTtoBUS_port_notify :  boolean  := end macro; 
macro CLINTtoBUS_port_sync   :  boolean  := end macro; 
macro MEMtoBUS_port_notify :  boolean  := end macro; 
macro MEMtoBUS_port_sync   :  boolean  := end macro; 
macro PLICtoBUS_port_notify :  boolean  := end macro; 
macro PLICtoBUS_port_sync   :  boolean  := end macro; 
macro bus_isa_Port_notify :  boolean  := end macro; 
macro bus_isa_Port_sync   :  boolean  := end macro; 
macro bus_syscall_Port_notify :  boolean  := end macro; 
macro bus_syscall_Port_sync   :  boolean  := end macro; 
macro isa_bus_Port_notify :  boolean  := end macro; 
macro isa_bus_Port_sync   :  boolean  := end macro; 
macro syscall_bus_Port_notify :  boolean  := end macro; 
macro syscall_bus_Port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro BUStoCLINT_port_sig_addrIn : unsigned := end macro; 
macro BUStoCLINT_port_sig_dataIn : unsigned := end macro; 
macro BUStoCLINT_port_sig_mask : ME_MaskType := end macro; 
macro BUStoCLINT_port_sig_req : ME_AccessType := end macro; 
macro BUStoMEM_port_sig_addrIn : unsigned := end macro; 
macro BUStoMEM_port_sig_dataIn : unsigned := end macro; 
macro BUStoMEM_port_sig_mask : ME_MaskType := end macro; 
macro BUStoMEM_port_sig_req : ME_AccessType := end macro; 
macro BUStoPLIC_port_sig_addrIn : unsigned := end macro; 
macro BUStoPLIC_port_sig_dataIn : unsigned := end macro; 
macro BUStoPLIC_port_sig_mask : ME_MaskType := end macro; 
macro BUStoPLIC_port_sig_req : ME_AccessType := end macro; 
macro CLINTtoBUS_port_sig_loadedData : unsigned := end macro; 
macro MEMtoBUS_port_sig_loadedData : unsigned := end macro; 
macro PLICtoBUS_port_sig_loadedData : unsigned := end macro; 
macro bus_isa_Port_sig_loadedData : unsigned := end macro; 
macro bus_syscall_Port_sig_loadedData : unsigned := end macro; 
macro isa_bus_Port_sig_addrIn : unsigned := end macro; 
macro isa_bus_Port_sig_dataIn : unsigned := end macro; 
macro isa_bus_Port_sig_mask : ME_MaskType := end macro; 
macro isa_bus_Port_sig_req : ME_AccessType := end macro; 
macro syscall_bus_Port_sig_addrIn : unsigned := end macro; 
macro syscall_bus_Port_sig_dataIn : unsigned := end macro; 
macro syscall_bus_Port_sig_mask : ME_MaskType := end macro; 
macro syscall_bus_Port_sig_req : ME_AccessType := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro CPtoME_data_addrIn : unsigned := end macro; 
macro CPtoME_data_dataIn : unsigned := end macro; 
macro CPtoME_data_mask : ME_MaskType := end macro; 
macro CPtoME_data_req : ME_AccessType := end macro; 
macro MEtoCP_data_loadedData : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;
macro run_2 : boolean := true end macro;
macro run_3 : boolean := true end macro;
macro run_4 : boolean := true end macro;
macro run_5 : boolean := true end macro;
macro run_6 : boolean := true end macro;
macro run_7 : boolean := true end macro;
macro run_8 : boolean := true end macro;
macro run_9 : boolean := true end macro;
macro run_10 : boolean := true end macro;
macro run_11 : boolean := true end macro;
macro run_12 : boolean := true end macro;
macro run_13 : boolean := true end macro;
macro run_14 : boolean := true end macro;
macro run_15 : boolean := true end macro;
macro run_16 : boolean := true end macro;
macro run_17 : boolean := true end macro;
macro run_18 : boolean := true end macro;
macro run_19 : boolean := true end macro;


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
	 at t: BUStoMEM_port_notify = false;
	 at t: BUStoPLIC_port_notify = false;
	 at t: CLINTtoBUS_port_notify = false;
	 at t: MEMtoBUS_port_notify = false;
	 at t: PLICtoBUS_port_notify = false;
	 at t: bus_isa_Port_notify = false;
	 at t: bus_syscall_Port_notify = false;
	 at t: isa_bus_Port_notify = true;
	 at t: syscall_bus_Port_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	isa_bus_Port_sig_addrIn_at_t = isa_bus_Port_sig_addrIn@t,
	isa_bus_Port_sig_dataIn_at_t = isa_bus_Port_sig_dataIn@t,
	isa_bus_Port_sig_mask_at_t = isa_bus_Port_sig_mask@t,
	isa_bus_Port_sig_req_at_t = isa_bus_Port_sig_req@t;
assume: 
	 at t: run_0;
	 at t: isa_bus_Port_sync;
	 at t: not((resize(262144,32) <= isa_bus_Port_sig_addrIn));
	 at t: isa_bus_Port_sync;
prove:
	 at t_end: run_1;
	 at t_end: BUStoMEM_port_sig_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoMEM_port_sig_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoMEM_port_sig_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: BUStoMEM_port_sig_req = isa_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = isa_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end-1]: BUStoMEM_port_notify = false;
	 at t_end: BUStoMEM_port_notify = true;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_0_read_1 is
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
	 at t: run_0;
	 at t: not(isa_bus_Port_sync);
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	isa_bus_Port_sig_addrIn_at_t = isa_bus_Port_sig_addrIn@t,
	isa_bus_Port_sig_dataIn_at_t = isa_bus_Port_sig_dataIn@t,
	isa_bus_Port_sig_mask_at_t = isa_bus_Port_sig_mask@t,
	isa_bus_Port_sig_req_at_t = isa_bus_Port_sig_req@t;
assume: 
	 at t: run_0;
	 at t: isa_bus_Port_sync;
	 at t: (resize(262144,32) <= isa_bus_Port_sig_addrIn);
	 at t: not(((resize(33554432,32) <= isa_bus_Port_sig_addrIn) and not((resize(33619967,32) <= isa_bus_Port_sig_addrIn))));
	 at t: not(((resize(1073741824,32) <= isa_bus_Port_sig_addrIn) and not((resize(1073745920,32) <= isa_bus_Port_sig_addrIn))));
	 at t: isa_bus_Port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = isa_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	isa_bus_Port_sig_addrIn_at_t = isa_bus_Port_sig_addrIn@t,
	isa_bus_Port_sig_dataIn_at_t = isa_bus_Port_sig_dataIn@t,
	isa_bus_Port_sig_mask_at_t = isa_bus_Port_sig_mask@t,
	isa_bus_Port_sig_req_at_t = isa_bus_Port_sig_req@t;
assume: 
	 at t: run_0;
	 at t: isa_bus_Port_sync;
	 at t: (resize(33554432,32) <= isa_bus_Port_sig_addrIn);
	 at t: not((resize(33619967,32) <= isa_bus_Port_sig_addrIn));
	 at t: isa_bus_Port_sync;
prove:
	 at t_end: run_14;
	 at t_end: BUStoCLINT_port_sig_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoCLINT_port_sig_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoCLINT_port_sig_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: BUStoCLINT_port_sig_req = isa_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = isa_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end-1]: BUStoCLINT_port_notify = false;
	 at t_end: BUStoCLINT_port_notify = true;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	isa_bus_Port_sig_addrIn_at_t = isa_bus_Port_sig_addrIn@t,
	isa_bus_Port_sig_dataIn_at_t = isa_bus_Port_sig_dataIn@t,
	isa_bus_Port_sig_mask_at_t = isa_bus_Port_sig_mask@t,
	isa_bus_Port_sig_req_at_t = isa_bus_Port_sig_req@t;
assume: 
	 at t: run_0;
	 at t: isa_bus_Port_sync;
	 at t: (resize(1073741824,32) <= isa_bus_Port_sig_addrIn);
	 at t: not((resize(1073745920,32) <= isa_bus_Port_sig_addrIn));
	 at t: isa_bus_Port_sync;
prove:
	 at t_end: run_17;
	 at t_end: BUStoPLIC_port_sig_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoPLIC_port_sig_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoPLIC_port_sig_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: BUStoPLIC_port_sig_req = isa_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = isa_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = isa_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = isa_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = isa_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end-1]: BUStoPLIC_port_notify = false;
	 at t_end: BUStoPLIC_port_notify = true;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
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
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: MEMtoBUS_port_notify = false;
	 at t_end: MEMtoBUS_port_notify = true;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_1_write_6 is
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
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_2_read_7 is
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
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_isa_Port_sig_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end-1]: bus_isa_Port_notify = false;
	 at t_end: bus_isa_Port_notify = true;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_3_write_8 is
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
	 at t: bus_isa_Port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_4_read_9 is
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
	 at t: not(syscall_bus_Port_sync);
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_4_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	syscall_bus_Port_sig_addrIn_at_t = syscall_bus_Port_sig_addrIn@t,
	syscall_bus_Port_sig_dataIn_at_t = syscall_bus_Port_sig_dataIn@t,
	syscall_bus_Port_sig_mask_at_t = syscall_bus_Port_sig_mask@t,
	syscall_bus_Port_sig_req_at_t = syscall_bus_Port_sig_req@t;
assume: 
	 at t: run_4;
	 at t: syscall_bus_Port_sync;
	 at t: (resize(262144,32) <= syscall_bus_Port_sig_addrIn);
	 at t: not(((resize(33554432,32) <= syscall_bus_Port_sig_addrIn) and not((resize(33619967,32) <= syscall_bus_Port_sig_addrIn))));
	 at t: not(((resize(1073741824,32) <= syscall_bus_Port_sig_addrIn) and not((resize(1073745920,32) <= syscall_bus_Port_sig_addrIn))));
	 at t: syscall_bus_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_4_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	syscall_bus_Port_sig_addrIn_at_t = syscall_bus_Port_sig_addrIn@t,
	syscall_bus_Port_sig_dataIn_at_t = syscall_bus_Port_sig_dataIn@t,
	syscall_bus_Port_sig_mask_at_t = syscall_bus_Port_sig_mask@t,
	syscall_bus_Port_sig_req_at_t = syscall_bus_Port_sig_req@t;
assume: 
	 at t: run_4;
	 at t: syscall_bus_Port_sync;
	 at t: not((resize(262144,32) <= syscall_bus_Port_sig_addrIn));
	 at t: syscall_bus_Port_sync;
prove:
	 at t_end: run_5;
	 at t_end: BUStoMEM_port_sig_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoMEM_port_sig_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoMEM_port_sig_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: BUStoMEM_port_sig_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end-1]: BUStoMEM_port_notify = false;
	 at t_end: BUStoMEM_port_notify = true;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_4_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	syscall_bus_Port_sig_addrIn_at_t = syscall_bus_Port_sig_addrIn@t,
	syscall_bus_Port_sig_dataIn_at_t = syscall_bus_Port_sig_dataIn@t,
	syscall_bus_Port_sig_mask_at_t = syscall_bus_Port_sig_mask@t,
	syscall_bus_Port_sig_req_at_t = syscall_bus_Port_sig_req@t;
assume: 
	 at t: run_4;
	 at t: syscall_bus_Port_sync;
	 at t: (resize(33554432,32) <= syscall_bus_Port_sig_addrIn);
	 at t: not((resize(33619967,32) <= syscall_bus_Port_sig_addrIn));
	 at t: syscall_bus_Port_sync;
prove:
	 at t_end: run_8;
	 at t_end: BUStoCLINT_port_sig_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoCLINT_port_sig_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoCLINT_port_sig_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: BUStoCLINT_port_sig_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end-1]: BUStoCLINT_port_notify = false;
	 at t_end: BUStoCLINT_port_notify = true;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_4_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	syscall_bus_Port_sig_addrIn_at_t = syscall_bus_Port_sig_addrIn@t,
	syscall_bus_Port_sig_dataIn_at_t = syscall_bus_Port_sig_dataIn@t,
	syscall_bus_Port_sig_mask_at_t = syscall_bus_Port_sig_mask@t,
	syscall_bus_Port_sig_req_at_t = syscall_bus_Port_sig_req@t;
assume: 
	 at t: run_4;
	 at t: syscall_bus_Port_sync;
	 at t: (resize(1073741824,32) <= syscall_bus_Port_sig_addrIn);
	 at t: not((resize(1073745920,32) <= syscall_bus_Port_sig_addrIn));
	 at t: syscall_bus_Port_sync;
prove:
	 at t_end: run_11;
	 at t_end: BUStoPLIC_port_sig_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: BUStoPLIC_port_sig_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: BUStoPLIC_port_sig_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: BUStoPLIC_port_sig_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: CPtoME_data_addrIn = syscall_bus_Port_sig_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = syscall_bus_Port_sig_dataIn_at_t;
	 at t_end: CPtoME_data_mask = syscall_bus_Port_sig_mask_at_t;
	 at t_end: CPtoME_data_req = syscall_bus_Port_sig_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end-1]: BUStoPLIC_port_notify = false;
	 at t_end: BUStoPLIC_port_notify = true;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_5_write_14 is
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
	 at t: run_5;
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
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_5_write_15 is
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
	 at t: run_5;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoMEM_port_sync;
prove:
	 at t_end: run_6;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end-1]: MEMtoBUS_port_notify = false;
	 at t_end: MEMtoBUS_port_notify = true;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_6_read_16 is
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
	 at t: run_6;
	 at t: MEMtoBUS_port_sync;
prove:
	 at t_end: run_7;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_syscall_Port_sig_loadedData = MEMtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end-1]: bus_syscall_Port_notify = false;
	 at t_end: bus_syscall_Port_notify = true;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_7_write_17 is
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
	 at t: bus_syscall_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_8_write_18 is
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
	 at t: run_8;
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
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_8_write_19 is
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
	 at t: run_8;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoCLINT_port_sync;
prove:
	 at t_end: run_9;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end-1]: CLINTtoBUS_port_notify = false;
	 at t_end: CLINTtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_9_read_20 is
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
	 at t: run_9;
	 at t: CLINTtoBUS_port_sync;
prove:
	 at t_end: run_10;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_syscall_Port_sig_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end-1]: bus_syscall_Port_notify = false;
	 at t_end: bus_syscall_Port_notify = true;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_10_write_21 is
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
	 at t: run_10;
	 at t: bus_syscall_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_11_write_22 is
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
	 at t: run_11;
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
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_11_write_23 is
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
	 at t: run_11;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoPLIC_port_sync;
prove:
	 at t_end: run_12;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end-1]: PLICtoBUS_port_notify = false;
	 at t_end: PLICtoBUS_port_notify = true;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_12_read_24 is
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
	 at t: run_12;
	 at t: PLICtoBUS_port_sync;
prove:
	 at t_end: run_13;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_syscall_Port_sig_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end-1]: bus_syscall_Port_notify = false;
	 at t_end: bus_syscall_Port_notify = true;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_13_write_25 is
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
	 at t: run_13;
	 at t: bus_syscall_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end-1]: isa_bus_Port_notify = false;
	 at t_end: isa_bus_Port_notify = true;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_14_write_26 is
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
	 at t: run_14;
	 at t: not((CPtoME_data_req = ME_RD));
	 at t: BUStoCLINT_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_14_write_27 is
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
	 at t: run_14;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoCLINT_port_sync;
prove:
	 at t_end: run_15;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end-1]: CLINTtoBUS_port_notify = false;
	 at t_end: CLINTtoBUS_port_notify = true;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_15_read_28 is
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
	 at t: run_15;
	 at t: CLINTtoBUS_port_sync;
prove:
	 at t_end: run_16;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_isa_Port_sig_loadedData = CLINTtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end-1]: bus_isa_Port_notify = false;
	 at t_end: bus_isa_Port_notify = true;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_16_write_29 is
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
	 at t: run_16;
	 at t: bus_isa_Port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_17_write_30 is
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
	 at t: run_17;
	 at t: not((CPtoME_data_req = ME_RD));
	 at t: BUStoPLIC_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
end property;

property run_17_write_31 is
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
	 at t: run_17;
	 at t: (CPtoME_data_req = ME_RD);
	 at t: BUStoPLIC_port_sync;
prove:
	 at t_end: run_18;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end-1]: PLICtoBUS_port_notify = false;
	 at t_end: PLICtoBUS_port_notify = true;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_18_read_32 is
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
	 at t: run_18;
	 at t: PLICtoBUS_port_sync;
prove:
	 at t_end: run_19;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 at t_end: bus_isa_Port_sig_loadedData = PLICtoBUS_port_sig_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end-1]: bus_isa_Port_notify = false;
	 at t_end: bus_isa_Port_notify = true;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end]: syscall_bus_Port_notify = false;
end property;

property run_19_write_33 is
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
	 at t: run_19;
	 at t: bus_isa_Port_sync;
prove:
	 at t_end: run_4;
	 at t_end: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t_end: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t_end: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t_end: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 during[t+1, t_end]: BUStoCLINT_port_notify = false;
	 during[t+1, t_end]: BUStoMEM_port_notify = false;
	 during[t+1, t_end]: BUStoPLIC_port_notify = false;
	 during[t+1, t_end]: CLINTtoBUS_port_notify = false;
	 during[t+1, t_end]: MEMtoBUS_port_notify = false;
	 during[t+1, t_end]: PLICtoBUS_port_notify = false;
	 during[t+1, t_end]: bus_isa_Port_notify = false;
	 during[t+1, t_end]: bus_syscall_Port_notify = false;
	 during[t+1, t_end]: isa_bus_Port_notify = false;
	 during[t+1, t_end-1]: syscall_bus_Port_notify = false;
	 at t_end: syscall_bus_Port_notify = true;
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
	 at t+1: BUStoMEM_port_notify = true;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = true;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(bus_isa_Port_sync);
prove:
	 at t+1: run_3;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_isa_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = true;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(BUStoMEM_port_sync);
prove:
	 at t+1: run_5;
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
	 at t+1: BUStoMEM_port_notify = true;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(MEMtoBUS_port_sync);
prove:
	 at t+1: run_6;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = true;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(bus_syscall_Port_sync);
prove:
	 at t+1: run_7;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_syscall_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = true;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(BUStoCLINT_port_sync);
prove:
	 at t+1: run_8;
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
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
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
	 at t: not(CLINTtoBUS_port_sync);
prove:
	 at t+1: run_9;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = true;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_10 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_10;
	 at t: not(bus_syscall_Port_sync);
prove:
	 at t+1: run_10;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_syscall_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = true;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_11 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_11;
	 at t: not(BUStoPLIC_port_sync);
prove:
	 at t+1: run_11;
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
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = true;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_12 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_12;
	 at t: not(PLICtoBUS_port_sync);
prove:
	 at t+1: run_12;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = true;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_13 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_13;
	 at t: not(bus_syscall_Port_sync);
prove:
	 at t+1: run_13;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_syscall_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = true;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_14 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_14;
	 at t: not(BUStoCLINT_port_sync);
prove:
	 at t+1: run_14;
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
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_15 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_15;
	 at t: not(CLINTtoBUS_port_sync);
prove:
	 at t+1: run_15;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = true;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_16 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_16;
	 at t: not(bus_isa_Port_sync);
prove:
	 at t+1: run_16;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_isa_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = true;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_17 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_17;
	 at t: not(BUStoPLIC_port_sync);
prove:
	 at t+1: run_17;
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
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = true;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_18 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_18;
	 at t: not(PLICtoBUS_port_sync);
prove:
	 at t+1: run_18;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = true;
	 at t+1: bus_isa_Port_notify = false;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;

property wait_run_19 is
dependencies: no_reset;
freeze:
	CPtoME_data_addrIn_at_t = CPtoME_data_addrIn@t,
	CPtoME_data_dataIn_at_t = CPtoME_data_dataIn@t,
	CPtoME_data_mask_at_t = CPtoME_data_mask@t,
	CPtoME_data_req_at_t = CPtoME_data_req@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t;
assume: 
	 at t: run_19;
	 at t: not(bus_isa_Port_sync);
prove:
	 at t+1: run_19;
	 at t+1: CPtoME_data_addrIn = CPtoME_data_addrIn_at_t;
	 at t+1: CPtoME_data_dataIn = CPtoME_data_dataIn_at_t;
	 at t+1: CPtoME_data_mask = CPtoME_data_mask_at_t;
	 at t+1: CPtoME_data_req = CPtoME_data_req_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: bus_isa_Port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: BUStoCLINT_port_notify = false;
	 at t+1: BUStoMEM_port_notify = false;
	 at t+1: BUStoPLIC_port_notify = false;
	 at t+1: CLINTtoBUS_port_notify = false;
	 at t+1: MEMtoBUS_port_notify = false;
	 at t+1: PLICtoBUS_port_notify = false;
	 at t+1: bus_isa_Port_notify = true;
	 at t+1: bus_syscall_Port_notify = false;
	 at t+1: isa_bus_Port_notify = false;
	 at t+1: syscall_bus_Port_notify = false;
end property;