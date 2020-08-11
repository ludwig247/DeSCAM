-- @lang=vhi @ts=8
macro getSlaveIn(slave: unsigned): AHBtoCU_IF :=
if(slave = 2) then signal(slave_in2)
elsif(slave = 1) then signal(slave_in1)
else signal(slave_in0)
end if;
end macro;

macro getSlaveInSync(slave: unsigned): boolean :=
if(slave = 2) then signal(slave_in2_sync)
elsif(slave = 1) then signal(slave_in1_sync)
else signal(slave_in0_sync)
end if;
end macro;

macro getSlaveOutSync(slave: unsigned): boolean :=
if(slave = 2) then signal(slave_out2_sync)
elsif(slave = 1) then signal(slave_out1_sync)
else signal(slave_out0_sync)
end if;
end macro;


macro getMasterOut(master: unsigned): AHBtoCU_IF :=
if(master = 2) then signal(master_out2)
elsif(master = 1) then signal(master_out1)
elsif(master = 3) then signal(master_out3)
else signal(master_out0)
end if;
end macro;


macro getMasterOutSync(master: unsigned): boolean :=
if(master = 2) then signal(master_out2_sync)
elsif(master = 1) then signal(master_out1_sync)
elsif(master = 3) then signal(master_out3_sync)
else signal(master_out0_sync)
end if;
end macro;

macro getMasterOutNotify(master: unsigned): boolean :=
if(master = 2) then signal(master_out2_notify)
elsif(master = 1) then signal(master_out1_notify)
elsif(master = 3) then signal(master_out3_notify)
else signal(master_out0_notify)
end if;
end macro;


macro getMasterInSync(master: unsigned): boolean :=
if(master = 2) then signal(master_in2_sync)
elsif(master = 1) then signal(master_in1_sync)
elsif(master = 3) then signal(master_in3_sync)
else signal(master_in0_sync)
end if;
end macro;

macro getMasterInNotify(master: unsigned): boolean :=
if(master = 2) then signal(master_in2_notify)
elsif(master = 1) then signal(master_in1_notify)
elsif(master = 3) then signal(master_in3_notify)
else signal(master_in0_notify)
end if;
end macro;

macro getMasterIn(master: unsigned): CUtoAHB_IF :=
if(master = 2) then signal(master_in2)  
elsif(master = 1) then signal(master_in1)
elsif(master = 3) then signal(master_in3)
else signal(master_in0)
end if;
end macro;


macro correctSlaveAddr(master,slave: unsigned): boolean :=
if(slave = 0) then 
	getMasterIn(master).haddr > 0 and getMasterIn(master).haddr <= 65535;
elsif(slave = 1) then 
	getMasterIn(master).haddr > 65535 and getMasterIn(master).haddr <= 131071;
else 
	getMasterIn(master).haddr > 131071 and getMasterIn(master).haddr <= 197631;
end if;
end macro;


macro single_req(fromMaster, toSlave: unsigned): property :=
dependencies: no_reset, no_split_retry, bounded_wait;
for timepoints:
	t_start  = t,
	t_slave_out  = t_start+ 4, -- no wait for the sync signal to come 
	t_slave_out_wait = t_slave_out+ 0 .. max_wait waits_for complete ( getSlaveOutSync(toSlave)), 
	t_slave_in = t_slave_out_wait+ 1, 
	t_slave_in_wait = t_slave_in+ 0 .. max_wait waits_for complete ( getSlaveInSync(toSlave)),
	t_master_out = t_slave_in_wait + 3,
	t_master_out_wait = t_master_out + 0 .. max_wait waits_for complete getMasterOutSync(fromMaster);
freeze:
	master_to_agent_sig_haddr_at_t = getMasterIn(fromMaster).haddr@t_start,
	slave_to_master_data_at_t_slave_in = getSlaveIn(toSlave).hrdata@t_slave_in_wait,
	slave_to_master_resp_at_t_slave_in = getSlaveIn(toSlave).hresp@t_slave_in_wait;
assume:
	at t_start: bus_idle;
	at t_start: (master_in0_sync = (if(fromMaster = 0) then 1 else 0 end if));
	at t_start: (master_in1_sync = (if(fromMaster = 1) then 1 else 0 end if));
	at t_start: (master_in2_sync = (if(fromMaster = 2) then 1 else 0 end if));
	at t_start: (master_in3_sync = (if(fromMaster = 3) then 1 else 0 end if));
	at t_start: correctSlaveAddr(fromMaster,toSlave); 
	--during[t_start+1,t_master_out_wait]: request(false,false,false,false);
prove:	
	at t_slave_out: select_slave_out(master_to_agent_sig_haddr_at_t);
	--during[t_slave_out,t_slave_in-1]: slave_out0_notify;
	--during[t_start,t_slave_out-1]: not(slave_out0_notify);
	at t_slave_in: select_slave_in(master_to_agent_sig_haddr_at_t); 
	at t_master_out: getMasterOutNotify(fromMaster);
	at t_master_out: getMasterOut(fromMaster).hrdata = slave_to_master_data_at_t_slave_in;
	at t_master_out: getMasterOut(fromMaster).hresp= slave_to_master_resp_at_t_slave_in;
	at t_master_out_wait+1: getMasterOutNotify(fromMaster) = false;
	at t_master_out_wait+1: getMasterInNotify(fromMaster) = true;
	--at t_master_out_wait+1: bus_idle;
right_hook: t_master_out_wait+1;
--local_determination_requirements:
--	at t_slave_in:  determined(slave_in1_notify);
end macro;




property single_req10 is
single_req(1,0); 
end property;

property single_req11 is
single_req(1,1); 
end property;

property single_req12 is
single_req(1,2); 
end property;


property single_req20 is
single_req(2,0); 
end property;
property single_req21 is
single_req(2,1); 
end property;
property single_req22 is
single_req(2,2); 
end property;

property single_req30 is
single_req(3,0); 
end property;

property single_req31 is
single_req(3,0); 
end property;

property single_req32 is
single_req(3,0); 
end property;


property single_req00 is
single_req(0,0); 
end property;

property single_req01 is
single_req(0,1); 
end property;

property single_req02 is
single_req(0,2); 
end property;






