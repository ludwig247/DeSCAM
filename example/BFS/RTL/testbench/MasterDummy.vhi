-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro bus_req_notify :  boolean  := end macro;
--macro bus_req_sync   :  boolean  := end macro;
--macro bus_resp_notify :  boolean  := end macro;
--macro bus_resp_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro bus_req_addr_sig : int := bus_req.addr end macro;
macro bus_req_data_sig : int := bus_req.data end macro;
macro bus_req_trans_type_sig : trans_t := bus_req.trans_type end macro;
macro bus_resp_ack_sig : ack_t := bus_resp.ack end macro;
macro bus_resp_data_sig : int := bus_resp.data end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;

assertion cnt_value :=  (rst) or  cnt >= 0 and cnt <= 100; end assertion;


-- VISIBLE REGISTERS --
macro cnt : int := cnt_signal end macro;
macro req_addr : int := req_signal.addr end macro;
macro req_data : int := req_signal.data end macro;
macro req_trans_type : trans_t :=  req_signal.trans_type end macro;
macro resp_ack : ack_t := resp_signal.ack end macro;
macro resp_data : int := resp_signal.data end macro;


-- STATES --
macro run_0 : boolean := section=run and bus_req_notify=true and bus_resp_notify = false end macro;
macro run_1 : boolean := section=run and bus_req_notify=false and bus_resp_notify = true end macro;


--Operations --

property reset is
for timepoints:
	t_end = t;
assume:
	 reset_sequence;
prove:
	 at t_end: run_0;
	 at t_end: cnt = 1;
	 at t_end: req_addr = 8;
	 at t_end: req_data = 1;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = ERR;
	 at t_end: resp_data = 0;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property wait_run_0 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (bus_req_sync = false);
prove:
	 at t_end: run_0;
	 at t_end: cnt = cnt_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_0_write_0 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t;
assume:
	 at t: run_0;
	 at t: (bus_req_sync = true);
prove:
	 at t_end: run_1;
	 at t_end: cnt = cnt_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
end property;

property run_1_read_1 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (cnt = 100);
	 at t: (req_addr = 0);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 8;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_2 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (cnt = 100);
	 at t: (req_addr = 0);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 8;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_3 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (req_addr = 0);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 8;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_4 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (req_addr = 0);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 8;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_5 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (cnt = 100);
	 at t: (req_addr = 8);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 16;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_6 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (cnt = 100);
	 at t: (req_addr = 8);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 16;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_7 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (req_addr = 8);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 16;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_8 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (req_addr = 8);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 16;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_9 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (cnt = 100);
	 at t: (req_addr = 16);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 25;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_10 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (cnt = 100);
	 at t: (req_addr = 16);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 25;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_11 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (req_addr = 16);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 25;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_12 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (req_addr = 16);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 25;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_13 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (cnt = 100);
	 at t: (req_addr = 25);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_14 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (cnt = 100);
	 at t: (req_addr = 25);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_15 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_addr = 0));
	 at t: not((req_addr = 8));
	 at t: not((req_addr = 16));
	 at t: not((req_addr = 25));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (cnt = 100);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_16 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((req_addr = 0));
	 at t: not((req_addr = 8));
	 at t: not((req_addr = 16));
	 at t: not((req_addr = 25));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (cnt = 100);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = 100;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 100;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_17 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (req_addr = 25);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 0;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_18 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (req_addr = 25);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 0;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_19 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_addr = 0));
	 at t: not((req_addr = 8));
	 at t: not((req_addr = 16));
	 at t: not((req_addr = 25));
	 at t: (req_trans_type = SINGLE_READ);
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 0;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_WRITE;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property run_1_read_20 is
dependencies: no_reset, cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: not((cnt = 100));
	 at t: not((req_addr = 0));
	 at t: not((req_addr = 8));
	 at t: not((req_addr = 16));
	 at t: not((req_addr = 25));
	 at t: not((req_trans_type = SINGLE_READ));
	 at t: (bus_resp_sync = true);
prove:
	 at t_end: run_0;
	 at t_end: cnt = (1 + cnt_at_t);
	 at t_end: req_addr = 0;
	 at t_end: req_data = (1 + cnt_at_t);
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = bus_resp_sig_ack_at_t;
	 at t_end: resp_data = bus_resp_sig_data_at_t;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
	 at t_end: bus_req_addr_sig = req_addr;
	 at t_end: bus_req_data_sig = req_data;
	 at t_end: bus_req_trans_type_sig = req_trans_type;
end property;

property wait_run_1 is
dependencies: no_reset,cnt_value;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_resp_sig_ack_at_t = bus_resp_ack_sig@t,
	bus_resp_sig_data_at_t = bus_resp_data_sig@t;
assume:
	 at t: run_1;
	 at t: (bus_resp_sync = false);
prove:
	 at t_end: run_1;
	 at t_end: cnt = cnt_at_t;
	 at t_end: req_addr = req_addr_at_t;
	 at t_end: req_data = req_data_at_t;
	 at t_end: req_trans_type = req_trans_type_at_t;
	 at t_end: resp_ack = resp_ack_at_t;
	 at t_end: resp_data = resp_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
end property;
