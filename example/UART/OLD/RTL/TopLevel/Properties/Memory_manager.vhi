-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro bus_to_mem_man_notify :  boolean  := end macro; 
--macro bus_to_mem_man_sync   :  boolean  := end macro; 
--macro mem_man_to_bus_notify :  boolean  := end macro; 
--macro mem_man_to_bus_sync   :  boolean  := end macro; 
--macro mem_man_to_ctrl_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro bus_to_mem_man_sig_addrIn : unsigned := bus_to_mem_man.addrIn end macro; 
macro bus_to_mem_man_sig_dataIn : unsigned := bus_to_mem_man.dataIn end macro; 
macro bus_to_mem_man_sig_mask : ME_MaskType := bus_to_mem_man.mask end macro; 
macro bus_to_mem_man_sig_req : ME_AccessType := bus_to_mem_man.req end macro; 
macro ctrl_to_mem_man_sig_CR_reg : unsigned := ctrl_to_mem_man.CR_reg end macro; 
macro ctrl_to_mem_man_sig_DR_reg : unsigned := ctrl_to_mem_man.DR_reg end macro; 
macro ctrl_to_mem_man_sig_SR_reg : unsigned := ctrl_to_mem_man.SR_reg end macro; 
macro ctrl_to_mem_man_sig_r_act : reg_action := ctrl_to_mem_man.r_act end macro; 
macro mem_man_to_bus_sig_loadedData : unsigned := mem_man_to_bus.loadedData end macro; 
macro mem_man_to_ctrl_sig_addrIn : unsigned := mem_man_to_ctrl.addrIn end macro; 
macro mem_man_to_ctrl_sig_dataIn : unsigned := mem_man_to_ctrl.dataIn end macro; 
macro mem_man_to_ctrl_sig_mask : ME_MaskType := mem_man_to_ctrl.mask end macro; 
macro mem_man_to_ctrl_sig_req : ME_AccessType := mem_man_to_ctrl.req end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro response_loadedData : unsigned := response_signal.loadedData end macro; 


-- STATES -- 
macro run_0 : boolean := 
section = RUN1

--mem_man_to_bus_notify = false and
--mem_man_to_ctrl_notify = true and

end macro;
macro run_3 : boolean :=
section = RUN2

--bus_to_mem_man_notify = false and
--mem_man_to_bus_notify = false and
--mem_man_to_ctrl_notify = true
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: response_loadedData = resize(0,32);
	 at t: bus_to_mem_man_notify = true;
	 at t: mem_man_to_bus_notify = false;
	 at t: mem_man_to_ctrl_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	bus_to_mem_man_sig_addrIn_at_t = bus_to_mem_man_sig_addrIn@t,
	bus_to_mem_man_sig_dataIn_at_t = bus_to_mem_man_sig_dataIn@t,
	bus_to_mem_man_sig_mask_at_t = bus_to_mem_man_sig_mask@t,
	bus_to_mem_man_sig_req_at_t = bus_to_mem_man_sig_req@t,
	response_loadedData_at_t = response_loadedData@t;
assume: 
	 at t: run_0;
	 at t: not((bus_to_mem_man_sig_req = ME_RD));
	 at t: bus_to_mem_man_sync;
prove:
	 at t_end: run_0;
	 at t_end: mem_man_to_ctrl_sig_addrIn = bus_to_mem_man_sig_addrIn_at_t;
	 at t_end: mem_man_to_ctrl_sig_dataIn = bus_to_mem_man_sig_dataIn_at_t;
	 at t_end: mem_man_to_ctrl_sig_mask = bus_to_mem_man_sig_mask_at_t;
	 at t_end: mem_man_to_ctrl_sig_req = bus_to_mem_man_sig_req_at_t;
	 at t_end: response_loadedData = response_loadedData_at_t;
	 during[t+1, t_end-1]: bus_to_mem_man_notify = false;
	 at t_end: bus_to_mem_man_notify = true;
	 during[t+1, t_end]: mem_man_to_bus_notify = false;
	 during[t+1, t_end-1]: mem_man_to_ctrl_notify = false;
	 at t_end: mem_man_to_ctrl_notify = true;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	bus_to_mem_man_sig_addrIn_at_t = bus_to_mem_man_sig_addrIn@t,
	bus_to_mem_man_sig_dataIn_at_t = bus_to_mem_man_sig_dataIn@t,
	bus_to_mem_man_sig_mask_at_t = bus_to_mem_man_sig_mask@t,
	bus_to_mem_man_sig_req_at_t = bus_to_mem_man_sig_req@t,
	ctrl_to_mem_man_sig_CR_reg_at_t = ctrl_to_mem_man_sig_CR_reg@t,
	ctrl_to_mem_man_sig_DR_reg_at_t = ctrl_to_mem_man_sig_DR_reg@t,
	ctrl_to_mem_man_sig_SR_reg_at_t = ctrl_to_mem_man_sig_SR_reg@t,
	ctrl_to_mem_man_sig_r_act_at_t = ctrl_to_mem_man_sig_r_act@t;
