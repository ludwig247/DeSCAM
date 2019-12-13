-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro agent_to_master_sync : boolean := end macro;
macro master_to_agent_sync : boolean := end macro;
macro agent_to_master_notify : boolean := end macro;
macro master_to_agent_notify : boolean := end macro;


-- DP SIGNALS --
macro agent_to_bus_sig : master_signals := end macro;
macro agent_to_bus_sig_addr : signed := end macro;
macro agent_to_bus_sig_cyc : boolean := end macro;
macro agent_to_bus_sig_data : signed := end macro;
macro agent_to_bus_sig_stb : boolean := end macro;
macro agent_to_bus_sig_we : boolean := end macro;
macro agent_to_master_sig : bus_resp_t := end macro;
macro agent_to_master_sig_ack : ack_t := end macro;
macro agent_to_master_sig_data : signed := end macro;
macro bus_to_agent_sig : slave_signals := end macro;
macro bus_to_agent_sig_ack : boolean := end macro;
macro bus_to_agent_sig_data : signed := end macro;
macro bus_to_agent_sig_err : boolean := end macro;
macro clk_sig : boolean := end macro;
macro master_to_agent_sig : bus_req_t := end macro;
macro master_to_agent_sig_addr : signed := end macro;
macro master_to_agent_sig_data : signed := end macro;
macro master_to_agent_sig_trans_type : trans_t := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro agent_to_bus_req_trans_type : trans_t := end macro;
macro agent_to_bus_resp_ack : ack_t := end macro;
macro agent_to_bus_resp_data : signed := end macro;
macro nextphase : Phases := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: agent_to_bus_req_trans_type = SINGLE_READ;
	 at t: agent_to_bus_resp_ack = ERR;
	 at t: agent_to_bus_resp_data = resize(0,32);
	 at t: agent_to_bus_sig_addr = resize(0,32);
	 at t: agent_to_bus_sig_cyc = false;
	 at t: agent_to_bus_sig_data = resize(0,32);
	 at t: agent_to_bus_sig_stb = false;
	 at t: agent_to_bus_sig_we = false;
	 at t: nextphase = IDLE;
	 at t: agent_to_master_notify = false;
	 at t: master_to_agent_notify = true;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	master_to_agent_sig_addr_at_t = master_to_agent_sig_addr@t,
	master_to_agent_sig_trans_type_at_t = master_to_agent_sig_trans_type@t;
assume:
	at t: state_1;
	at t: master_to_agent_sync;
	at t: (master_to_agent_sig_trans_type = SINGLE_READ);
prove:
	at t_end: state_4;
	at t_end: agent_to_bus_req_trans_type = master_to_agent_sig_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = master_to_agent_sig_addr_at_t;
	at t_end: agent_to_bus_sig_cyc = true;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_stb = true;
	at t_end: agent_to_bus_sig_we = false;
	at t_end: nextphase = WAITING;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	master_to_agent_sig_addr_at_t = master_to_agent_sig_addr@t,
	master_to_agent_sig_data_at_t = master_to_agent_sig_data@t,
	master_to_agent_sig_trans_type_at_t = master_to_agent_sig_trans_type@t;
assume:
	at t: state_1;
	at t: master_to_agent_sync;
	at t: not((master_to_agent_sig_trans_type = SINGLE_READ));
prove:
	at t_end: state_4;
	at t_end: agent_to_bus_req_trans_type = master_to_agent_sig_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = master_to_agent_sig_addr_at_t;
	at t_end: agent_to_bus_sig_cyc = true;
	at t_end: agent_to_bus_sig_data = master_to_agent_sig_data_at_t;
	at t_end: agent_to_bus_sig_stb = true;
	at t_end: agent_to_bus_sig_we = true;
	at t_end: nextphase = WAITING;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_4_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	bus_to_agent_sig_data_at_t = bus_to_agent_sig_data@t;
assume:
	at t: state_4;
	at t: bus_to_agent_sig_ack;
	at t: (agent_to_bus_req_trans_type = SINGLE_READ);
	at t: bus_to_agent_sig_err;
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = ERR;
	at t_end: agent_to_bus_resp_data = bus_to_agent_sig_data_at_t;
	at t_end: agent_to_bus_sig_addr = 0;
	at t_end: agent_to_bus_sig_cyc = false;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_stb = false;
	at t_end: agent_to_bus_sig_we = false;
	at t_end: nextphase = DONE;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_4_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	bus_to_agent_sig_data_at_t = bus_to_agent_sig_data@t;
