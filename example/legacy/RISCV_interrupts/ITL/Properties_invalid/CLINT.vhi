-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro COtoME_port_notify :  boolean  := end macro; 
macro COtoME_port_sync   :  boolean  := end macro; 
macro MEtoCO_port_notify :  boolean  := end macro; 
macro MEtoCO_port_sync   :  boolean  := end macro; 
macro MSIP_port_notify :  boolean  := end macro; 
macro MSIP_port_sync   :  boolean  := end macro; 
macro MTIP_port_notify :  boolean  := end macro; 
macro MTIP_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro COtoME_port_sig_addrIn : unsigned := end macro; 
macro COtoME_port_sig_dataIn : unsigned := end macro; 
macro COtoME_port_sig_mask : ME_MaskType := end macro; 
macro COtoME_port_sig_req : ME_AccessType := end macro; 
macro MEtoCO_port_sig_loadedData : unsigned := end macro; 
macro MSIP_port_sig : bool := end macro; 
macro MTIP_port_sig : bool := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro MEtoCP_data_loadedData : unsigned := end macro; 
macro msip : unsigned := end macro; 
macro mtimeH : unsigned := end macro; 
macro mtimeL : unsigned := end macro; 
macro mtimecmpH : unsigned := end macro; 
macro mtimecmpL : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;
macro run_2 : boolean := true end macro;
macro run_3 : boolean := true end macro;
macro run_4 : boolean := true end macro;
macro run_5 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_5;
	 at t: MEtoCP_data_loadedData = resize(0,32);
	 at t: MSIP_port_sig = false;
	 at t: msip = resize(0,32);
	 at t: mtimeH = resize(0,32);
	 at t: mtimeL = resize(0,32);
	 at t: mtimecmpH = resize(2147483647,32);
	 at t: mtimecmpL = resize(2147483647,32);
	 at t: COtoME_port_notify = false;
	 at t: MEtoCO_port_notify = false;
	 at t: MSIP_port_notify = true;
	 at t: MTIP_port_notify = false;
end property;


property run_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (mtimecmpL <= mtimeL);
	 at t: (mtimecmpH <= mtimeH);
	 at t: MSIP_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (mtimecmpL <= mtimeL);
	 at t: (mtimecmpH <= mtimeH);
	 at t: not(MSIP_port_sync);
prove:
	 at t_end: run_1;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_0_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: not(((mtimecmpL <= mtimeL) and (mtimecmpH <= mtimeH)));
	 at t: MSIP_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_0_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: not(((mtimecmpL <= mtimeL) and (mtimecmpH <= mtimeH)));
	 at t: not(MSIP_port_sync);
prove:
	 at t_end: run_4;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_1_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_1;
	 at t: MTIP_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_1_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_1;
	 at t: not(MTIP_port_sync);
prove:
	 at t_end: run_2;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: not((msip = resize(0,32)));
	 at t: not(COtoME_port_sync);
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: not((msip = resize(0,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_dataIn = resize(0,32)));
	 at t: (COtoME_port_sig_addrIn = resize(33554432,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((msip = resize(0,32)));
	 at t: (COtoME_port_sig_addrIn = resize(33570816,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(33554432,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570816,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570820,32)));
	 at t: not((msip = resize(0,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((msip = resize(0,32)));
	 at t: (COtoME_port_sig_addrIn = resize(33570820,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33554432,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = msip_at_t;
	 at t_end: MEtoCP_data_loadedData = msip_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33570816,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = mtimecmpL_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimecmpL_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33570820,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = mtimecmpH_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimecmpH_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33603576,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = mtimeL_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimeL_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: not((COtoME_port_sig_addrIn = resize(33554432,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570816,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570820,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33603576,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33603580,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33603580,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = mtimeH_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimeH_at_t;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: (msip = resize(0,32));
	 at t: not(COtoME_port_sync);
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: (msip = resize(0,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_dataIn = resize(0,32));
	 at t: (COtoME_port_sig_addrIn = resize(33554432,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(33554432,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570816,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570820,32)));
	 at t: (msip = resize(0,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (msip = resize(0,32));
	 at t: (COtoME_port_sig_addrIn = resize(33570816,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_2_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_2;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (msip = resize(0,32));
	 at t: (COtoME_port_sig_addrIn = resize(33570820,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_3_write_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_3;
	 at t: not((msip = resize(0,32)));
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_3_write_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_3;
	 at t: (msip = resize(0,32));
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MSIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_4_write_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_4;
	 at t: MTIP_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_4_write_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_4;
	 at t: not(MTIP_port_sync);
prove:
	 at t_end: run_2;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
end property;

property run_5_write_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: (mtimecmpL <= mtimeL);
	 at t: (mtimecmpH <= mtimeH);
	 at t: MSIP_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_5_write_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: (mtimecmpL <= mtimeL);
	 at t: (mtimecmpH <= mtimeH);
	 at t: not(MSIP_port_sync);
prove:
	 at t_end: run_1;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = true;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_5_write_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: not(((mtimecmpL <= mtimeL) and (mtimecmpH <= mtimeH)));
	 at t: MSIP_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property run_5_write_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: not(((mtimecmpL <= mtimeL) and (mtimecmpH <= mtimeH)));
	 at t: not(MSIP_port_sync);
prove:
	 at t_end: run_4;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MTIP_port_sig = false;
	 at t_end: msip = msip_at_t;
	 at t_end: mtimeH = mtimeH_at_t;
	 at t_end: mtimeL = mtimeL_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_at_t = msip@t,
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_3;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_3;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip = msip_at_t;
	 at t+1: mtimeH = mtimeH_at_t;
	 at t+1: mtimeL = mtimeL_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: MSIP_port_notify = false;
	 at t+1: MTIP_port_notify = false;
end property;