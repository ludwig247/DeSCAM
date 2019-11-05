-- DP SIGNALS --
macro agent_to_bus_sig_addr : int := agent_to_bus.addr end macro;
macro agent_to_bus_sig_cyc : bool := agent_to_bus.cyc end macro;
macro agent_to_bus_sig_data : int := agent_to_bus.data end macro;
macro agent_to_bus_sig_stb: bool := agent_to_bus.stb end macro;
macro agent_to_bus_sig_we: bool := agent_to_bus.we end macro;
macro agent_to_master_sig_ack: ack_t := agent_to_master.ack end macro;
macro agent_to_master_sig_data: int := agent_to_master.data end macro;
macro bus_to_agent_sig_ack: bool := bus_to_agent.ack end macro;
macro bus_to_agent_sig_data: int := bus_to_agent.data end macro;
macro bus_to_agent_sig_err: bool := bus_to_agent.err end macro;
macro master_to_agent_sig_addr: int := master_to_agent.addr end macro;
macro master_to_agent_sig_data: int := master_to_agent.data end macro;
macro master_to_agent_sig_trans_type: trans_t := master_to_agent.trans_type end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro agent_to_bus_req_trans_type : trans_t := agent_to_bus_req_signal.trans_type end macro;
macro agent_to_bus_resp_ack : ack_t := agent_to_bus_resp_signal.ack end macro;
macro agent_to_bus_resp_data : int := agent_to_bus_resp_signal.data end macro;

-- STATES --
macro DONE_0 : boolean := section = DONE and wait_signal = 1 end macro;
macro DONE_1 : boolean := section = DONE and wait_signal = 0 end macro;
macro IDLE_2 : boolean := section = IDLE end macro;
macro WAITING_3 : boolean := section = WAITING and wait_signal = 0 end macro;

--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_2;
	 at t: agent_to_bus_req_trans_type = SINGLE_READ;
	 at t: agent_to_bus_resp_ack = ERR;
	 at t: agent_to_bus_resp_data = 0;
	 at t: agent_to_bus_sig_addr = 0;
	 at t: agent_to_bus_sig_cyc = false;
	 at t: agent_to_bus_sig_data = 0;
	 at t: agent_to_bus_sig_stb = false;
	 at t: agent_to_bus_sig_we = false;
	 at t: agent_to_master_notify = false;
	 at t: master_to_agent_notify = true;
end property;


property DONE_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: DONE_0;
	 at t: bus_to_agent_sig_ack;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property DONE_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: DONE_0;
	 at t: not(bus_to_agent_sig_ack);
prove:
	 at t_end: DONE_1;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 at t_end: agent_to_master_sig_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_master_sig_data = agent_to_bus_resp_data_at_t;
	 during[t+1, t_end-1]: agent_to_master_notify = false;
	 at t_end: agent_to_master_notify = true;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property DONE_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: DONE_1;
	 at t: agent_to_master_sync;
prove:
	 at t_end: IDLE_2;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end-1]: master_to_agent_notify = false;
	 at t_end: master_to_agent_notify = true;
end property;

property IDLE_2_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	master_to_agent_sig_addr_at_t = master_to_agent_sig_addr@t,
	master_to_agent_sig_trans_type_at_t = master_to_agent_sig_trans_type@t;
assume:
	 at t: IDLE_2;
	 at t: (master_to_agent_sig_trans_type = SINGLE_READ);
	 at t: master_to_agent_sync;
prove:
	 at t_end: WAITING_3;
	 at t_end: agent_to_bus_req_trans_type = master_to_agent_sig_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = master_to_agent_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = true;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_stb = true;
	 at t_end: agent_to_bus_sig_we = false;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property IDLE_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	master_to_agent_sig_addr_at_t = master_to_agent_sig_addr@t,
	master_to_agent_sig_data_at_t = master_to_agent_sig_data@t,
	master_to_agent_sig_trans_type_at_t = master_to_agent_sig_trans_type@t;
assume:
	 at t: IDLE_2;
	 at t: not((master_to_agent_sig_trans_type = SINGLE_READ));
	 at t: master_to_agent_sync;
