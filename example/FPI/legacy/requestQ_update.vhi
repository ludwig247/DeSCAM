macro peripheral_request_i_notify :  boolean  := end macro;
macro peripheral_request_i_sync   :  boolean  := end macro;
macro updateQ_i_sync   :  boolean  := end macro;


-- DP SIGNALS --
macro buffer1_abort_sig : bool := end macro;
macro buffer1_addr_sig : int := end macro;
macro buffer1_data_sig : int := end macro;
macro buffer1_opc_sig : opc_t := end macro;
macro buffer2_abort_sig : bool := end macro;
macro buffer2_addr_sig : int := end macro;
macro buffer2_data_sig : int := end macro;
macro buffer2_opc_sig : opc_t := end macro;
macro buffer3_abort_sig : bool := end macro;
macro buffer3_addr_sig : int := end macro;
macro buffer3_data_sig : int := end macro;
macro buffer3_opc_sig : opc_t := end macro;
macro peripheral_request_i_abort_sig : bool := end macro;
macro peripheral_request_i_addr_sig : int := end macro;
macro peripheral_request_i_data_sig : int := end macro;
macro peripheral_request_i_opc_sig : opc_t := end macro;
macro req_o_sig : bool := end macro;
macro status1_sig : req_status_t := end macro;
macro status2_sig : req_status_t := end macro;
macro status3_sig : req_status_t := end macro;
macro updateQ_i_sig : update_t := end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer1_var_abort : bool := end macro;
macro buffer1_var_addr : int := end macro;
macro buffer1_var_data : int := end macro;
macro buffer1_var_opc : opc_t := end macro;
macro buffer2_var_abort : bool := end macro;
macro buffer2_var_addr : int := end macro;
macro buffer2_var_data : int := end macro;
macro buffer2_var_opc : opc_t := end macro;
macro buffer3_var_abort : bool := end macro;
macro buffer3_var_addr : int := end macro;
macro buffer3_var_data : int := end macro;
macro buffer3_var_opc : opc_t := end macro;
macro status1_var : req_status_t := end macro;
macro status2_var : req_status_t := end macro;
macro status3_var : req_status_t := end macro;
macro tmp_bool_req : bool := end macro;
macro tmp_bool_update : bool := end macro;
macro tmp_buffer_abort : bool := end macro;
macro tmp_buffer_addr : int := end macro;
macro tmp_buffer_data : int := end macro;
macro tmp_buffer_opc : opc_t := end macro;
macro tmp_update : update_t := end macro;
macro value : bool := end macro;


-- STATES --
macro EMPTY_0 : boolean := section=EMPTY end macro;
macro NON_EMPTY_2 : boolean := section=NON_EMPTY end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: EMPTY_0;
	 at t: buffer1_sig_abort = false;
	 at t: buffer1_sig_addr = 0;
	 at t: buffer1_sig_data = 0;
	 at t: buffer1_sig_opc = BTR2_OPC;
	 at t: buffer1_var_abort = false;
	 at t: buffer1_var_addr = 0;
	 at t: buffer1_var_data = 0;
	 at t: buffer1_var_opc = BTR2_OPC;
	 at t: buffer2_sig_abort = false;
	 at t: buffer2_sig_addr = 0;
	 at t: buffer2_sig_data = 0;
	 at t: buffer2_sig_opc = BTR2_OPC;
	 at t: buffer2_var_abort = false;
	 at t: buffer2_var_addr = 0;
	 at t: buffer2_var_data = 0;
	 at t: buffer2_var_opc = BTR2_OPC;
	 at t: buffer3_sig_abort = false;
	 at t: buffer3_sig_addr = 0;
	 at t: buffer3_sig_data = 0;
	 at t: buffer3_sig_opc = BTR2_OPC;
	 at t: buffer3_var_abort = false;
	 at t: buffer3_var_addr = 0;
	 at t: buffer3_var_data = 0;
	 at t: buffer3_var_opc = BTR2_OPC;
	 at t: req_o_sig = false;
	 at t: status1_sig = EMPTY_STATUS;
	 at t: status1_var = EMPTY_STATUS;
	 at t: status2_sig = EMPTY_STATUS;
	 at t: status2_var = EMPTY_STATUS;
	 at t: status3_sig = EMPTY_STATUS;
	 at t: status3_var = EMPTY_STATUS;
	 at t: tmp_bool_req = false;
	 at t: tmp_bool_update = false;
	 at t: tmp_buffer_abort = false;
	 at t: tmp_buffer_addr = 0;
	 at t: tmp_buffer_data = 0;
	 at t: tmp_buffer_opc = BTR2_OPC;
	 at t: tmp_update = NXT_BTR_Q;
	 at t: value = false;
	 at t: peripheral_request_i_notify = true;
end property;


property EMPTY_0_read_0 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: EMPTY_0;
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = req_o_sig_at_t;
	 at t+1: status1_sig = status1_sig_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_sig_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_sig_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = tmp_bool_req_at_t;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = value_at_t;
	 at t+1: peripheral_request_i_notify = true;
end property;

property EMPTY_0_read_1 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: EMPTY_0;
	 at t: peripheral_request_i_sync;
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = true;
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_sig_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_sig_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = tmp_bool_req_at_t;
	 at t+1: tmp_bool_update = peripheral_request_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = value_at_t;
	 at t+1: peripheral_request_i_notify = true;
