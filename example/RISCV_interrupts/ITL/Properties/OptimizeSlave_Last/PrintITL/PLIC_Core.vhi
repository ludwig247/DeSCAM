-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro fromGateway_Int1_sync   :  boolean  := end macro; 
macro fromGateway_Int2_sync   :  boolean  := end macro; 
macro fromMemory_Claimed_sync   :  boolean  := end macro; 
macro fromMemory_Enabled_sync   :  boolean  := end macro; 
macro fromMemory_Priority_Int_1_sync   :  boolean  := end macro; 
macro fromMemory_Priority_Int_2_sync   :  boolean  := end macro; 
macro fromMemory_Threshold_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro MEIP_port_sig : boolean := end macro; 
macro fromGateway_Int1_sig : boolean := end macro; 
macro fromGateway_Int2_sig : boolean := end macro; 
macro fromMemory_Claimed_sig : unsigned := end macro; 
macro fromMemory_Enabled_sig : unsigned := end macro; 
macro fromMemory_Priority_Int_1_sig : unsigned := end macro; 
macro fromMemory_Priority_Int_2_sig : unsigned := end macro; 
macro fromMemory_Threshold_sig : unsigned := end macro; 
macro toMemory_MaxID_sig : unsigned := end macro; 
macro toMemory_MaxPriority_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro claimed_data : unsigned := end macro; 
macro enabled_data : unsigned := end macro; 
macro max_id : unsigned := end macro; 
macro max_priority : unsigned := end macro; 
macro pending_Int_1_data : boolean := end macro; 
macro pending_Int_2_data : boolean := end macro; 
macro priority_Int_1_data : unsigned := end macro; 
macro priority_Int_2_data : unsigned := end macro; 
macro threshold_data : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: claimed_data = resize(0,32);
	 at t: enabled_data = resize(0,32);
	 at t: max_id = resize(0,32);
	 at t: max_priority = resize(0,32);
	 at t: pending_Int_1_data = false;
	 at t: pending_Int_2_data = false;
	 at t: priority_Int_1_data = resize(0,32);
	 at t: priority_Int_2_data = resize(0,32);
	 at t: threshold_data = resize(0,32);
end property;


property run_0_read_2001 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2002 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2003 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2004 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2005 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2006 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2007 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	max_id_at_t = max_id@t,
	max_priority_at_t = max_priority@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = max_id_at_t;
	 at t+1: max_priority = max_priority_at_t;
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = max_id_at_t;
	 at t+1: toMemory_MaxPriority_sig = max_priority_at_t;
end property;

property run_0_read_2008 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2009 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2010 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2011 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2012 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2013 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2014 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2015 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	fromMemory_Threshold_sig_at_t = fromMemory_Threshold_sig@t,
	max_id_at_t = max_id@t,
	max_priority_at_t = max_priority@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= fromMemory_Threshold_sig);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: fromMemory_Threshold_sync;
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = max_id_at_t;
	 at t+1: max_priority = max_priority_at_t;
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = fromMemory_Threshold_sig_at_t;
	 at t+1: toMemory_MaxID_sig = max_id_at_t;
	 at t+1: toMemory_MaxPriority_sig = max_priority_at_t;
end property;

property run_0_read_2016 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2017 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2018 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2019 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2020 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2021 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2022 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2023 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2024 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2025 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2026 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2027 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2028 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2029 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2030 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2031 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2032 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2033 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2034 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2035 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2036 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2037 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2038 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	fromMemory_Claimed_sync_at_t = fromMemory_Claimed_sync@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,1,pending_Int_1_data_at_t),manageInt_Claim(fromMemory_Claimed_sig_at_t,fromMemory_Claimed_sync_at_t,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2039 is
dependencies: no_reset;
freeze:
	enabled_data_at_t = enabled_data@t,
	fromMemory_Claimed_sig_at_t = fromMemory_Claimed_sig@t,
	max_id_at_t = max_id@t,
	max_priority_at_t = max_priority@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(1,32),pending_Int_1_data),manageInt_Claim(fromMemory_Claimed_sig,fromMemory_Claimed_sync,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: fromMemory_Claimed_sync;
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = fromMemory_Claimed_sig_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = max_id_at_t;
	 at t+1: max_priority = max_priority_at_t;
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = max_id_at_t;
	 at t+1: toMemory_MaxPriority_sig = max_priority_at_t;
end property;

property run_0_read_2040 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2041 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2042 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2043 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2044 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2045 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2046 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not((getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data));
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = true;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: max_priority = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = getId(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0,0);
	 at t+1: toMemory_MaxPriority_sig = getPriority(enabled_data_at_t,manageInt_Claim(claimed_data_at_t,false,1,pending_Int_1_data_at_t),manageInt_Claim(claimed_data_at_t,false,2,pending_Int_2_data_at_t),priority_Int_1_data_at_t,priority_Int_2_data_at_t,0);
end property;

property run_0_read_2047 is
dependencies: no_reset;
freeze:
	claimed_data_at_t = claimed_data@t,
	enabled_data_at_t = enabled_data@t,
	max_id_at_t = max_id@t,
	max_priority_at_t = max_priority@t,
	pending_Int_1_data_at_t = pending_Int_1_data@t,
	pending_Int_2_data_at_t = pending_Int_2_data@t,
	priority_Int_1_data_at_t = priority_Int_1_data@t,
	priority_Int_2_data_at_t = priority_Int_2_data@t,
	threshold_data_at_t = threshold_data@t;
assume: 
	 at t: run_0;
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: (getPriority(enabled_data,manageInt_Claim(claimed_data,false,resize(1,32),pending_Int_1_data),manageInt_Claim(claimed_data,false,resize(2,32),pending_Int_2_data),priority_Int_1_data,priority_Int_2_data,resize(0,32)) <= threshold_data);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
	 at t: not(fromGateway_Int1_sync);
	 at t: not(fromGateway_Int2_sync);
	 at t: not(fromMemory_Priority_Int_1_sync);
	 at t: not(fromMemory_Priority_Int_2_sync);
	 at t: not(fromMemory_Enabled_sync);
	 at t: not(fromMemory_Threshold_sync);
	 at t: not(fromMemory_Claimed_sync);
prove:
	 at t+1: run_0;
	 at t+1: MEIP_port_sig = false;
	 at t+1: claimed_data = claimed_data_at_t;
	 at t+1: enabled_data = enabled_data_at_t;
	 at t+1: max_id = max_id_at_t;
	 at t+1: max_priority = max_priority_at_t;
	 at t+1: pending_Int_1_data = pending_Int_1_data_at_t;
	 at t+1: pending_Int_2_data = pending_Int_2_data_at_t;
	 at t+1: priority_Int_1_data = priority_Int_1_data_at_t;
	 at t+1: priority_Int_2_data = priority_Int_2_data_at_t;
	 at t+1: threshold_data = threshold_data_at_t;
	 at t+1: toMemory_MaxID_sig = max_id_at_t;
	 at t+1: toMemory_MaxPriority_sig = max_priority_at_t;
end property;