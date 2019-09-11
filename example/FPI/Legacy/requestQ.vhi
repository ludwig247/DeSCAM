-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro peripheral_request_i_notify :  boolean  := end macro;
macro peripheral_request_i_sync   :  boolean  := end macro;
macro updateQ_i_notify :  boolean  := end macro;
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
macro EMPTY_1 : boolean := section=EMPTY end macro;
macro NON_EMPTY_2 : boolean := section=NON_EMPTY end macro;
macro NON_EMPTY_3 : boolean := section=NON_EMPTY end macro;


--Operations --
property reset is
for timepoints:
	t_end = t+1;
assume:
	 reset_sequence;
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_var_abort = false;
	 at t_end: buffer1_var_addr = 0;
	 at t_end: buffer1_var_data = 0;
	 at t_end: buffer1_var_opc = BTR2_OPC;
	 at t_end: buffer2_var_abort = false;
	 at t_end: buffer2_var_addr = 0;
	 at t_end: buffer2_var_data = 0;
	 at t_end: buffer2_var_opc = BTR2_OPC;
	 at t_end: buffer3_var_abort = false;
	 at t_end: buffer3_var_addr = 0;
	 at t_end: buffer3_var_data = 0;
	 at t_end: buffer3_var_opc = BTR2_OPC;
	 at t_end: req_o_sig = false;
	 at t_end: status1_sig = EMPTY_STATUS;
	 at t_end: status1_var = EMPTY_STATUS;
	 at t_end: status2_sig = EMPTY_STATUS;
	 at t_end: status2_var = EMPTY_STATUS;
	 at t_end: status3_sig = EMPTY_STATUS;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = false;
	 at t_end: tmp_buffer_addr = 0;
	 at t_end: tmp_buffer_data = 0;
	 at t_end: tmp_buffer_opc = BTR2_OPC;
	 at t_end: tmp_update = NXT_BTR_Q;
	 at t_end: value = false;
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property EMPTY_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: EMPTY_0;
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: EMPTY_1;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = tmp_bool_req_at_t;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property EMPTY_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: EMPTY_0;
	 at t: (updateQ_i_sync = false);
