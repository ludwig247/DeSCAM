-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro agent_to_slave_sync : boolean := true end macro;
macro slave_to_agent_sync : boolean := true end macro;
macro agent_to_slave_notify : boolean := true end  macro;
macro slave_to_agent_notify : boolean := true end  macro;


-- DP SIGNALS --
--macro agent_to_bus_sig : slave_signals :={false, resize(0,32), false} end macro;
macro agent_to_bus_sig_ack : boolean :=false end macro;
macro agent_to_bus_sig_data : signed :=resize(0,32) end macro;
macro agent_to_bus_sig_err : boolean :=false end macro;
--macro agent_to_slave_sig : bus_req_t :={resize(0,32), resize(0,32), SINGLE_READ} end macro;
macro agent_to_slave_sig_addr : signed :=resize(0,32) end macro;
macro agent_to_slave_sig_data : signed :=resize(0,32) end macro;
macro agent_to_slave_sig_trans_type : trans_t :=SINGLE_READ end macro;
--macro bus_to_agent_sig : master_signals :={resize(0,32), false, resize(0,32), false, false} end macro;
macro bus_to_agent_sig_addr : signed :=resize(0,32) end macro;
macro bus_to_agent_sig_cyc : boolean :=false end macro;
macro bus_to_agent_sig_data : signed :=resize(0,32) end macro;
macro bus_to_agent_sig_stb : boolean :=false end macro;
macro bus_to_agent_sig_we : boolean :=false end macro;
macro clk_sig : boolean :=false end macro;
--macro slave_to_agent_sig : bus_resp_t :={ERR, resize(0,32)} end macro;
macro slave_to_agent_sig_ack : ack_t :=OK end macro;
macro slave_to_agent_sig_data : signed :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro nextphase : Phases :=IDLE end macro;
macro slave_to_agent_resp_ack : ack_t :=OK end macro;
macro slave_to_agent_resp_data : signed :=resize(0,32) end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;
macro state_6 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_5;
	 at t: agent_to_bus_sig_ack = false;
	 at t: agent_to_bus_sig_data = resize(0,32);
	 at t: agent_to_bus_sig_err = false;
	 at t: nextphase = IDLE;
	 at t: slave_to_agent_resp_ack = OK;
	 at t: slave_to_agent_resp_data = resize(0,32);
	 at t: agent_to_slave_notify = false;
	 at t: slave_to_agent_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_1;
	at t: agent_to_slave_sync;
prove:
	at t_end: state_2;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end-1]: slave_to_agent_notify = false;
	at t_end: slave_to_agent_notify = true;
end property;


property state_2_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	slave_to_agent_sig_ack_at_t = slave_to_agent_sig_ack@t,
	slave_to_agent_sig_data_at_t = slave_to_agent_sig_data@t;
assume:
	at t: state_2;
	at t: slave_to_agent_sync;
prove:
	at t_end: state_6;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: nextphase = DONE;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_sig_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_sig_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_3_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_3;
	at t: agent_to_slave_sync;
prove:
	at t_end: state_4;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end-1]: slave_to_agent_notify = false;
	at t_end: slave_to_agent_notify = true;
end property;


property state_4_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	slave_to_agent_sig_ack_at_t = slave_to_agent_sig_ack@t;
assume:
	at t: state_4;
	at t: slave_to_agent_sync;
prove:
	at t_end: state_6;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: nextphase = DONE;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_sig_ack_at_t;
	at t_end: slave_to_agent_resp_data = 0;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_5_5 is
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
	at t: state_5;
	at t: bus_to_agent_sig_cyc;
	at t: bus_to_agent_sig_stb;
	at t: not(bus_to_agent_sig_we);
prove:
	at t_end: state_1;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: agent_to_slave_sig_addr = bus_to_agent_sig_addr_at_t;
	at t_end: agent_to_slave_sig_data = 0;
	at t_end: agent_to_slave_sig_trans_type = SINGLE_READ;
	at t_end: nextphase = READ;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end-1]: agent_to_slave_notify = false;
	at t_end: agent_to_slave_notify = true;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_5_6 is
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
	at t: state_5;
	at t: bus_to_agent_sig_cyc;
	at t: bus_to_agent_sig_stb;
	at t: bus_to_agent_sig_we;
