

-- DP SIGNALS --
macro agent_to_bus_sig_ack : bool := agent_to_bus.ack end macro;
macro agent_to_bus_sig_data : int := agent_to_bus.data end macro;
macro agent_to_bus_sig_err : bool := agent_to_bus.err end macro;
macro agent_to_slave_sig_addr : int := agent_to_slave.addr end macro;
macro agent_to_slave_sig_data : int := agent_to_slave.data end macro;
macro agent_to_slave_sig_trans_type : trans_t := agent_to_slave.trans_type  end macro;
macro bus_to_agent_sig_addr : int := bus_to_agent.addr end macro;
macro bus_to_agent_sig_cyc : bool := bus_to_agent.cyc end macro;
macro bus_to_agent_sig_data : int := bus_to_agent.data end macro;
macro bus_to_agent_sig_stb : bool := bus_to_agent.stb end macro;
macro bus_to_agent_sig_we : bool := bus_to_agent.we end macro;
macro slave_to_agent_sig_ack : ack_t := slave_to_agent.ack end macro;
macro slave_to_agent_sig_data : int := slave_to_agent.data end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro agent_to_slave_req_addr : int :=  agent_to_slave_req_signal.addr end macro;
macro agent_to_slave_req_data : int := agent_to_slave_req_signal.data end macro;
macro agent_to_slave_req_trans_type : trans_t := agent_to_slave_req_signal.trans_type end macro;
macro slave_to_agent_resp_ack : ack_t := slave_to_agent_resp_signal.ack end macro;
macro slave_to_agent_resp_data : int := slave_to_agent_resp_signal.data end macro;


-- STATES --
macro DONE_0 : boolean := 
     section = DONE and is_done = false
end macro;
macro IDLE_1 : boolean := 
    section = IDLE  end macro;
macro READ_2 : boolean :=
    section = READ and
    agent_to_slave_notify = true and
    slave_to_agent_notify = false
end macro;
macro READ_3 : boolean := 
    section = READ and
    agent_to_slave_notify = false and
    slave_to_agent_notify = true
 end macro;
macro WRITE_4 : boolean := 
    section = WRITE and
    agent_to_slave_notify = true and
    slave_to_agent_notify = false
 end macro;
macro WRITE_5 : boolean := 
    section = WRITE and
    agent_to_slave_notify = false and
    slave_to_agent_notify = true
 end macro;



--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_1;
	 at t: agent_to_bus_sig_ack = false;
	 at t: agent_to_bus_sig_data = 0;
	 at t: agent_to_bus_sig_err = false;
	 at t: agent_to_slave_req_addr = 0;
	 at t: agent_to_slave_req_data = 0;
	 at t: agent_to_slave_req_trans_type = SINGLE_READ;
	 at t: slave_to_agent_resp_ack = ERR;
	 at t: slave_to_agent_resp_data = 0;
	 at t: agent_to_slave_notify = false;
	 at t: slave_to_agent_notify = false;
end property;


property DONE_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: DONE_0;
	 at t: not((not(bus_to_agent_sig_cyc) and not(bus_to_agent_sig_stb)));
	 at t: bus_to_agent_sig_we;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_sig_ack = true;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_err = not((slave_to_agent_resp_ack_at_t = OK));
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property DONE_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: DONE_0;
	 at t: not((not(bus_to_agent_sig_cyc) and not(bus_to_agent_sig_stb)));
	 at t: not(bus_to_agent_sig_we);
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_sig_ack = true;
	 at t_end: agent_to_bus_sig_data = slave_to_agent_resp_data_at_t;
	 at t_end: agent_to_bus_sig_err = not((slave_to_agent_resp_ack_at_t = OK));
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property DONE_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: DONE_0;
	 at t: not(bus_to_agent_sig_cyc);
	 at t: not(bus_to_agent_sig_stb);
prove:
	 at t_end: IDLE_1;
	 at t_end: agent_to_bus_sig_ack = false;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_err = false;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property IDLE_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: IDLE_1;
	 at t: not((bus_to_agent_sig_cyc and bus_to_agent_sig_stb));
prove:
	 at t_end: IDLE_1;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property IDLE_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	bus_to_agent_sig_addr_at_t = bus_to_agent_sig_addr@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: IDLE_1;
	 at t: bus_to_agent_sig_cyc;
	 at t: bus_to_agent_sig_stb;
	 at t: not(bus_to_agent_sig_we);
