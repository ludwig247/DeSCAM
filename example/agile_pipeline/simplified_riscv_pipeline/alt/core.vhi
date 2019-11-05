-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro CUtoME_port_sync : boolean := end macro;
--macro MEtoCU_port_sync : boolean := end macro;
--macro CUtoME_port_notify : boolean := end macro;
--macro CUtoRF_port_notify : boolean := end macro;
--macro MEtoCU_port_notify : boolean := end macro;
macro dummyout_notify : boolean := clk end macro;


-- DP SIGNALS --
macro CUtoME_port_sig_addrIn : unsigned := CUtoME_port_sig.addrIn end macro;
macro CUtoME_port_sig_dataIn : unsigned := CUtoME_port_sig.dataIn end macro;
macro CUtoME_port_sig_mask : ME_MaskType := CUtoME_port_sig.mask end macro;
macro CUtoME_port_sig_req : ME_AccessType := CUtoME_port_sig.req end macro;
macro MEtoCU_port_sig_loadedData : unsigned := MEtoCU_port_sig.loadedData end macro;

macro dummyout_sig : boolean := false end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;
constraint only_nop := metocu_port_sig.loadeddata = resize(0,32); end constraint;
constraint sync := cutome_port_sync and metocu_port_sync; end constraint;
constraint bounded_wait :=
disable iff: rst=1;
  --if (read_access_o = '1' or write_access_o = '1') then
    exists i in 0.. 3 :
      next(cutome_port_sync, i) = '1' and next(metocu_port_sync, i) = '1';
    end exists;
  --end if;
end constraint;

-- VISIBLE REGISTERS --
macro CUtoME_data_if_addrIn : unsigned := CUtoME_data_if.addrIn end macro;
macro CUtoME_data_if_dataIn : unsigned := CUtoME_data_if.dataIn end macro;
macro CUtoME_data_if_mask : ME_MaskType := CUtoME_data_if.mask end macro;
macro CUtoME_data_if_req : ME_AccessType := CUtoME_data_if.req end macro;
macro CUtoME_data_me_addrIn : unsigned := CUtoME_data_me.addrIn end macro;
macro CUtoME_data_me_dataIn : unsigned := CUtoME_data_me.dataIn end macro;
macro CUtoME_data_me_mask : ME_MaskType := CUtoME_data_me.mask end macro;
macro CUtoME_data_me_req : ME_AccessType := CUtoME_data_me.req end macro;



macro CUtoME_data_addrIn : unsigned := CUtoME_data_if.addrIn end macro;
macro CUtoME_data_dataIn : unsigned := CUtoME_data_if.dataIn end macro;
macro CUtoME_data_mask : ME_MaskType := CUtoME_data_if.mask end macro;
macro CUtoME_data_req : ME_AccessType := CUtoME_data_if.req end macro;

macro MEtoCU_data_if_loadedData : unsigned := MEtoCU_data_if.loadedData end macro;
macro MEtoCU_data_de_loadedData : unsigned := MEtoCU_data_de.loadedData end macro;
macro MEtoCU_data_mem_loadedData : unsigned := MEtoCU_data_me.loadedData end macro;



-- STATES --
macro SEC_DE_0 : boolean := de_current_state = de_run end macro;
macro SEC_EX_1 : boolean := ex_current_state = ex_run end macro;
macro SEC_IF_2 : boolean := if_current_state = if_write end macro;
macro SEC_IF_3 : boolean := if_current_state = if_read end macro;
macro SEC_ME_4 : boolean := me_current_state = me_load_write end macro;
macro SEC_ME_5 : boolean := me_current_state = me_load_read end macro;
macro SEC_ME_6 : boolean := me_current_state = me_store_write end macro;
macro SEC_ME_7 : boolean := me_current_state = me_bypass end macro;
macro SEC_WB_8 : boolean := true end macro;


-- OPERATIONS --

property exclusiv_local_notify is
assume: 
	at t: CUtoME_port_notify = true;
prove: 
	at t: CUtoME_notify_if xor CUtoME_notify_me; 
end property;

property if_notify is
assume: 
	at t: CUtoME_notify_if = true;
prove: 
	at t: SEC_IF_2 and CUtoME_port_sig = CUtoME_data_if ;  
end property;

property me_notify is
assume: 
	at t: CUtoME_notify_me = true;
prove: 
	at t: SEC_ME_4 or SEC_ME_6 and CUtoME_port_sig = CUtoME_data_me;  
end property;


property CUtoME_data_if_change is
dependencies: no_reset, only_nop;
assume: 
	at t: not(SEC_IF_3);
prove:
	at t+1: CUtoME_data_if = prev(CUtoME_data_if);