assume:
	at t: state_4;
	at t: bus_to_agent_sig_ack;
	at t: (agent_to_bus_req_trans_type = SINGLE_READ);
	at t: not(bus_to_agent_sig_err);
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = OK;
	at t_end: agent_to_bus_resp_data = bus_to_agent_sig_data_at_t;
	at t_end: agent_to_bus_sig_addr = 0;
	at t_end: agent_to_bus_sig_cyc = false;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_stb = false;
	at t_end: agent_to_bus_sig_we = false;
	at t_end: nextphase = DONE;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_4_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t;
assume:
	at t: state_4;
	at t: bus_to_agent_sig_ack;
	at t: not((agent_to_bus_req_trans_type = SINGLE_READ));
	at t: bus_to_agent_sig_err;
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = ERR;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = 0;
	at t_end: agent_to_bus_sig_cyc = false;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_stb = false;
	at t_end: agent_to_bus_sig_we = false;
	at t_end: nextphase = DONE;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_4_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t;
assume:
	at t: state_4;
	at t: bus_to_agent_sig_ack;
	at t: not((agent_to_bus_req_trans_type = SINGLE_READ));
	at t: not(bus_to_agent_sig_err);
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = OK;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = 0;
	at t_end: agent_to_bus_sig_cyc = false;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_stb = false;
	at t_end: agent_to_bus_sig_we = false;
	at t_end: nextphase = DONE;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_4_10 is
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
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_4;
	at t: not(bus_to_agent_sig_ack);
	at t: (nextphase = WAITING);
prove:
	at t_end: state_4;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	at t_end: nextphase = nextphase_at_t;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_3_4 is
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
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_3;
	at t: not(bus_to_agent_sig_ack);
prove:
	at t_end: state_2;
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
	at t_end: nextphase = nextphase_at_t;
	during[t+1, t_end-1]: agent_to_master_notify = false;
	at t_end: agent_to_master_notify = true;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_3_5 is
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
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_3;
	at t: bus_to_agent_sig_ack;
	at t: (nextphase = DONE);
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	at t_end: nextphase = nextphase_at_t;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end]: master_to_agent_notify = false;
end property;


property state_2_3 is
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
	at t: state_2;
	at t: agent_to_master_sync;
prove:
	at t_end: state_1;
	at t_end: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t_end: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t_end: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t_end: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	at t_end: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	at t_end: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	at t_end: nextphase = IDLE;
	during[t+1, t_end]: agent_to_master_notify = false;
	during[t+1, t_end-1]: master_to_agent_notify = false;
	at t_end: master_to_agent_notify = true;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: not(master_to_agent_sync);
prove:
	at t+1: state_1;
	at t+1: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t+1: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t+1: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t+1: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	at t+1: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	at t+1: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: agent_to_master_notify = false;
	at t+1: master_to_agent_notify = true;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	agent_to_bus_req_trans_type_at_t = agent_to_bus_req_trans_type@t,
	agent_to_bus_resp_ack_at_t = agent_to_bus_resp_ack@t,
	agent_to_bus_resp_data_at_t = agent_to_bus_resp_data@t,
	agent_to_bus_sig_addr_at_t = agent_to_bus_sig_addr@t,
	agent_to_bus_sig_cyc_at_t = agent_to_bus_sig_cyc@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_stb_at_t = agent_to_bus_sig_stb@t,
	agent_to_bus_sig_we_at_t = agent_to_bus_sig_we@t,
	agent_to_master_sig_at_t = agent_to_master_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_2;
	at t: not(agent_to_master_sync);
prove:
	at t+1: state_2;
	at t+1: agent_to_bus_req_trans_type = agent_to_bus_req_trans_type_at_t;
	at t+1: agent_to_bus_resp_ack = agent_to_bus_resp_ack_at_t;
	at t+1: agent_to_bus_resp_data = agent_to_bus_resp_data_at_t;
	at t+1: agent_to_bus_sig_addr = agent_to_bus_sig_addr_at_t;
	at t+1: agent_to_bus_sig_cyc = agent_to_bus_sig_cyc_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_stb = agent_to_bus_sig_stb_at_t;
	at t+1: agent_to_bus_sig_we = agent_to_bus_sig_we_at_t;
	at t+1: agent_to_master_sig = agent_to_master_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: agent_to_master_notify = true;
	at t+1: master_to_agent_notify = false;
end property;


