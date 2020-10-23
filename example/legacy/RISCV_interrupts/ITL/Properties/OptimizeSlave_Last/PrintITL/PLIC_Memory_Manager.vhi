-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
-- macro COtoME_port_notify :  boolean  := end macro;
-- macro COtoME_port_sync   :  boolean  := end macro;
-- macro MEtoCO_port_notify :  boolean  := end macro;
-- macro MEtoCO_port_sync   :  boolean  := end macro;
-- macro toCore_Claimed_notify :  boolean  := end macro;
-- macro toCore_Enabled_notify :  boolean  := end macro;
-- macro toCore_Priority_Int_1_notify :  boolean  := end macro;
-- macro toCore_Priority_Int_2_notify :  boolean  := end macro;
-- macro toCore_Threshold_notify :  boolean  := end macro;
-- macro toGatewayPending_1_notify :  boolean  := end macro;
-- macro toGatewayPending_2_notify :  boolean  := end macro;


-- DP SIGNALS -- 
macro COtoME_port_sig_addrIn : unsigned := COtoME_port.addrIn end macro;
macro COtoME_port_sig_dataIn : unsigned := COtoME_port.dataIn end macro;
macro COtoME_port_sig_mask : ME_MaskType := COtoME_port.mask end macro;
macro COtoME_port_sig_req : ME_AccessType := COtoME_port.req end macro;
macro MEtoCO_port_sig_loadedData : unsigned := MEtoCO_port.loadedData end macro;
macro fromCore_MaxID_sig : unsigned := fromCore_MaxID end macro;
macro fromCore_MaxPriority_sig : unsigned := fromCore_MaxPriority end macro;
macro toCore_Claimed_sig : unsigned := toCore_Claimed end macro;
macro toCore_Enabled_sig : unsigned := toCore_Enabled end macro;
macro toCore_Priority_Int_1_sig : unsigned := toCore_Priority_Int_1 end macro;
macro toCore_Priority_Int_2_sig : unsigned := toCore_Priority_Int_2 end macro;
macro toCore_Threshold_sig : unsigned := toCore_Threshold end macro;
macro toGatewayPending_1_sig : boolean := toGatewayPending_1 end macro;
macro toGatewayPending_2_sig : boolean := toGatewayPending_2 end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
-- macro ClaimComplete : unsigned := end macro;
macro MEtoCP_data_loadedData : unsigned := memoryResponse.loadedData end macro;
-- macro enabled_data : unsigned := end macro;
-- macro priority_Int_1_data : unsigned := end macro;
-- macro priority_Int_2_data : unsigned := end macro;
-- macro threshold_data : unsigned := end macro;