end property;

property CUtoME_data_me_change is
dependencies: no_reset, only_nop;
assume: 
	at t: not(SEC_IF_3);
prove:
	at t+1: CUtoME_data_me = prev(CUtoME_data_me);
end property;

-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SEC_IF_2;
	 at t: CUtoME_data_if_addrIn = resize(0,32);
	 at t: CUtoME_data_if_dataIn = resize(0,32);
	 at t: CUtoME_data_if_mask = MT_W;
	 at t: CUtoME_data_if_req = ME_RD;
	 at t: CUtoME_data_me_addrIn = resize(0,32);
	 at t: CUtoME_data_me_dataIn = resize(0,32);
	 at t: CUtoME_data_me_mask = MT_W;
	 at t: CUtoME_data_me_req = ME_RD;
	 at t: CUtoME_port_sig_addrIn = resize(0,32);
	 at t: CUtoME_port_sig_dataIn = resize(0,32);
	 at t: CUtoME_port_sig_mask = MT_W;
	 at t: CUtoME_port_sig_req = ME_RD;
	 at t: MEtoCU_data_de_loadedData = resize(0,32);
	 at t: MEtoCU_data_if_loadedData = resize(0,32);
	 at t: MEtoCU_data_mem_loadedData = resize(0,32);
	 at t: CUtoME_port_notify = true;
	 at t: MEtoCU_port_notify = false;
	 at t: dummyout_notify = false;
end property;


property SEC_DE_0_write_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t;
assume:
	at t: SEC_DE_0;
prove:
	at t_end: SEC_EX_1;
	--at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	--at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	--at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	--at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	--at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	--at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	--at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	--at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_if_loadedData_at_t;
	--at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	--at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	--at t_end: dummyout_sig = false;
	--during[t+1, t_end]: CUtoME_port_notify = false;
	--during[t+1, t_end]: MEtoCU_port_notify = false;
	--during[t+1, t_end-1]: dummyout_notify = false;
	--at t_end: dummyout_notify = true;
	at t_end: CUtoME_port_notify = CUtoME_notify_me or CUtoME_notify_if;
local_determination_requirements:
  at t_end: determined(MEtoCU_data_de.loadedData);
end property;


property SEC_EX_1_write_1 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t;
assume:
	at t: SEC_EX_1;
	at t: (getOpCode(MEtoCU_data_de_loadedData) = LOAD);
prove:
	at t_end: SEC_ME_4;
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = 0;
	at t_end: CUtoME_data_me_dataIn = 0;
	at t_end: CUtoME_data_me_mask = MT_W;
	at t_end: CUtoME_data_me_req = ME_WR;
	at t_end: CUtoME_port_sig_addrIn = 0;
	at t_end: CUtoME_port_sig_dataIn = 0;
	at t_end: CUtoME_port_sig_mask = MT_W;
	at t_end: CUtoME_port_sig_req = ME_WR;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_de_loadedData_at_t;
	during[t+1, t_end-1]: CUtoME_port_notify = false;
	at t_end: CUtoME_port_notify = true;
	during[t+1, t_end]: MEtoCU_port_notify = false;
	during[t+1, t_end]: dummyout_notify = false;
end property;


property SEC_EX_1_write_2 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t;
assume:
	at t: SEC_EX_1;
	at t: not((getOpCode(MEtoCU_data_de_loadedData) = LOAD));
	at t: (getOpCode(MEtoCU_data_de_loadedData) = STORE);
prove:
	at t_end: SEC_ME_6;
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = 0;
	at t_end: CUtoME_data_me_dataIn = 0;
	at t_end: CUtoME_data_me_mask = MT_W;
	at t_end: CUtoME_data_me_req = ME_RD;
	at t_end: CUtoME_port_sig_addrIn = 0;
	at t_end: CUtoME_port_sig_dataIn = 0;
	at t_end: CUtoME_port_sig_mask = MT_W;
	at t_end: CUtoME_port_sig_req = ME_RD;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_de_loadedData_at_t;
	during[t+1, t_end-1]: CUtoME_port_notify = false;
	at t_end: CUtoME_port_notify = true;
	during[t+1, t_end]: MEtoCU_port_notify = false;
	during[t+1, t_end]: dummyout_notify = false;
end property;


property SEC_EX_1_write_3 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t;
assume:
	at t: SEC_EX_1;
	at t: not((getOpCode(MEtoCU_data_de_loadedData) = LOAD));
	at t: not((getOpCode(MEtoCU_data_de_loadedData) = STORE));