prove:
	at t_end: state_3;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: agent_to_slave_sig_addr = bus_to_agent_sig_addr_at_t;
	at t_end: agent_to_slave_sig_data = bus_to_agent_sig_data_at_t;
	at t_end: agent_to_slave_sig_trans_type = SINGLE_WRITE;
	at t_end: nextphase = WRITE;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end-1]: agent_to_slave_notify = false;
	at t_end: agent_to_slave_notify = true;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_5_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_5;
	at t: not((bus_to_agent_sig_cyc and bus_to_agent_sig_stb));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_5;
	at t_end: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t_end: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t_end: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_6_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_6;
	at t: not((not(bus_to_agent_sig_cyc) and not(bus_to_agent_sig_stb)));
	at t: bus_to_agent_sig_we;
	at t: (nextphase = DONE);
prove:
	at t_end: state_6;
	at t_end: agent_to_bus_sig_ack = true;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_err = not((slave_to_agent_resp_ack_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_6_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_6;
	at t: not(bus_to_agent_sig_cyc);
	at t: not(bus_to_agent_sig_stb);
prove:
	at t_end: state_5;
	at t_end: agent_to_bus_sig_ack = false;
	at t_end: agent_to_bus_sig_data = 0;
	at t_end: agent_to_bus_sig_err = false;
	at t_end: nextphase = IDLE;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property state_6_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_6;
	at t: not((not(bus_to_agent_sig_cyc) and not(bus_to_agent_sig_stb)));
	at t: not(bus_to_agent_sig_we);
	at t: (nextphase = DONE);
prove:
	at t_end: state_6;
	at t_end: agent_to_bus_sig_ack = true;
	at t_end: agent_to_bus_sig_data = slave_to_agent_resp_data_at_t;
	at t_end: agent_to_bus_sig_err = not((slave_to_agent_resp_ack_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t_end: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	during[t+1, t_end]: agent_to_slave_notify = false;
	during[t+1, t_end]: slave_to_agent_notify = false;
end property;


property wait_state_1 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_sig_at_t = agent_to_slave_sig@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_1;
	at t: not(agent_to_slave_sync);
prove:
	at t+1: state_1;
	at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t+1: agent_to_slave_sig = agent_to_slave_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	at t+1: agent_to_slave_notify = true;
	at t+1: slave_to_agent_notify = false;
end property;


property wait_state_2 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_2;
	at t: not(slave_to_agent_sync);
prove:
	at t+1: state_2;
	at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	at t+1: agent_to_slave_notify = false;
	at t+1: slave_to_agent_notify = true;
end property;


property wait_state_3 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	agent_to_slave_sig_at_t = agent_to_slave_sig@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_3;
	at t: not(agent_to_slave_sync);
prove:
	at t+1: state_3;
	at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t+1: agent_to_slave_sig = agent_to_slave_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	at t+1: agent_to_slave_notify = true;
	at t+1: slave_to_agent_notify = false;
end property;


property wait_state_4 is
dependencies: no_reset;
freeze:
	agent_to_bus_sig_ack_at_t = agent_to_bus_sig_ack@t,
	agent_to_bus_sig_data_at_t = agent_to_bus_sig_data@t,
	agent_to_bus_sig_err_at_t = agent_to_bus_sig_err@t,
	nextphase_at_t = nextphase@t,
	slave_to_agent_resp_ack_at_t = slave_to_agent_resp_ack@t,
	slave_to_agent_resp_data_at_t = slave_to_agent_resp_data@t;
assume:
	at t: state_4;
	at t: not(slave_to_agent_sync);
prove:
	at t+1: state_4;
	at t+1: agent_to_bus_sig_ack = agent_to_bus_sig_ack_at_t;
	at t+1: agent_to_bus_sig_data = agent_to_bus_sig_data_at_t;
	at t+1: agent_to_bus_sig_err = agent_to_bus_sig_err_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: slave_to_agent_resp_ack = slave_to_agent_resp_ack_at_t;
	at t+1: slave_to_agent_resp_data = slave_to_agent_resp_data_at_t;
	at t+1: agent_to_slave_notify = false;
	at t+1: slave_to_agent_notify = true;
end property;


