-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
-- macro COtoME_port_notify :  boolean  := end macro;
-- macro COtoME_port_sync   :  boolean  := end macro;
-- macro MEtoCO_port_notify :  boolean  := end macro;
-- macro MEtoCO_port_sync   :  boolean  := end macro;
-- macro toSipStatus_notify :  boolean  := end macro;
-- macro toTimerStatus_H_notify :  boolean  := end macro;
-- macro toTimerStatus_L_notify :  boolean  := end macro;


-- DP SIGNALS -- 
macro COtoME_port_sig_addrIn : unsigned := COtoME_port.addrIn end macro;
macro COtoME_port_sig_dataIn : unsigned := COtoME_port.dataIn end macro;
macro COtoME_port_sig_mask : ME_MaskType := COtoME_port.mask end macro;
macro COtoME_port_sig_req : ME_AccessType := COtoME_port.req end macro;
macro MEtoCO_port_sig_loadedData : unsigned := MEtoCO_port.loadedData end macro;
macro fromTimer_H_sig : unsigned := fromTimer_H end macro;
macro fromTimer_L_sig : unsigned := fromTimer_L end macro;
macro toSipStatus_sig : unsigned := toSipStatus end macro;
macro toTimerStatus_H_sig : unsigned := toTimerStatus_H end macro;
macro toTimerStatus_L_sig : unsigned := toTimerStatus_L end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro MEtoCP_data_loadedData : unsigned := memoryResponse.loadedData end macro;
macro msip_data : unsigned := msip_reg end macro;
macro mtimecmpH : unsigned := mtimecmp_reg(63 downto 32) end macro;
macro mtimecmpL : unsigned := mtimecmp_reg(31 downto 0) end macro;


-- STATES -- 
macro run_0 : boolean := (section = read) end macro;
macro run_3 : boolean := (section = write_msip) end macro;
macro run_4 : boolean := (section = write_mtimecmp_L) end macro;
macro run_5 : boolean := (section = write_mtimecmp_H) end macro;
macro run_6 : boolean := (section = write_mtime_L) end macro;
macro run_7 : boolean := (section = write_mtime_H) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: MEtoCP_data_loadedData = resize(0,32);
	 at t: msip_data = resize(0,32);
	 at t: mtimecmpH = resize(2147483647,32);
	 at t: mtimecmpL = resize(2147483647,32);
	 at t: COtoME_port_notify = true;
	 at t: MEtoCO_port_notify = false;
	 at t: toSipStatus_notify = false;
	 at t: toTimerStatus_H_notify = false;
	 at t: toTimerStatus_L_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(33554432,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570816,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570820,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: not((COtoME_port_sig_addrIn = resize(33554432,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570816,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33570820,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33603576,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(33603580,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33554432,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: MEtoCO_port_sig_loadedData = msip_data_at_t;
	 at t_end: MEtoCP_data_loadedData = msip_data_at_t;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33570816,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: MEtoCO_port_sig_loadedData = mtimecmpL_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimecmpL_at_t;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33570820,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: MEtoCO_port_sig_loadedData = mtimecmpH_at_t;
	 at t_end: MEtoCP_data_loadedData = mtimecmpH_at_t;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33603576,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_6;
	 at t_end: MEtoCO_port_sig_loadedData = fromTimer_L_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = fromTimer_L_sig_at_t;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(33603580,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_7;
	 at t_end: MEtoCO_port_sig_loadedData = fromTimer_H_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = fromTimer_H_sig_at_t;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(33554432,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 at t_end: toSipStatus_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end-1]: toSipStatus_notify = false;
	 at t_end: toSipStatus_notify = true;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_0_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(33570816,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = COtoME_port_sig_dataIn_at_t;
	 at t_end: toTimerStatus_L_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end-1]: toTimerStatus_L_notify = false;
	 at t_end: toTimerStatus_L_notify = true;
end property;

property run_0_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	msip_data_at_t = msip_data@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(33570820,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = COtoME_port_sig_dataIn_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 at t_end: toTimerStatus_H_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end-1]: toTimerStatus_H_notify = false;
	 at t_end: toTimerStatus_H_notify = true;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_3_write_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_3;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_4_write_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_4;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_5_write_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_6_write_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_6;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property run_7_write_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_7;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: msip_data = msip_data_at_t;
	 at t_end: mtimecmpH = mtimecmpH_at_t;
	 at t_end: mtimecmpL = mtimecmpL_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toSipStatus_notify = false;
	 during[t+1, t_end]: toTimerStatus_H_notify = false;
	 during[t+1, t_end]: toTimerStatus_L_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_0;
	 at t: not(COtoME_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = true;
	 at t+1: MEtoCO_port_notify = false;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_3;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_3;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;

property wait_run_4 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_4;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_4;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;

property wait_run_5 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_5;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_5;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;

property wait_run_6 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_6;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_6;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;

property wait_run_7 is
dependencies: no_reset;
freeze:
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	msip_data_at_t = msip_data@t,
	mtimecmpH_at_t = mtimecmpH@t,
	mtimecmpL_at_t = mtimecmpL@t;
assume: 
	 at t: run_7;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_7;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: msip_data = msip_data_at_t;
	 at t+1: mtimecmpH = mtimecmpH_at_t;
	 at t+1: mtimecmpL = mtimecmpL_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toSipStatus_notify = false;
	 at t+1: toTimerStatus_H_notify = false;
	 at t+1: toTimerStatus_L_notify = false;
end property;