prove:
	at t_end: SEC_ME_7;
	--at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	--at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	--at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	--at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	--at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	--at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_de_loadedData_at_t;
	--at t_end: dummyout_sig = false;
	at t_end: CUtoME_port_notify = CUtoME_notify_me or CUtoME_notify_if; -- replace with local notify
	during[t+1, t_end]: CUtoME_notify_me = false; -- replace with local notify
	during[t+1, t_end]: MEtoCU_notify_me = false;
	--during[t+1, t_end-1]: dummyout_notify = false;
	--at t_end: dummyout_notify = true;
end property;


property SEC_IF_2_write_4 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t;
assume:
	at t: SEC_IF_2;
	at t: CUtoME_port_sync;
prove:
	at t_end: SEC_IF_3;
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: CUtoME_notify_if = false;
	at t_end: CUtoME_notify_me = false;
	during[t+1, t_end]: CUtoME_port_notify = false;
	at t_end: CUtoME_port_notify = false;
	during[t+1, t_end-1]: MEtoCU_port_notify = false;
	at t_end: MEtoCU_port_notify = true;
	
local_determination_requirements:
  at t_end: determined(CUtoME_data_if);
  at t_end: determined(MEtoCU_data_if);
  at t_end: determined(CUtoME_notify_if);
  at t_end: determined(CUtoME_notify_me);
end property;


property SEC_IF_3_read_5 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t;
assume:
	at t: SEC_IF_3;
	at t: MEtoCU_port_sync;
prove:
	at t_end: SEC_DE_0;
	at t_end: CUtoME_data_if_addrIn = (4 + CUtoME_data_if_addrIn_at_t)(31 downto 0);
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: MEtoCU_data_if_loadedData = 0;

	--during[t+1, t_end]: CUtoME_port_notify = false; replace with local _notify
	at t_end: CUtoME_port_notify = true; 
	at t_end: CUtoME_port_sig = next(CUtoME_data_if);
	-- during[t+1, t_end]: CUtoME_notify_if = false; --local notify ... does not work ... already new operation starting
	during[t+1, t_end]: MEtoCU_port_notify = false;

right_hook: t_end;
end property;


property SEC_ME_4_write_6 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_4;
	at t: CUtoME_port_sync;
prove:
	at t_end: SEC_ME_5;
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	during[t+1, t_end]: CUtoME_port_notify = false;
	during[t+1, t_end-1]: MEtoCU_port_notify = false;
	at t_end: MEtoCU_port_notify = true;
	during[t+1, t_end]: dummyout_notify = false;
end property;

property SEC_ME_5_read_7 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_port_sig_loadedData_at_t = MEtoCU_port_sig_loadedData@t;
assume:
	at t: SEC_ME_5;
	at t: MEtoCU_port_sync;
prove:
	at t_end: SEC_WB_8;
	at t_end: me_current_state = me_idle; -- added for completeness
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_port_sig_loadedData_at_t;
	at t_end: dummyout_sig = false;
	during[t+1, t_end]: CUtoME_port_notify = false;
	during[t+1, t_end]: MEtoCU_port_notify = false;
	during[t+1, t_end-1]: dummyout_notify = false;
	at t_end: dummyout_notify = true;
end property;

property SEC_ME_6_write_8 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_6;
	at t: CUtoME_port_sync;
prove:
	at t_end: SEC_WB_8;
	at t_end: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t_end: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t_end: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t_end: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t_end: dummyout_sig = false;
	during[t+1, t_end]: CUtoME_port_notify = false;
	during[t+1, t_end]: MEtoCU_port_notify = false;
	during[t+1, t_end-1]: dummyout_notify = false;
	at t_end: dummyout_notify = true;
end property;


property SEC_ME_7_write_9 is
dependencies: no_reset,only_nop;
for timepoints:
	t_end = t+1;
freeze:

	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_7;
prove:
	at t_end: SEC_WB_8;
	
	at t_end: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t_end: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t_end: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t_end: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t_end: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;

	-- replace with local notify
	at t_end: CUtoME_notify_me = false; 
	at t_end: MEtoCU_notify_me = false;

local_determination_requirements:
  at t_end: determined(if_current_state);
end property;


property SEC_WB_8_write_10 is
dependencies: no_reset, only_nop,bounded_wait;
for timepoints:
	t_end = t + 1  .. 5 waits_for complete  if_current_state = if_write;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@(t_end),
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_WB_8;
prove:
	at t_end: SEC_IF_2;

	at t_end: CUtoME_port_sig_addrIn = CUtoME_data_if_addrIn_at_t;
	at t_end: CUtoME_port_sig_dataIn = CUtoME_data_if_dataIn_at_t;
	at t_end: CUtoME_port_sig_mask = MT_W;
	at t_end: CUtoME_port_sig_req = ME_RD;
