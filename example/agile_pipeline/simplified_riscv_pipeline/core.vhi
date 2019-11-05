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
 -- if (CUtoME_port_notify = '1' or MEtoCU_port_notify = '1') then
    exists i in 0 .. 4 :
      next(cutome_port_sync, i) = '1' and next(metocu_port_sync, i) = '1';
    end exists;
 -- end if;
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

assertion if_2_to_if_3 :=
 if(not(rst) and not(prev(rst)) and CUtoME_port_sync and SEC_IF_2) then 
	next(SEC_IF_3);
end if;
end assertion;


assertion if_3_to_de_0 :=
 if(not(rst) and not(prev(rst)) and MEtoCU_port_sync and SEC_IF_3) then 
	next(SEC_DE_0);
end if;
end assertion;


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
	at t: SEC_IF_2 and CUtoME_port_sig = CUtoME_data_if;  
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

----------------
property test is 
dependencies: no_reset,only_nop,bounded_wait;
--dependencies: no_reset, only_nop,bounded_wait;
for timepoints:
	t_if_3 = t+ 1 .. 5 waits_for SEC_IF_3,
	t_de = t_if_3 + 1 .. 5 waits_for SEC_DE_0;
	--t_ex = t_de + 1 .. 5 waits_for  SEC_EX_1,
	--t_me = t_ex + 1 .. 5 waits_for  SEC_ME_7,
	--t_wb = t_me + 1 .. 5 waits_for  SEC_IF_2;
	
assume:
	at t: SEC_IF_2;
	at t_if_3: SEC_IF_3;
	at t_de: SEC_DE_0;

prove:		
	at t_if_3: SEC_IF_3;
	at t_de: SEC_DE_0;
	during[t, t_if_3-1]: CUtoME_port_notify = true;
	at t_if_3: CUtoME_port_notify = false;

	during[t_if_3, t_de-1]: MEtoCU_port_notify = true;
	at t_de: MEtoCU_port_notify = false;	

right_hook: t_if_3;

--local_determination_requirements:
--  at t_if_3: determined(if_current_state);

end property;


property test_not1 is 
dependencies: no_reset,only_nop,bounded_wait;
--dependencies: no_reset, only_nop,bounded_wait;
for timepoints:
	t_if_3 = t+ 1 .. 5 waits_for not(SEC_IF_3),
	t_de = t_if_3 + 1 .. 5 waits_for not(SEC_DE_0);
	--t_ex = t_de + 1 .. 5 waits_for  SEC_EX_1 ,
	--t_me = t_ex + 1 .. 5 waits_for  SEC_ME_7,
	--t_wb = t_me + 1 .. 5 waits_for  SEC_IF_2;
	
assume:
	at t: SEC_IF_2;
	--at t_if_3: not(SEC_IF_3);
	--at t_de: not(SEC_DE_0);
prove:		
	at t_if_3: SEC_IF_2;

right_hook: t+1;

end property;

property test_not2 is 
dependencies: no_reset,only_nop,bounded_wait;
--dependencies: no_reset, only_nop,bounded_wait;
for timepoints:
	t_if_3 = t+ 1 .. 5 waits_for SEC_IF_3,
	t_de = t_if_3 + 1 .. 5 waits_for not(SEC_DE_0);
	--t_ex = t_de + 1 .. 5 waits_for  SEC_EX_1 ,
	--t_me = t_ex + 1 .. 5 waits_for  SEC_ME_7,
	--t_wb = t_me + 1 .. 5 waits_for  SEC_IF_2;
	
assume:
	at t: SEC_IF_2;
	at t_if_3: (SEC_IF_3);
	at t_de: not(SEC_DE_0);
prove:		
	at t: true;

right_hook: t_de;

end property;

property test_not3 is 
dependencies: no_reset,only_nop,bounded_wait;
--dependencies: no_reset, only_nop,bounded_wait;
for timepoints:
	t_if_3 = t+ 1 .. 5 waits_for not(SEC_IF_3),
	t_de = t_if_3 + 1 .. 5 waits_for SEC_DE_0;
	--t_ex = t_de + 1 .. 5 waits_for  SEC_EX_1 ,
	--t_me = t_ex + 1 .. 5 waits_for  SEC_ME_7,
	--t_wb = t_me + 1 .. 5 waits_for  SEC_IF_2;
	
assume:
	at t: SEC_IF_2;
	at t_if_3: not(SEC_IF_3);
	at t_de: (SEC_DE_0);
prove:		
	at t: true;

right_hook: t_de;

end property;


property test_not4 is 
dependencies: no_reset,only_nop,bounded_wait;
--dependencies: no_reset, only_nop,bounded_wait;
--for timepoints:
	--t_if_3 = t+ 1 .. 5 waits_for not(SEC_IF_3),
	--t_de = t_if_3 + 1 .. 5 waits_for SEC_DE_0;
	--t_ex = t_de + 1 .. 5 waits_for  SEC_EX_1 ,
	--t_me = t_ex + 1 .. 5 waits_for  SEC_ME_7,
	--t_wb = t_me + 1 .. 5 waits_for  SEC_IF_2;
	
assume:
	at t: not(SEC_IF_2);
prove:		
	at t: true;

right_hook: t+1;

end property;



-- OPERATIONS --
property reset is
dependencies: if_2_to_if_3,if_3_to_de_0;
for timepoints:
	t_if_3 = t+ 0 .. 5 waits_for prev(not(rst) and (CUtoME_port_sync)),
	t_de = t_if_3 + 1 .. 5 waits_for prev((MEtoCU_port_notify and MEtoCU_port_sync));
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
	 at t_if_3: if_current_state = if_read;
right_hook: t;
--local_determination_requirements:
  --at t_if_3: determined(if_current_state);

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