-- STATES -- 
macro run_0 : boolean := (section = read) end macro;
macro run_3 : boolean := (section = write_prio_1) end macro;
macro run_4 : boolean := (section = write_prio_2) end macro;
macro run_5 : boolean := (section = write_enabled) end macro;
macro run_6 : boolean := (section = write_threshold) end macro;
macro run_8 : boolean := (section = write_claim) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: ClaimComplete = resize(0,32);
	 at t: MEtoCP_data_loadedData = resize(0,32);
	 at t: enabled_data = resize(0,32);
	 at t: priority_Int_1_data = resize(0,32);
	 at t: priority_Int_2_data = resize(0,32);
	 at t: threshold_data = resize(0,32);
	 at t: COtoME_port_notify = true;
	 at t: MEtoCO_port_notify = false;
	 at t: toCore_Claimed_notify = false;
	 at t: toCore_Enabled_notify = false;
	 at t: toCore_Priority_Int_1_notify = false;
	 at t: toCore_Priority_Int_2_notify = false;
	 at t: toCore_Threshold_notify = false;
	 at t: toGatewayPending_1_notify = false;
	 at t: toGatewayPending_2_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: not((COtoME_port_sig_addrIn = resize(201326592,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201326596,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201334784,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423744,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423748,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: not((COtoME_port_sig_addrIn = resize(201326592,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201326596,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201334784,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423744,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423748,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(201326592,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201326596,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201330688,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201330692,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201334784,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423744,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423748,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(201326592,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201326596,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201330688,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201330692,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(201334784,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423744,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(203423748,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(203423748,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = COtoME_port_sig_dataIn_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(203423748,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = COtoME_port_sig_dataIn_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201326592,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = priority_Int_1_data_at_t;
	 at t_end: MEtoCP_data_loadedData = priority_Int_1_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201326592,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = priority_Int_1_data_at_t;
	 at t_end: MEtoCP_data_loadedData = priority_Int_1_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201326596,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = priority_Int_2_data_at_t;
	 at t_end: MEtoCP_data_loadedData = priority_Int_2_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201326596,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_4;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = priority_Int_2_data_at_t;
	 at t_end: MEtoCP_data_loadedData = priority_Int_2_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201334784,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = enabled_data_at_t;
	 at t_end: MEtoCP_data_loadedData = enabled_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(201334784,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_5;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = enabled_data_at_t;
	 at t_end: MEtoCP_data_loadedData = enabled_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(203423744,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_6;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = threshold_data_at_t;
	 at t_end: MEtoCP_data_loadedData = threshold_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(203423744,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_6;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = threshold_data_at_t;
	 at t_end: MEtoCP_data_loadedData = threshold_data_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(203423748,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_8;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = ClaimComplete_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Claimed_sig = ClaimComplete_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end-1]: toCore_Claimed_notify = false;
	 at t_end: toCore_Claimed_notify = true;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(203423748,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_8;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = fromCore_MaxID_sig_at_t;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Claimed_sig = fromCore_MaxID_sig_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
	 during[t+1, t_end-1]: toCore_Claimed_notify = false;
	 at t_end: toCore_Claimed_notify = true;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201326592,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Priority_Int_1_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end-1]: toCore_Priority_Int_1_notify = false;
	 at t_end: toCore_Priority_Int_1_notify = true;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201326592,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Priority_Int_1_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end-1]: toCore_Priority_Int_1_notify = false;
	 at t_end: toCore_Priority_Int_1_notify = true;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201326596,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Priority_Int_2_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end-1]: toCore_Priority_Int_2_notify = false;
	 at t_end: toCore_Priority_Int_2_notify = true;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201326596,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Priority_Int_2_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end-1]: toCore_Priority_Int_2_notify = false;
	 at t_end: toCore_Priority_Int_2_notify = true;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201330688,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toGatewayPending_1_sig = true;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end-1]: toGatewayPending_1_notify = false;
	 at t_end: toGatewayPending_1_notify = true;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201330688,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toGatewayPending_1_sig = true;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end-1]: toGatewayPending_1_notify = false;
	 at t_end: toGatewayPending_1_notify = true;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201330692,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toGatewayPending_2_sig = true;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end-1]: toGatewayPending_2_notify = false;
	 at t_end: toGatewayPending_2_notify = true;
end property;

property run_0_read_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201330692,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toGatewayPending_2_sig = true;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end-1]: toGatewayPending_2_notify = false;
	 at t_end: toGatewayPending_2_notify = true;
end property;

property run_0_read_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201334784,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Enabled_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end-1]: toCore_Enabled_notify = false;
	 at t_end: toCore_Enabled_notify = true;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(201334784,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 at t_end: toCore_Enabled_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end-1]: toCore_Enabled_notify = false;
	 at t_end: toCore_Enabled_notify = true;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (fromCore_MaxID_sig = ClaimComplete);
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(203423744,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: toCore_Threshold_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end-1]: toCore_Threshold_notify = false;
	 at t_end: toCore_Threshold_notify = true;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_0_read_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	enabled_data_at_t = enabled_data@t,
	fromCore_MaxID_sig_at_t = fromCore_MaxID_sig@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: not((fromCore_MaxID_sig = ClaimComplete));
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_addrIn = resize(203423744,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = fromCore_MaxID_sig_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = COtoME_port_sig_dataIn_at_t;
	 at t_end: toCore_Threshold_sig = COtoME_port_sig_dataIn_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end-1]: toCore_Threshold_notify = false;
	 at t_end: toCore_Threshold_notify = true;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_3_write_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_3;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_4_write_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_4;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_5_write_32 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_5;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_6_write_33 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_6;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property run_8_write_34 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_8;
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: enabled_data = enabled_data_at_t;
	 at t_end: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t_end: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t_end: threshold_data = threshold_data_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
	 during[t+1, t_end]: toCore_Claimed_notify = false;
	 during[t+1, t_end]: toCore_Enabled_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_1_notify = false;
	 during[t+1, t_end]: toCore_Priority_Int_2_notify = false;
	 during[t+1, t_end]: toCore_Threshold_notify = false;
	 during[t+1, t_end]: toGatewayPending_1_notify = false;
	 during[t+1, t_end]: toGatewayPending_2_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not(COtoME_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = true;
	 at t+1: MEtoCO_port_notify = false;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_3;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_3;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;

property wait_run_4 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_4;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_4;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;

property wait_run_5 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_5;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_5;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;

property wait_run_6 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_6;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_6;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;

property wait_run_8 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	enabled_data_at_t = enabled_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_8;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_8;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
	 at t+1: toCore_Claimed_notify = false;
	 at t+1: toCore_Enabled_notify = false;
	 at t+1: toCore_Priority_Int_1_notify = false;
	 at t+1: toCore_Priority_Int_2_notify = false;
	 at t+1: toCore_Threshold_notify = false;
	 at t+1: toGatewayPending_1_notify = false;
	 at t+1: toGatewayPending_2_notify = false;
end property;