assume: 
	 at t: run_0;
	 at t: (bus_to_mem_man_sig_req = ME_RD);
	 at t: bus_to_mem_man_sync;
prove:
	 at t_end: run_3;
	 at t_end: mem_man_to_bus_sig_loadedData = response_data(ctrl_to_mem_man_sig_CR_reg_at_t,ctrl_to_mem_man_sig_DR_reg_at_t,ctrl_to_mem_man_sig_SR_reg_at_t,ctrl_to_mem_man_sig_r_act_at_t,bus_to_mem_man_sig_addrIn_at_t,bus_to_mem_man_sig_dataIn_at_t,bus_to_mem_man_sig_mask_at_t,bus_to_mem_man_sig_req_at_t);
	 at t_end: mem_man_to_ctrl_sig_addrIn = bus_to_mem_man_sig_addrIn_at_t;
	 at t_end: mem_man_to_ctrl_sig_dataIn = bus_to_mem_man_sig_dataIn_at_t;
	 at t_end: mem_man_to_ctrl_sig_mask = bus_to_mem_man_sig_mask_at_t;
	 at t_end: mem_man_to_ctrl_sig_req = bus_to_mem_man_sig_req_at_t;
	 at t_end: response_loadedData = response_data(ctrl_to_mem_man_sig_CR_reg_at_t,ctrl_to_mem_man_sig_DR_reg_at_t,ctrl_to_mem_man_sig_SR_reg_at_t,ctrl_to_mem_man_sig_r_act_at_t,bus_to_mem_man_sig_addrIn_at_t,bus_to_mem_man_sig_dataIn_at_t,bus_to_mem_man_sig_mask_at_t,bus_to_mem_man_sig_req_at_t);
	 during[t+1, t_end]: bus_to_mem_man_notify = false;
	 during[t+1, t_end-1]: mem_man_to_bus_notify = false;
	 at t_end: mem_man_to_bus_notify = true;
	 during[t+1, t_end-1]: mem_man_to_ctrl_notify = false;
	 at t_end: mem_man_to_ctrl_notify = true;
end property;

property run_3_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	response_loadedData_at_t = response_loadedData@t;
assume: 
	 at t: run_3;
	 at t: mem_man_to_bus_sync;
prove:
	 at t_end: run_0;
	 at t_end: response_loadedData = response_loadedData_at_t;
	 during[t+1, t_end-1]: bus_to_mem_man_notify = false;
	 at t_end: bus_to_mem_man_notify = true;
	 during[t+1, t_end]: mem_man_to_bus_notify = false;
	 during[t+1, t_end]: mem_man_to_ctrl_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	response_loadedData_at_t = response_loadedData@t;
assume: 
	 at t: run_0;
	 at t: not(bus_to_mem_man_sync);
prove:
	 at t+1: run_0;
	 at t+1: response_loadedData = response_loadedData_at_t;
	 at t+1: bus_to_mem_man_notify = true;
	 at t+1: mem_man_to_bus_notify = false;
	 at t+1: mem_man_to_ctrl_notify = false;
end property;

property wait_run_3 is
dependencies: no_reset;
freeze:
	response_loadedData_at_t = response_loadedData@t;
assume: 
	 at t: run_3;
	 at t: not(mem_man_to_bus_sync);
prove:
	 at t+1: run_3;
	 at t+1: mem_man_to_bus_sig_loadedData = response_loadedData_at_t;
	 at t+1: response_loadedData = response_loadedData_at_t;
	 at t+1: bus_to_mem_man_notify = false;
	 at t+1: mem_man_to_bus_notify = true;
	 at t+1: mem_man_to_ctrl_notify = false;
end property;