prove:
	 at t_end: EMPTY_1;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = tmp_bool_req_at_t;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property EMPTY_1_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: EMPTY_1;
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = tmp_bool_req_at_t;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property EMPTY_1_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	req_o_sig_at_t = req_o_sig@t,
	status1_sig_at_t = status1_sig@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: EMPTY_1;
	 at t: peripheral_request_i_sync;
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = true;
	 at t_end: status1_sig = REQ_STATUS;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = tmp_bool_req_at_t;
	 at t_end: tmp_bool_update = peripheral_request_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = ADDR_STATUS;
	 at t_end: status1_var = ADDR_STATUS;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
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
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: not((status3_var = EMPTY_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = DATA_STAUS;
	 at t_end: status1_var = DATA_STAUS;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = ((status2_var_at_t == REQ_STATUS) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
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
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = REQ_STATUS;
	 at t_end: status1_var = REQ_STATUS;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
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
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (status3_var_at_t == REQ_STATUS);
	 at t_end: status1_sig = DATA_STAUS;
	 at t_end: status1_var = DATA_STAUS;
	 at t_end: status2_sig = ADDR_STATUS;
	 at t_end: status2_var = ADDR_STATUS;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (status3_var_at_t == REQ_STATUS);
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	updateQ_i_sig_at_t = updateQ_i_sig@t;
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
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = REQ_STATUS;
	 at t_end: status1_var = REQ_STATUS;
	 at t_end: status2_sig = REQ_STATUS;
	 at t_end: status2_var = REQ_STATUS;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = (((REQ_STATUS == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_2_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = false;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = ADDR_STATUS;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = DATA_STAUS;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = REQ_STATUS;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = DATA_STAUS;
	 at t_end: status2_var = ADDR_STATUS;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer2_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer3_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = REQ_STATUS;
	 at t_end: status2_var = REQ_STATUS;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = ADDR_STATUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer2_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer3_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = DATA_STAUS;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer2_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer3_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer2_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer3_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = ADDR_STATUS;
	 at t_end: status2_var = status3_var_at_t;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_2_read_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_var_abort_at_t = buffer3_var_abort@t,
	buffer3_var_addr_at_t = buffer3_var_addr@t,
	buffer3_var_data_at_t = buffer3_var_data@t,
	buffer3_var_opc_at_t = buffer3_var_opc@t,
	status1_var_at_t = status1_var@t,
	status2_var_at_t = status2_var@t,
	status3_var_at_t = status3_var@t,
	tmp_bool_req_at_t = tmp_bool_req@t,
	tmp_bool_update_at_t = tmp_bool_update@t,
	tmp_buffer_abort_at_t = tmp_buffer_abort@t,
	tmp_buffer_addr_at_t = tmp_buffer_addr@t,
	tmp_buffer_data_at_t = tmp_buffer_data@t,
	tmp_buffer_opc_at_t = tmp_buffer_opc@t,
	tmp_update_at_t = tmp_update@t,
	value_at_t = value@t,
	updateQ_i_sig_at_t = updateQ_i_sig@t;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
prove:
	 at t_end: NON_EMPTY_3;
	 at t_end: buffer1_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer2_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer3_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: status1_var = ADDR_STATUS;
	 at t_end: status2_var = status3_var_at_t;
	 at t_end: status3_var = EMPTY_STATUS;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = updateQ_i_sync_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = updateQ_i_sig_at_t;
	 at t_end: value = value_at_t;
	 during[t+1, t_end-1]: peripheral_request_i_notify = false;
	 during[t+1, t_end]: updateQ_i_notify = false;
	 at t_end: peripheral_request_i_notify = true;
end property;

property NON_EMPTY_3_read_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: NON_EMPTY_3;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: EMPTY_0;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = tmp_bool_update_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_3_read_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: NON_EMPTY_3;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = false;
	 at t_end: tmp_bool_update = tmp_bool_update_at_t;
	 at t_end: tmp_buffer_abort = tmp_buffer_abort_at_t;
	 at t_end: tmp_buffer_addr = tmp_buffer_addr_at_t;
	 at t_end: tmp_buffer_data = tmp_buffer_data_at_t;
	 at t_end: tmp_buffer_opc = tmp_buffer_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_3_read_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: NON_EMPTY_3;
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer1_addr_sig = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer1_data_sig = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer1_opc_sig = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer1_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer1_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer1_var_data = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer1_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = REQ_STATUS;
	 at t_end: status1_var = REQ_STATUS;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t_end: tmp_bool_update = tmp_bool_update_at_t;
	 at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_3_read_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: NON_EMPTY_3;
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer2_addr_sig = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer2_data_sig = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer2_opc_sig = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer3_abort_sig = buffer3_var_abort_at_t;
	 at t_end: buffer3_addr_sig = buffer3_var_addr_at_t;
	 at t_end: buffer3_data_sig = buffer3_var_data_at_t;
	 at t_end: buffer3_opc_sig = buffer3_var_opc_at_t;
	 at t_end: buffer3_var_abort = buffer3_var_abort_at_t;
	 at t_end: buffer3_var_addr = buffer3_var_addr_at_t;
	 at t_end: buffer3_var_data = buffer3_var_data_at_t;
	 at t_end: buffer3_var_opc = buffer3_var_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = REQ_STATUS;
	 at t_end: status2_var = REQ_STATUS;
	 at t_end: status3_sig = status3_var_at_t;
	 at t_end: status3_var = status3_var_at_t;
	 at t_end: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t_end: tmp_bool_update = tmp_bool_update_at_t;
	 at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;

property NON_EMPTY_3_read_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_abort_sig@t,
	buffer1_sig_addr_at_t = buffer1_addr_sig@t,
	buffer1_sig_data_at_t = buffer1_data_sig@t,
	buffer1_sig_opc_at_t = buffer1_opc_sig@t,
	buffer1_var_abort_at_t = buffer1_var_abort@t,
	buffer1_var_addr_at_t = buffer1_var_addr@t,
	buffer1_var_data_at_t = buffer1_var_data@t,
	buffer1_var_opc_at_t = buffer1_var_opc@t,
	buffer2_sig_abort_at_t = buffer2_abort_sig@t,
	buffer2_sig_addr_at_t = buffer2_addr_sig@t,
	buffer2_sig_data_at_t = buffer2_data_sig@t,
	buffer2_sig_opc_at_t = buffer2_opc_sig@t,
	buffer2_var_abort_at_t = buffer2_var_abort@t,
	buffer2_var_addr_at_t = buffer2_var_addr@t,
	buffer2_var_data_at_t = buffer2_var_data@t,
	buffer2_var_opc_at_t = buffer2_var_opc@t,
	buffer3_sig_abort_at_t = buffer3_abort_sig@t,
	buffer3_sig_addr_at_t = buffer3_addr_sig@t,
	buffer3_sig_data_at_t = buffer3_data_sig@t,
	buffer3_sig_opc_at_t = buffer3_opc_sig@t,
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
	peripheral_request_i_sig_abort_at_t = peripheral_request_i_abort_sig@t,
	peripheral_request_i_sig_addr_at_t = peripheral_request_i_addr_sig@t,
	peripheral_request_i_sig_data_at_t = peripheral_request_i_data_sig@t,
	peripheral_request_i_sig_opc_at_t = peripheral_request_i_opc_sig@t;
assume:
	 at t: NON_EMPTY_3;
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = true);
prove:
	 at t_end: NON_EMPTY_2;
	 at t_end: buffer1_abort_sig = buffer1_var_abort_at_t;
	 at t_end: buffer1_addr_sig = buffer1_var_addr_at_t;
	 at t_end: buffer1_data_sig = buffer1_var_data_at_t;
	 at t_end: buffer1_opc_sig = buffer1_var_opc_at_t;
	 at t_end: buffer1_var_abort = buffer1_var_abort_at_t;
	 at t_end: buffer1_var_addr = buffer1_var_addr_at_t;
	 at t_end: buffer1_var_data = buffer1_var_data_at_t;
	 at t_end: buffer1_var_opc = buffer1_var_opc_at_t;
	 at t_end: buffer2_abort_sig = buffer2_var_abort_at_t;
	 at t_end: buffer2_addr_sig = buffer2_var_addr_at_t;
	 at t_end: buffer2_data_sig = buffer2_var_data_at_t;
	 at t_end: buffer2_opc_sig = buffer2_var_opc_at_t;
	 at t_end: buffer2_var_abort = buffer2_var_abort_at_t;
	 at t_end: buffer2_var_addr = buffer2_var_addr_at_t;
	 at t_end: buffer2_var_data = buffer2_var_data_at_t;
	 at t_end: buffer2_var_opc = buffer2_var_opc_at_t;
	 at t_end: buffer3_abort_sig = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer3_addr_sig = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer3_data_sig = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer3_opc_sig = peripheral_request_i_sig_opc_at_t;
	 at t_end: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	 at t_end: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 at t_end: status1_sig = status1_var_at_t;
	 at t_end: status1_var = status1_var_at_t;
	 at t_end: status2_sig = status2_var_at_t;
	 at t_end: status2_var = status2_var_at_t;
	 at t_end: status3_sig = REQ_STATUS;
	 at t_end: status3_var = REQ_STATUS;
	 at t_end: tmp_bool_req = peripheral_request_i_sync_at_t;
	 at t_end: tmp_bool_update = tmp_bool_update_at_t;
	 at t_end: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	 at t_end: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	 at t_end: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	 at t_end: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
	 at t_end: tmp_update = tmp_update_at_t;
	 at t_end: value = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
	 during[t+1, t_end]: peripheral_request_i_notify = false;
	 during[t+1, t_end-1]: updateQ_i_notify = false;
	 at t_end: updateQ_i_notify = true;
end property;