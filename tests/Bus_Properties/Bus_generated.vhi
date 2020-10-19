-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro out_master_0_sync : boolean := true end macro;
macro out_master_1_sync : boolean := true end macro;
macro out_slave_0_sync : boolean := true end macro;
macro out_slave_1_sync : boolean := true end macro;
macro val_master_0_sync : boolean := true end macro;
macro val_master_1_sync : boolean := true end macro;
macro val_slave_0_sync : boolean := true end macro;
macro val_slave_1_sync : boolean := true end macro;
macro out_master_0_notify : boolean := true end  macro;
macro out_master_1_notify : boolean := true end  macro;
macro out_slave_0_notify : boolean := true end  macro;
macro out_slave_1_notify : boolean := true end  macro;
macro val_master_0_notify : boolean := true end  macro;
macro val_master_1_notify : boolean := true end  macro;
macro val_slave_0_notify : boolean := true end  macro;
macro val_slave_1_notify : boolean := true end  macro;


-- DP SIGNALS --
--macro out_master_0_sig : bus_resp_t :={resize(0,32), resize(0,32)} end macro;
macro out_master_0_sig_hrdata : unsigned :=resize(0,32) end macro;
macro out_master_0_sig_hresp : unsigned :=resize(0,32) end macro;
--macro out_master_1_sig : bus_resp_t :={resize(0,32), resize(0,32)} end macro;
macro out_master_1_sig_hrdata : unsigned :=resize(0,32) end macro;
macro out_master_1_sig_hresp : unsigned :=resize(0,32) end macro;
--macro out_slave_0_sig : bus_req_t :={resize(0,32), resize(0,32)} end macro;
macro out_slave_0_sig_haddr : unsigned :=resize(0,32) end macro;
macro out_slave_0_sig_hwdata : unsigned :=resize(0,32) end macro;
--macro out_slave_1_sig : bus_req_t :={resize(0,32), resize(0,32)} end macro;
macro out_slave_1_sig_haddr : unsigned :=resize(0,32) end macro;
macro out_slave_1_sig_hwdata : unsigned :=resize(0,32) end macro;
--macro val_master_0_sig : bus_req_t :={resize(0,32), resize(0,32)} end macro;
macro val_master_0_sig_haddr : unsigned :=resize(0,32) end macro;
macro val_master_0_sig_hwdata : unsigned :=resize(0,32) end macro;
--macro val_master_1_sig : bus_req_t :={resize(0,32), resize(0,32)} end macro;
macro val_master_1_sig_haddr : unsigned :=resize(0,32) end macro;
macro val_master_1_sig_hwdata : unsigned :=resize(0,32) end macro;
--macro val_slave_0_sig : bus_resp_t :={resize(0,32), resize(0,32)} end macro;
macro val_slave_0_sig_hrdata : unsigned :=resize(0,32) end macro;
macro val_slave_0_sig_hresp : unsigned :=resize(0,32) end macro;
--macro val_slave_1_sig : bus_resp_t :={resize(0,32), resize(0,32)} end macro;
macro val_slave_1_sig_hrdata : unsigned :=resize(0,32) end macro;
macro val_slave_1_sig_hresp : unsigned :=resize(0,32) end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro fromReset : boolean :=false end macro;
macro master_id : unsigned :=resize(0,32) end macro;
--macro req : bus_req_t :={resize(0,32), resize(0,32)} end macro;
macro req_haddr : unsigned :=resize(0,32) end macro;
macro req_hwdata : unsigned :=resize(0,32) end macro;
--macro resp : bus_resp_t :={resize(0,32), resize(0,32)} end macro;
macro resp_hrdata : unsigned :=resize(0,32) end macro;
macro resp_hresp : unsigned :=resize(0,32) end macro;
macro slave_id : unsigned :=resize(0,32) end macro;
macro state : states :=MASTER_REQ end macro;