prove:
	 at t_end: WAITING_3;
	 at t_end: agent_to_bus_req_trans_type = master_to_agent_sig_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = master_to_agent_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = true;
	 at t_end: agent_to_bus_sig_data = master_to_agent_sig_data_at_t;
	 at t_end: agent_to_bus_sig_stb = true;
	 at t_end: agent_to_bus_sig_we = true;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property WAITING_3_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t;
assume:
	 at t: WAITING_3;
	 at t: bus_to_agent_sig_ack;
	 at t: not((agent_to_bus_req_trans_type = SINGLE_READ));
	 at t: not(bus_to_agent_sig_err);
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = OK;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = 0;
	 at t_end: agent_to_bus_sig_cyc = false;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_stb = false;
	 at t_end: agent_to_bus_sig_we = false;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property WAITING_3_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	bus_to_agent_sig_data_at_t = bus_to_agent_sig_data@t;
assume:
	 at t: WAITING_3;
	 at t: bus_to_agent_sig_ack;
	 at t: (agent_to_bus_req_trans_type = SINGLE_READ);
	 at t: not(bus_to_agent_sig_err);
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = OK;
	 at t_end: agent_to_bus_resp_data = bus_to_agent_sig_data_at_t;
	 at t_end: agent_to_bus_sig_addr = 0;
	 at t_end: agent_to_bus_sig_cyc = false;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_stb = false;
	 at t_end: agent_to_bus_sig_we = false;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property WAITING_3_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t;
assume:
	 at t: WAITING_3;
	 at t: bus_to_agent_sig_ack;
	 at t: not((agent_to_bus_req_trans_type = SINGLE_READ));
	 at t: bus_to_agent_sig_err;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = ERR;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = 0;
	 at t_end: agent_to_bus_sig_cyc = false;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_stb = false;
	 at t_end: agent_to_bus_sig_we = false;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property WAITING_3_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	bus_to_agent_sig_data_at_t = bus_to_agent_sig_data@t;
assume:
	 at t: WAITING_3;
	 at t: bus_to_agent_sig_ack;
	 at t: (agent_to_bus_req_trans_type = SINGLE_READ);
	 at t: bus_to_agent_sig_err;
prove:
	 at t_end: DONE_0;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = ERR;
	 at t_end: agent_to_bus_resp_data = bus_to_agent_sig_data_at_t;
	 at t_end: agent_to_bus_sig_addr = 0;
	 at t_end: agent_to_bus_sig_cyc = false;
	 at t_end: agent_to_bus_sig_data = 0;
	 at t_end: agent_to_bus_sig_stb = false;
	 at t_end: agent_to_bus_sig_we = false;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property WAITING_3_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: WAITING_3;
	 at t: not(bus_to_agent_sig_ack);
prove:
	 at t_end: WAITING_3;
	 at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 during[t+1, t_end]: agent_to_master_notify = false;
	 during[t+1, t_end]: master_to_agent_notify = false;
end property;

property wait_DONE_1 is
dependencies: no_reset;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: DONE_1;
	 at t: not(agent_to_master_sync);
prove:
	 at t+1: DONE_1;
	 at t+1: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t+1: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t+1: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t+1: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t+1: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t+1: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 at t+1: agent_to_master_sig_ack = agent_to_bus_resp_ack_at_t;
	 at t+1: agent_to_master_sig_data = agent_to_bus_resp_data_at_t;
	 at t+1: agent_to_master_notify = true;
	 at t+1: agent_to_master_notify = true;
	 at t+1: agent_to_master_notify = true;
	 at t+1: master_to_agent_notify = false;
end property;

property wait_IDLE_2 is
dependencies: no_reset;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t;
assume:
	 at t: IDLE_2;
	 at t: not(master_to_agent_sync);
prove:
	 at t+1: IDLE_2;
	 at t+1: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	 at t+1: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	 at t+1: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	 at t+1: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	 at t+1: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	 at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	 at t+1: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	 at t+1: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	 at t+1: master_to_agent_notify = true;
	 at t+1: agent_to_master_notify = false;
	 at t+1: master_to_agent_notify = true;
	 at t+1: master_to_agent_notify = true;
end property;