end property;

property EMPTY_0_read_2 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: EMPTY_0;
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = req_o_sig_at_t;
	 at t+1: status1_sig = status1_sig_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_sig_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_sig_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = tmp_bool_req_at_t;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = value_at_t;
	 at t+1: peripheral_request_i_notify = true;
end property;

property EMPTY_0_read_3 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: EMPTY_0;
	 at t: peripheral_request_i_sync;
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = true;
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_sig_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_sig_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = tmp_bool_req_at_t;
	 at t+1: tmp_bool_update = peripheral_request_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = value_at_t;
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_4 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_5 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_6 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_7 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_8 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_9 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_10 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_11 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_12 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_13 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status3_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = ADDR_STATUS;
	 at t+1: status2_var = ADDR_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status3_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_14 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_15 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_16 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_17 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_18 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_19 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = false);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = false;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = tmp_update_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_20 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_21 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_22 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_23 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_24 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_25 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_26 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_27 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_28 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_29 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_30 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_31 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_32 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_33 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_34 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((DATA_STAUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((DATA_STAUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_35 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((DATA_STAUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((DATA_STAUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_36 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_37 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_38 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_39 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status3_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = ADDR_STATUS;
	 at t+1: status2_var = ADDR_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status3_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_40 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((DATA_STAUS == REQ_STATUS) or (ADDR_STATUS == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = ADDR_STATUS;
	 at t+1: status2_var = ADDR_STATUS;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((DATA_STAUS == REQ_STATUS) or (ADDR_STATUS == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_41 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status2_var = REQ_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_42 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = ((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = ((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_43 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_44 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status2_var = REQ_STATUS));
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_45 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status1_var_at_t;
	 at t+1: status1_var = status1_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_46 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = status3_var_at_t;
	 at t+1: status3_var = status3_var_at_t;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_47 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer1_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer1_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer1_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer2_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_48 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = ADDR_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status2_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status2_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_49 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = ADDR_STATUS);
	 at t: peripheral_request_i_sync;
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((DATA_STAUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = DATA_STAUS;
	 at t+1: status1_var = DATA_STAUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((DATA_STAUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_50 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: EMPTY_0;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status2_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = status2_var_at_t;
	 at t+1: status1_var = status2_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status2_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_51 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: peripheral_request_i_sync;
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: status1_sig = REQ_STATUS;
	 at t+1: status1_var = REQ_STATUS;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_52 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status2_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = status2_var_at_t;
	 at t+1: status1_var = status2_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status2_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_53 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: peripheral_request_i_sync;
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((status2_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = status2_var_at_t;
	 at t+1: status1_var = status2_var_at_t;
	 at t+1: status2_sig = status2_var_at_t;
	 at t+1: status2_var = status2_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((status2_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_54 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status3_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status3_var_at_t;
	 at t+1: status2_var = status3_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status3_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_55 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: peripheral_request_i_sync;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_56 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (status3_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status3_var_at_t;
	 at t+1: status2_var = status3_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (status3_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_57 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (status3_var_at_t == REQ_STATUS);
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status3_var_at_t;
	 at t+1: status2_var = status3_var_at_t;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = false;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (status3_var_at_t == REQ_STATUS);
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_58 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: peripheral_request_i_sync;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer2_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer2_var_data = buffer3_var_data_at_t;
	 at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (status3_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = status3_var_at_t;
	 at t+1: status2_var = status3_var_at_t;
	 at t+1: status3_sig = REQ_STATUS;
	 at t+1: status3_var = REQ_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (status3_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_59 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
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
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_sig_at_t = status2_sig@t,
	status2_var_at_t = status2_var@t,
	status3_sig_at_t = status3_sig@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: peripheral_request_i_sync;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t+1: NON_EMPTY_2;
	 at t+1: buffer1_sig_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_sig_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_sig_data = buffer2_var_data_at_t;
	 at t+1: buffer1_sig_opc = buffer2_var_opc_at_t;
	 at t+1: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t+1: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t+1: buffer1_var_data = buffer2_var_data_at_t;
	 at t+1: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t+1: buffer2_sig_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_sig_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_sig_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_sig_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: buffer3_sig_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_sig_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_sig_data = buffer3_var_data_at_t;
	 at t+1: buffer3_sig_opc = buffer3_var_opc_at_t;
	 at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t+1: buffer3_var_data = buffer3_var_data_at_t;
	 at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t+1: req_o_sig = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: status1_sig = ADDR_STATUS;
	 at t+1: status1_var = ADDR_STATUS;
	 at t+1: status2_sig = REQ_STATUS;
	 at t+1: status2_var = REQ_STATUS;
	 at t+1: status3_sig = EMPTY_STATUS;
	 at t+1: status3_var = EMPTY_STATUS;
	 at t+1: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t+1: tmp_bool_update = updateQ_i_sync_at_t;
	 at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t+1: tmp_update = updateQ_i_sig_at_t;
	 at t+1: value = (((ADDR_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (EMPTY_STATUS == REQ_STATUS));
	 at t+1: peripheral_request_i_notify = true;
end property;