right_hook: t_end;

end property;


property wait_SEC_IF_2 is
dependencies: no_reset;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_IF_2;
	at t: not(CUtoME_port_sync);
prove:
	at t+1: SEC_IF_2;
	at t+1: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t+1: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t+1: CUtoME_port_sig_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_port_sig_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_port_sig_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_port_sig_req = CUtoME_data_if_req_at_t;
	at t+1: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t+1: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
--	at t+1: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t+1: CUtoME_port_notify = true;
	at t+1: MEtoCU_port_notify = false;
	at t+1: dummyout_notify = false;
end property;


property wait_SEC_IF_3 is
dependencies: no_reset,only_nop;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_IF_3;
	at t: not(MEtoCU_port_sync);
prove:
	at t+1: SEC_IF_3;
	at t+1: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t+1: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t+1: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
--	at t+1: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
--	at t+1: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t+1: CUtoME_port_notify = false;
	at t+1: MEtoCU_port_notify = true;
	at t+1: dummyout_notify = false;
end property;


property wait_SEC_ME_4 is
dependencies: no_reset;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_4;
	at t: not(CUtoME_port_sync);
prove:
	at t+1: SEC_ME_4;
	at t+1: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t+1: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t+1: CUtoME_port_sig_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_port_sig_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_port_sig_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_port_sig_req = CUtoME_data_me_req_at_t;
	at t+1: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t+1: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t+1: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t+1: CUtoME_port_notify = true;
	at t+1: MEtoCU_port_notify = false;
	at t+1: dummyout_notify = false;
end property;


property wait_SEC_ME_5 is
dependencies: no_reset;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_5;
	at t: not(MEtoCU_port_sync);
prove:
	at t+1: SEC_ME_5;
	at t+1: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t+1: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t+1: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t+1: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t+1: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t+1: CUtoME_port_notify = false;
	at t+1: MEtoCU_port_notify = true;
	at t+1: dummyout_notify = false;
end property;


property wait_SEC_ME_6 is
dependencies: no_reset;
freeze:
	CUtoME_data_if_addrIn_at_t = CUtoME_data_if_addrIn@t,
	CUtoME_data_if_dataIn_at_t = CUtoME_data_if_dataIn@t,
	CUtoME_data_if_mask_at_t = CUtoME_data_if_mask@t,
	CUtoME_data_if_req_at_t = CUtoME_data_if_req@t,
	CUtoME_data_me_addrIn_at_t = CUtoME_data_me_addrIn@t,
	CUtoME_data_me_dataIn_at_t = CUtoME_data_me_dataIn@t,
	CUtoME_data_me_mask_at_t = CUtoME_data_me_mask@t,
	CUtoME_data_me_req_at_t = CUtoME_data_me_req@t,
	MEtoCU_data_de_loadedData_at_t = MEtoCU_data_de_loadedData@t,
	MEtoCU_data_if_loadedData_at_t = MEtoCU_data_if_loadedData@t,
	MEtoCU_data_mem_loadedData_at_t = MEtoCU_data_mem_loadedData@t;
assume:
	at t: SEC_ME_6;
	at t: not(CUtoME_port_sync);
prove:
	at t+1: SEC_ME_6;
	at t+1: CUtoME_data_if_addrIn = CUtoME_data_if_addrIn_at_t;
	at t+1: CUtoME_data_if_dataIn = CUtoME_data_if_dataIn_at_t;
	at t+1: CUtoME_data_if_mask = CUtoME_data_if_mask_at_t;
	at t+1: CUtoME_data_if_req = CUtoME_data_if_req_at_t;
	at t+1: CUtoME_data_me_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_data_me_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_data_me_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_data_me_req = CUtoME_data_me_req_at_t;
	at t+1: CUtoME_port_sig_addrIn = CUtoME_data_me_addrIn_at_t;
	at t+1: CUtoME_port_sig_dataIn = CUtoME_data_me_dataIn_at_t;
	at t+1: CUtoME_port_sig_mask = CUtoME_data_me_mask_at_t;
	at t+1: CUtoME_port_sig_req = CUtoME_data_me_req_at_t;
	at t+1: MEtoCU_data_de_loadedData = MEtoCU_data_de_loadedData_at_t;
	at t+1: MEtoCU_data_if_loadedData = MEtoCU_data_if_loadedData_at_t;
	at t+1: MEtoCU_data_mem_loadedData = MEtoCU_data_mem_loadedData_at_t;
	at t+1: CUtoME_port_notify = true;
	at t+1: MEtoCU_port_notify = false;
	at t+1: dummyout_notify = false;
end property;