-- STATES --
macro start_state : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: start_state;
	 at t: fromReset = true;
	 at t: master_id = resize(10,32);
	 at t: slave_id = resize(10,32);
	 at t: state = MASTER_REQ;
	 at t: val_master_0_notify = false;
	 at t: val_master_1_notify = false;
	 at t: out_slave_0_notify = false;
	 at t: out_slave_1_notify = false;
	 at t: val_slave_0_notify = false;
	 at t: val_slave_1_notify = false;
end property;


property start_state_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: not((resize(65536,32) <= val_master_0_sig_haddr));
	at t: val_master_0_sync;
	at t: not(out_slave_0_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 0;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: slave_id = 0;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_143 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: not((resize(65536,32) <= val_master_0_sig_haddr));
	at t: val_master_0_sync;
	at t: out_slave_0_sync;
	at t: not(val_slave_0_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 0;
	at t_end: out_slave_0_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: slave_id = 0;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_168 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_slave_0_sig_haddr_at_t = out_slave_0_sig_haddr@t,
	out_slave_0_sig_hwdata_at_t = out_slave_0_sig_hwdata@t,
	req_haddr_at_t = req_haddr@t,
	req_hwdata_at_t = req_hwdata@t,
	slave_id_at_t = slave_id@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_REQ);
	at t: (slave_id = resize(0,32));
	at t: out_slave_0_sync;
	at t: not(val_slave_0_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: out_slave_0_sig_haddr = out_slave_0_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = out_slave_0_sig_hwdata_at_t;
	at t_end: out_slave_0_sig_haddr = req_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = req_hwdata_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_179 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	slave_id_at_t = slave_id@t,
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: (((((((((state = SLAVE_RESP) 
and not((slave_id = resize(1,32)))) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
((((state = SLAVE_RESP) 
and not((slave_id = resize(0,32)))) 
and not((slave_id = resize(1,32)))) 
and val_slave_0_sync))
or
((((state = SLAVE_RESP) 
and not((slave_id = resize(0,32)))) 
and val_slave_0_sync) 
and not(val_slave_1_sync)))
or
((((state = SLAVE_REQ) 
and not((slave_id = resize(1,32)))) 
and not(out_slave_0_sync)) 
and out_slave_1_sync))
or
((((state = SLAVE_REQ) 
and not((slave_id = resize(0,32)))) 
and out_slave_0_sync) 
and not(out_slave_1_sync)))
or
(((((state = SLAVE_REQ) 
and not((slave_id = resize(0,32)))) 
and not((slave_id = resize(1,32)))) 
and out_slave_0_sync) 
and out_slave_1_sync));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = state_at_t;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: (resize(65536,32) <= val_master_0_sig_haddr);
	at t: val_master_0_sync;
	at t: not(out_slave_1_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 0;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: slave_id = 1;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	master_id_at_t = master_id@t,
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: (((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and (state /= SLAVE_REQ)) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((true 
and fromReset) 
and not((state /= MASTER_REQ))) 
and not((master_id > resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(((true 
and (state = MASTER_REQ)) 
and (master_id = resize(0,32))) 
and val_master_0_sync))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = master_id_at_t;
	at t_end: state = state_at_t;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_289 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: (resize(65536,32) <= val_master_0_sig_haddr);
	at t: val_master_0_sync;
	at t: out_slave_1_sync;
	at t: not(val_slave_1_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 0;
	at t_end: out_slave_1_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: slave_id = 1;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_319 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_slave_1_sig_haddr_at_t = out_slave_1_sig_haddr@t,
	out_slave_1_sig_hwdata_at_t = out_slave_1_sig_hwdata@t,
	req_haddr_at_t = req_haddr@t,
	req_hwdata_at_t = req_hwdata@t,
	slave_id_at_t = slave_id@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_REQ);
	at t: (slave_id = resize(1,32));
	at t: out_slave_1_sync;
	at t: not(val_slave_1_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: out_slave_1_sig_haddr = out_slave_1_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = out_slave_1_sig_hwdata_at_t;
	at t_end: out_slave_1_sig_haddr = req_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = req_hwdata_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_3324 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t,
	val_slave_0_sig_hrdata_at_t = val_slave_0_sig_hrdata@t,
	val_slave_0_sig_hresp_at_t = val_slave_0_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: not((resize(65536,32) <= val_master_0_sig_haddr));
	at t: val_master_0_sync;
	at t: not(val_master_1_sync);
	at t: out_slave_0_sync;
	at t: val_slave_0_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 10;
	at t_end: out_master_0_sig_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: out_master_0_sig_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: out_slave_0_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: slave_id = 10;
	at t_end: state = MASTER_REQ;
	at t_end: val_master_0_notify = true;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = true;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_3524 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t,
	val_slave_1_sig_hrdata_at_t = val_slave_1_sig_hrdata@t,
	val_slave_1_sig_hresp_at_t = val_slave_1_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: (resize(65536,32) <= val_master_0_sig_haddr);
	at t: val_master_0_sync;
	at t: not(val_master_1_sync);
	at t: out_slave_1_sync;
	at t: val_slave_1_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 10;
	at t_end: out_master_0_sig_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: out_master_0_sig_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: out_slave_1_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: slave_id = 10;
	at t_end: state = MASTER_REQ;
	at t_end: val_master_0_notify = true;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = true;
end property;


property start_state_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: ((((((((((((((((not((state = SLAVE_RESP)) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_1_sync)
or
(((((not((state = SLAVE_RESP)) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync))
or
((((not((state = SLAVE_REQ)) 
and not((state = SLAVE_RESP))) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and out_slave_1_sync))
or
(((((not((state = SLAVE_REQ)) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))
or
((((not((state = SLAVE_REQ)) 
and not((state = SLAVE_RESP))) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and out_slave_0_sync))
or
(((((not((state = SLAVE_REQ)) 
and not(val_master_0_sync)) 
and not(val_master_1_sync)) 
and out_slave_0_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))
or
((((not((state = MASTER_REQ)) 
and not((state = SLAVE_RESP))) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)))
or
(((not((state = MASTER_REQ)) 
and not((state = SLAVE_REQ))) 
and not((state = SLAVE_RESP))) 
and val_master_1_sync))
or
((((not((state = MASTER_REQ)) 
and not((state = SLAVE_REQ))) 
and val_master_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))
or
((((not((state = MASTER_REQ)) 
and not((state = SLAVE_RESP))) 
and val_master_0_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)))
or
(((not((state = MASTER_REQ)) 
and not((state = SLAVE_REQ))) 
and not((state = SLAVE_RESP))) 
and val_master_0_sync))
or
((((not((state = MASTER_REQ)) 
and not((state = SLAVE_REQ))) 
and val_master_0_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: state = state_at_t;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_460 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t,
	val_slave_0_sig_hrdata_at_t = val_slave_0_sig_hrdata@t,
	val_slave_0_sig_hresp_at_t = val_slave_0_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: not((resize(65536,32) <= val_master_0_sig_haddr));
	at t: val_master_0_sync;
	at t: val_master_1_sync;
	at t: out_slave_0_sync;
	at t: val_slave_0_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: out_master_0_sig_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: out_master_0_sig_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: out_slave_0_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: slave_id = 0;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = true;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = true;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_492 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	slave_id_at_t = slave_id@t,
	val_slave_0_sig_hrdata_at_t = val_slave_0_sig_hrdata@t,
	val_slave_0_sig_hresp_at_t = val_slave_0_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_RESP);
	at t: (slave_id = resize(0,32));
	at t: val_slave_0_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: resp_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = MASTER_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = true;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5115 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(((((((((((true 
and fromReset) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))))))))))))))))))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: slave_id = 0;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5122 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t;
assume:
	at t: start_state;
	at t: (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((true 
and fromReset) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and (((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and (((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and (((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(((((((((((true 
and fromReset) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))))))))))))))))))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: slave_id = 1;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5157 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t;
assume:
	at t: start_state;
	at t: ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: out_slave_0_sig_haddr = val_master_1_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: slave_id = 0;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_519 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_slave_0_sig_haddr_at_t = out_slave_0_sig_haddr@t,
	out_slave_0_sig_hwdata_at_t = out_slave_0_sig_hwdata@t,
	req_haddr_at_t = req_haddr@t,
	req_hwdata_at_t = req_hwdata@t,
	slave_id_at_t = slave_id@t,
	val_slave_0_sig_hrdata_at_t = val_slave_0_sig_hrdata@t,
	val_slave_0_sig_hresp_at_t = val_slave_0_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_REQ);
	at t: (slave_id = resize(0,32));
	at t: out_slave_0_sync;
	at t: val_slave_0_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: out_slave_0_sig_haddr = out_slave_0_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = out_slave_0_sig_hwdata_at_t;
	at t_end: out_slave_0_sig_haddr = req_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = req_hwdata_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = MASTER_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = true;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5250 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t;
assume:
	at t: start_state;
	at t: ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync))
or
(((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and not(val_slave_1_sync)))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: out_slave_1_sig_haddr = val_master_1_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: slave_id = 1;
	at t_end: state = SLAVE_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5364 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t,
	val_slave_0_sig_hrdata_at_t = val_slave_0_sig_hrdata@t,
	val_slave_0_sig_hresp_at_t = val_slave_0_sig_hresp@t;
assume:
	at t: start_state;
	at t: ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and not(out_slave_1_sync)) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(true 
and ((((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync))
or
(((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and ((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32)))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not((resize(0,32) = resize(1,32)))) 
and (resize(0,32) = resize(0,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and not(val_slave_1_sync)))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 10;
	at t_end: out_master_1_sig_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: out_master_1_sig_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: out_slave_0_sig_haddr = val_master_1_sig_haddr_at_t;
	at t_end: out_slave_0_sig_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_0_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_0_sig_hresp_at_t;
	at t_end: slave_id = 10;
	at t_end: state = MASTER_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = true;
	at t_end: out_slave_0_notify = true;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = true;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_5564 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_1_sig_haddr_at_t = val_master_1_sig_haddr@t,
	val_master_1_sig_hwdata_at_t = val_master_1_sig_hwdata@t,
	val_slave_1_sig_hrdata_at_t = val_slave_1_sig_hrdata@t,
	val_slave_1_sig_hresp_at_t = val_slave_1_sig_hresp@t;
assume:
	at t: start_state;
	at t: ((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and not(out_slave_0_sync)) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and not(val_slave_0_sync)) 
and val_slave_1_sync)
or
(true 
and ((((((((((((((((((((true 
and not(fromReset)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync)
or
(((((((((((((((((((true 
and fromReset) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_REQ)) 
and (state /= SLAVE_RESP)) 
and (state /= SLAVE_RESP)) 
and not((state /= MASTER_REQ))) 
and (master_id > resize(1,32))) 
and not(((val_master_1_sig_haddr >= resize(0,32)) 
and (val_master_1_sig_haddr < resize(65536,32))))) 
and not((resize(1,32) /= resize(1,32)))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not((resize(1,32) = resize(0,32)))) 
and (resize(1,32) = resize(1,32))) 
and not(val_master_0_sync)) 
and val_master_1_sync) 
and out_slave_0_sync) 
and out_slave_1_sync) 
and val_slave_0_sync) 
and val_slave_1_sync))))))))))))));
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 10;
	at t_end: out_master_1_sig_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: out_master_1_sig_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: out_slave_1_sig_haddr = val_master_1_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_1_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_1_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: slave_id = 10;
	at t_end: state = MASTER_REQ;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = true;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = true;
end property;


property start_state_7515 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	fromReset_at_t = fromReset@t,
	master_id_at_t = master_id@t,
	slave_id_at_t = slave_id@t,
	state_at_t = state@t;
assume:
	at t: start_state;
	at t: not(val_master_0_sync);
	at t: not(val_master_1_sync);
	at t: not(out_slave_0_sync);
	at t: not(out_slave_1_sync);
	at t: not(val_slave_0_sync);
	at t: not(val_slave_1_sync);
prove:
	at t_end: start_state;
	at t_end: fromReset = fromReset_at_t;
	at t_end: master_id = master_id_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = state_at_t;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = false;
end property;


property start_state_756 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	val_master_0_sig_haddr_at_t = val_master_0_sig_haddr@t,
	val_master_0_sig_hwdata_at_t = val_master_0_sig_hwdata@t,
	val_slave_1_sig_hrdata_at_t = val_slave_1_sig_hrdata@t,
	val_slave_1_sig_hresp_at_t = val_slave_1_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = MASTER_REQ);
	at t: not((master_id = resize(0,32)));
	at t: (resize(65536,32) <= val_master_0_sig_haddr);
	at t: val_master_0_sync;
	at t: val_master_1_sync;
	at t: out_slave_1_sync;
	at t: val_slave_1_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: master_id = 1;
	at t_end: out_master_0_sig_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: out_master_0_sig_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: out_slave_1_sig_haddr = val_master_0_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: req_haddr = val_master_0_sig_haddr_at_t;
	at t_end: req_hwdata = val_master_0_sig_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: slave_id = 1;
	at t_end: state = SLAVE_REQ;
	at t_end: val_master_0_notify = true;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = true;
end property;


property start_state_788 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	slave_id_at_t = slave_id@t,
	val_slave_1_sig_hrdata_at_t = val_slave_1_sig_hrdata@t,
	val_slave_1_sig_hresp_at_t = val_slave_1_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_RESP);
	at t: (slave_id = resize(1,32));
	at t: val_slave_1_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: resp_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = MASTER_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = false;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = true;
end property;


property start_state_839 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	out_slave_1_sig_haddr_at_t = out_slave_1_sig_haddr@t,
	out_slave_1_sig_hwdata_at_t = out_slave_1_sig_hwdata@t,
	req_haddr_at_t = req_haddr@t,
	req_hwdata_at_t = req_hwdata@t,
	slave_id_at_t = slave_id@t,
	val_slave_1_sig_hrdata_at_t = val_slave_1_sig_hrdata@t,
	val_slave_1_sig_hresp_at_t = val_slave_1_sig_hresp@t;
assume:
	at t: start_state;
	at t: (state = SLAVE_REQ);
	at t: (slave_id = resize(1,32));
	at t: out_slave_1_sync;
	at t: val_slave_1_sync;
prove:
	at t_end: start_state;
	at t_end: fromReset = false;
	at t_end: out_slave_1_sig_haddr = out_slave_1_sig_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = out_slave_1_sig_hwdata_at_t;
	at t_end: out_slave_1_sig_haddr = req_haddr_at_t;
	at t_end: out_slave_1_sig_hwdata = req_hwdata_at_t;
	at t_end: req_haddr = req_haddr_at_t;
	at t_end: req_hwdata = req_hwdata_at_t;
	at t_end: resp_hrdata = val_slave_1_sig_hrdata_at_t;
	at t_end: resp_hresp = val_slave_1_sig_hresp_at_t;
	at t_end: slave_id = slave_id_at_t;
	at t_end: state = MASTER_RESP;
	at t_end: val_master_0_notify = false;
	at t_end: val_master_1_notify = false;
	at t_end: out_slave_0_notify = false;
	at t_end: out_slave_1_notify = true;
	at t_end: val_slave_0_notify = false;
	at t_end: val_slave_1_notify = true;
end property;



