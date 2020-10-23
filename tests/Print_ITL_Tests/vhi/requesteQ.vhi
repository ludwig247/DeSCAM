-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro updateQ_i_sync : boolean := true end macro;


-- DP SIGNALS --
--macro buffer1_sig : req_t :={false, resize(0,32), resize(0,32), BTR2_OPC} end macro;
macro buffer1_sig_abort : boolean :=false end macro;
macro buffer1_sig_addr : signed :=resize(0,32) end macro;
macro buffer1_sig_data : signed :=resize(0,32) end macro;
macro buffer1_sig_opc : opc_t :=NOP_OPC end macro;
--macro buffer2_sig : req_t :={false, resize(0,32), resize(0,32), BTR2_OPC} end macro;
macro buffer2_sig_abort : boolean :=false end macro;
macro buffer2_sig_addr : signed :=resize(0,32) end macro;
macro buffer2_sig_data : signed :=resize(0,32) end macro;
macro buffer2_sig_opc : opc_t :=NOP_OPC end macro;
--macro buffer3_sig : req_t :={false, resize(0,32), resize(0,32), BTR2_OPC} end macro;
macro buffer3_sig_abort : boolean :=false end macro;
macro buffer3_sig_addr : signed :=resize(0,32) end macro;
macro buffer3_sig_data : signed :=resize(0,32) end macro;
macro buffer3_sig_opc : opc_t :=NOP_OPC end macro;
--macro peripheral_request_i_sig : req_t :={false, resize(0,32), resize(0,32), BTR2_OPC} end macro;
macro peripheral_request_i_sig_abort : boolean :=false end macro;
macro peripheral_request_i_sig_addr : signed :=resize(0,32) end macro;
macro peripheral_request_i_sig_data : signed :=resize(0,32) end macro;
macro peripheral_request_i_sig_opc : opc_t :=NOP_OPC end macro;
macro req_o_sig : boolean :=false end macro;
macro status1_sig : req_status_t :=EMPTY_STATUS end macro;
macro status2_sig : req_status_t :=EMPTY_STATUS end macro;
macro status3_sig : req_status_t :=EMPTY_STATUS end macro;
macro updateQ_i_sig : update_t :=NXT_GRANT_Q end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer2_var_abort : boolean :=false end macro;
macro buffer2_var_addr : signed :=resize(0,32) end macro;
macro buffer2_var_data : signed :=resize(0,32) end macro;
macro buffer2_var_opc : opc_t :=NOP_OPC end macro;
macro buffer3_var_abort : boolean :=false end macro;
macro buffer3_var_addr : signed :=resize(0,32) end macro;
macro buffer3_var_data : signed :=resize(0,32) end macro;
macro buffer3_var_opc : opc_t :=NOP_OPC end macro;
macro nextphase : Phases :=STARTUP end macro;
macro status1_var : req_status_t :=EMPTY_STATUS end macro;
macro status2_var : req_status_t :=EMPTY_STATUS end macro;
macro status3_var : req_status_t :=EMPTY_STATUS end macro;
macro tmp_buffer_abort : boolean :=false end macro;
macro tmp_buffer_addr : signed :=resize(0,32) end macro;
macro tmp_buffer_data : signed :=resize(0,32) end macro;
macro tmp_buffer_opc : opc_t :=NOP_OPC end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: buffer1_sig_abort = false;
	 at t: buffer1_sig_addr = resize(0,32);
	 at t: buffer1_sig_data = resize(0,32);
	 at t: buffer1_sig_opc = BTR2_OPC;
	 at t: buffer2_sig_abort = false;
	 at t: buffer2_sig_addr = resize(0,32);
	 at t: buffer2_sig_data = resize(0,32);
	 at t: buffer2_sig_opc = BTR2_OPC;
	 at t: buffer2_var_abort = false;
	 at t: buffer2_var_addr = resize(0,32);
	 at t: buffer2_var_data = resize(0,32);
	 at t: buffer2_var_opc = NOP_OPC;
	 at t: buffer3_sig_abort = false;
	 at t: buffer3_sig_addr = resize(0,32);
	 at t: buffer3_sig_data = resize(0,32);
	 at t: buffer3_sig_opc = BTR2_OPC;
	 at t: buffer3_var_abort = false;
	 at t: buffer3_var_addr = resize(0,32);
	 at t: buffer3_var_data = resize(0,32);
	 at t: buffer3_var_opc = NOP_OPC;
	 at t: nextphase = EMPTY;
	 at t: req_o_sig = false;
	 at t: status1_sig = EMPTY_STATUS;
	 at t: status1_var = EMPTY_STATUS;
	 at t: status2_sig = EMPTY_STATUS;
	 at t: status2_var = EMPTY_STATUS;
	 at t: status3_sig = EMPTY_STATUS;
	 at t: status3_var = EMPTY_STATUS;
	 at t: tmp_buffer_abort = false;
	 at t: tmp_buffer_addr = resize(0,32);
	 at t: tmp_buffer_data = resize(0,32);
	 at t: tmp_buffer_opc = NOP_OPC;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_1;
	at t: updateQ_i_sync;
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = NON_EMPTY;
	at t_end: req_o_sig = true;
	at t_end: status1_sig = REQ_STATUS;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_1;
	at t: not(updateQ_i_sync);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = NON_EMPTY;
	at t_end: req_o_sig = true;
	at t_end: status1_sig = REQ_STATUS;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status2_var = REQ_STATUS);
	at t: (status1_var = DATA_STAUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = EMPTY_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status2_var = REQ_STATUS);
	at t: (status1_var = DATA_STAUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status3_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: (status2_var = REQ_STATUS);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = ADDR_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: (status2_var = REQ_STATUS);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = ADDR_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status2_var = REQ_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = EMPTY_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = EMPTY_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: not((status2_var = REQ_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status2_var = ADDR_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = EMPTY_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: not((status2_var = ADDR_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status2_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = DATA_STAUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_49 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = EMPTY_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status1_var = DATA_STAUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer2_var_data = buffer3_var_data_at_t;
	at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status3_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_55 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_57 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_59 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_63 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_65 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status2_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_69 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status2_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_73 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status2_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_77 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status2_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_84 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_sig_abort@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_sig_addr@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_sig_data@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_sig_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_2_86 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = REQ_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_88 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer2_var_data = tmp_buffer_data_at_t;
	at t_end: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	at t_end: buffer3_var_data = buffer3_var_data_at_t;
	at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = REQ_STATUS;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = status3_var_at_t;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = ADDR_STATUS;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_2_90 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_data_at_t = buffer3_sig_data@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	nextphase_at_t = nextphase@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t;
assume:
	at t: state_2;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t_end: state_2;
	at t_end: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t_end: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t_end: buffer1_sig_data = buffer1_sig_data_at_t;
	at t_end: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t_end: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t_end: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t_end: buffer2_sig_data = buffer2_sig_data_at_t;
	at t_end: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	at t_end: buffer2_var_data = buffer2_var_data_at_t;
	at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	at t_end: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t_end: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t_end: buffer3_sig_data = buffer3_sig_data_at_t;
	at t_end: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t_end: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t_end: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t_end: buffer3_var_data = tmp_buffer_data_at_t;
	at t_end: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: req_o_sig = req_o_sig_at_t;
	at t_end: status1_sig = status1_sig_at_t;
	at t_end: status1_var = status1_var_at_t;
	at t_end: status2_sig = status2_sig_at_t;
	at t_end: status2_var = status2_var_at_t;
	at t_end: status3_sig = status3_sig_at_t;
	at t_end: status3_var = REQ_STATUS;
	at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