prove:
	 at t_end: READ_2;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = bus_to_agent_sig_addr_at_t;
	 at t_end: agent_to_slave_req_data = 0;
	 at t_end: agent_to_slave_req_trans_type = SINGLE_READ;
	 at t_end: agent_to_slave_sig_addr = bus_to_agent_sig_addr_at_t;
	 at t_end: agent_to_slave_sig_data = 0;
	 at t_end: agent_to_slave_sig_trans_type = SINGLE_READ;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end-1]: agent_to_slave_notify = false;
	 at t_end: agent_to_slave_notify = true;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property IDLE_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	bus_to_agent_sig_addr_at_t = bus_to_agent_sig_addr@t,
	bus_to_agent_sig_data_at_t = bus_to_agent_sig_data@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: IDLE_1;
	 at t: bus_to_agent_sig_cyc;
	 at t: bus_to_agent_sig_stb;
	 at t: bus_to_agent_sig_we;
prove:
	 at t_end: WRITE_4;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = bus_to_agent_sig_addr_at_t;
	 at t_end: agent_to_slave_req_data = bus_to_agent_sig_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = SINGLE_WRITE;
	 at t_end: agent_to_slave_sig_addr = bus_to_agent_sig_addr_at_t;
	 at t_end: agent_to_slave_sig_data = bus_to_agent_sig_data_at_t;
	 at t_end: agent_to_slave_sig_trans_type = SINGLE_WRITE;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end-1]: agent_to_slave_notify = false;
	 at t_end: agent_to_slave_notify = true;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property READ_2_write_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: READ_2;
	 at t: agent_to_slave_sync;
prove:
	 at t_end: READ_3;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end-1]: slave_to_agent_notify = false;
	 at t_end: slave_to_agent_notify = true;
end property;

property READ_3_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_sig_ack_at_t = slave_to_agent_sig_ack@t,
	slave_to_agent_sig_data_at_t = slave_to_agent_sig_data@t;
assume: 
	 at t: READ_3;
	 at t: slave_to_agent_sync;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_sig_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_sig_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property WRITE_4_write_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: WRITE_4;
	 at t: agent_to_slave_sync;
prove:
	 at t_end: WRITE_5;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end-1]: slave_to_agent_notify = false;
	 at t_end: slave_to_agent_notify = true;
end property;

property WRITE_5_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_sig_ack_at_t = slave_to_agent_sig_ack@t;
assume: 
	 at t: WRITE_5;
	 at t: slave_to_agent_sync;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t_end: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t_end: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t_end: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t_end: slave_to_agent_resp_ack = slave_to_agent_sig_ack_at_t;
	 at t_end: slave_to_agent_resp_data = 0;
	 during[t+1, t_end]: agent_to_slave_notify = false;
	 during[t+1, t_end]: slave_to_agent_notify = false;
end property;

property wait_READ_2 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: READ_2;
	 at t: not(agent_to_slave_sync);
prove:
	 at t+1: READ_2;
	 at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t+1: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: agent_to_slave_sig_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_sig_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_sig_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: slave_to_agent_notify = false;
end property;

property wait_READ_3 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: READ_3;
	 at t: not(slave_to_agent_sync);
prove:
	 at t+1: READ_3;
	 at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t+1: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 at t+1: slave_to_agent_notify = true;
	 at t+1: agent_to_slave_notify = false;
	 at t+1: slave_to_agent_notify = true;
	 at t+1: slave_to_agent_notify = true;
end property;

property wait_WRITE_4 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: WRITE_4;
	 at t: not(agent_to_slave_sync);
prove:
	 at t+1: WRITE_4;
	 at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t+1: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: agent_to_slave_sig_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_sig_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_sig_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: agent_to_slave_notify = true;
	 at t+1: slave_to_agent_notify = false;
end property;

property wait_WRITE_5 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_req_addr_at_t = agent_to_slave_req_addr@t,
	agent_to_slave_req_data_at_t = agent_to_slave_req_data@t,
	agent_to_slave_req_trans_type_at_t = agent_to_slave_req_trans_type@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume: 
	 at t: WRITE_5;
	 at t: not(slave_to_agent_sync);
prove:
	 at t+1: WRITE_5;
	 at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	 at t+1: agent_to_slave_req_addr = agent_to_slave_req_addr_at_t;
	 at t+1: agent_to_slave_req_data = agent_to_slave_req_data_at_t;
	 at t+1: agent_to_slave_req_trans_type = agent_to_slave_req_trans_type_at_t;
	 at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	 at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	 at t+1: slave_to_agent_notify = true;
	 at t+1: agent_to_slave_notify = false;
	 at t+1: slave_to_agent_notify = true;
	 at t+1: slave_to_agent_notify = true;
end property;