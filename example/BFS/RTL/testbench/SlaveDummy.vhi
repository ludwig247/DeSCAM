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


-- VISIBLE REGISTERS --
macro cnt : int := cnt_signal end macro;
macro req_addr : int := req_signal.addr end macro;
macro req_data : int := req_signal.data end macro;
macro req_trans_type : trans_t := req_signal.trans_type end macro;
macro resp_ack : ack_t := resp_signal.ack end macro;
macro resp_data : int := resp_signal.data end macro;


-- STATES --
macro run_0 : boolean := section=run and bus_req_notify_tmp = true and bus_resp_notify_tmp = false end macro;
macro run_1 : boolean := section=run and bus_req_notify_tmp = false and bus_resp_notify_tmp = true end macro;


--Operations --


property reset is
for timepoints:
	t_end = t;
assume:
	 reset_sequence;
prove:
	 at t_end: run_0;
	 at t_end: cnt = 0;
	 at t_end: req_addr = 0;
	 at t_end: req_data = 0;
	 at t_end: req_trans_type = SINGLE_READ;
	 at t_end: resp_ack = ERR;
	 at t_end: resp_data = 0;
	 during[t+1, t_end-1]: bus_req_notify = false;
	 during[t+1, t_end]: bus_resp_notify = false;
	 at t_end: bus_req_notify = true;
end property;

property wait_run_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
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
end property;

property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	cnt_at_t = cnt@t,
	req_addr_at_t = req_addr@t,
	req_data_at_t = req_data@t,
	req_trans_type_at_t = req_trans_type@t,
	resp_ack_at_t = resp_ack@t,
	resp_data_at_t = resp_data@t,
	bus_req_sig_addr_at_t = bus_req_addr_sig@t,
	bus_req_sig_data_at_t = bus_req_data_sig@t,
	bus_req_sig_trans_type_at_t = bus_req_trans_type_sig@t;
assume:
	 at t: run_0;
	 at t: (bus_req_sync = true);
prove:
	 at t_end: run_1;
	 at t_end: cnt = cnt_at_t;
	 at t_end: req_addr = bus_req_sig_addr_at_t;
	 at t_end: req_data = bus_req_sig_data_at_t;
	 at t_end: req_trans_type = bus_req_sig_trans_type_at_t;
	 at t_end: resp_ack = OK;
	 at t_end: resp_data = bus_req_sig_data_at_t;
	 during[t+1, t_end]: bus_req_notify = false;
	 during[t+1, t_end-1]: bus_resp_notify = false;
	 at t_end: bus_resp_notify = true;
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;

property run_1_write_1 is
dependencies: no_reset;
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
	 at t: run_1;
	 at t: (bus_resp_sync = true);
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
end property;

property wait_run_1 is
dependencies: no_reset;
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
	 at t_end: bus_resp_ack_sig = resp_ack;
	 at t_end: bus_resp_data_sig = resp_data;
end property;