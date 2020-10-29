-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro updateQ_i_sync : boolean := end macro;


-- DP SIGNALS --
macro buffer1_sig_abort : bool := buffer1.abort end macro;
macro buffer1_sig_addr : int := buffer1.addr end macro;
macro buffer1_sig_data : int := buffer1.data end macro;
macro buffer1_sig_opc : opc_t := buffer1.opc end macro;
macro buffer2_sig_abort : bool := buffer2.abort end macro;
macro buffer2_sig_addr : int := buffer2.addr end macro;
macro buffer2_sig_data : int := buffer2.data end macro;
macro buffer2_sig_opc : opc_t := buffer2.opc end macro;
macro buffer3_sig_abort : bool := buffer3.abort end macro;
macro buffer3_sig_addr : int := buffer3.addr end macro;
macro buffer3_sig_data : int := buffer3.data end macro;
macro buffer3_sig_opc : opc_t := buffer3.opc end macro;
macro peripheral_request_i_sig_abort : bool := peripheral_request_i.abort end macro;
macro peripheral_request_i_sig_addr : int := peripheral_request_i.addr end macro;
macro peripheral_request_i_sig_data : int := peripheral_request_i.data end macro;
macro peripheral_request_i_sig_opc : opc_t := peripheral_request_i.opc end macro;
macro req_o_sig : bool := req_o end macro;
macro status1_sig : req_status_t := status1 end macro;
macro status2_sig : req_status_t := status2 end macro;
macro status3_sig : req_status_t := status3 end macro;
macro updateQ_i_sig : update_t := updateQ_i end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro buffer2_var_abort : bool := buffer2_var_signal.abort end macro;
macro buffer2_var_addr : int := buffer2_var_signal.addr end macro;
macro buffer2_var_data : int := buffer2_var_signal.data end macro;
macro buffer2_var_opc : opc_t := buffer2_var_signal.opc end macro;
macro buffer3_var_abort : bool := buffer3_var_signal.abort end macro;
macro buffer3_var_addr : int := buffer3_var_signal.addr end macro;
macro buffer3_var_data : int := buffer3_var_signal.data end macro;
macro buffer3_var_opc : opc_t := buffer3_var_signal.opc end macro;
macro nextphase : requesteQ_SECTIONS := section end macro;
macro status1_var : req_status_t := status1_var_signal end macro;
macro status2_var : req_status_t := status2_var_signal end macro;
macro status3_var : req_status_t := status3_var_signal end macro;
macro tmp_buffer_abort : bool := tmp_buffer_signal.abort end macro;
macro tmp_buffer_addr : int := tmp_buffer_signal.addr end macro;
macro tmp_buffer_data : int := tmp_buffer_signal.data end macro;
macro tmp_buffer_opc : opc_t := tmp_buffer_signal.opc end macro;


-- STATES --
macro state_47 : boolean := section = EMPTY end macro;
macro state_54 : boolean := section = NON_EMPTY end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_47;
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
	 at t: buffer2_var_opc = BTR2_OPC;
	 at t: buffer3_sig_abort = false;
	 at t: buffer3_sig_addr = resize(0,32);
	 at t: buffer3_sig_data = resize(0,32);
	 at t: buffer3_sig_opc = BTR2_OPC;
	 at t: buffer3_var_abort = false;
	 at t: buffer3_var_addr = resize(0,32);
	 at t: buffer3_var_data = resize(0,32);
	 at t: buffer3_var_opc = BTR2_OPC;
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
	 at t: tmp_buffer_opc = BTR2_OPC;
end property;


property state_47_1 is
dependencies: no_reset;
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
	at t: state_47;
	at t: updateQ_i_sync;
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = NON_EMPTY;
	at t+1: req_o_sig = true;
	at t+1: status1_sig = REQ_STATUS;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_47_2 is
dependencies: no_reset;
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
	at t: state_47;
	at t: not(updateQ_i_sync);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = NON_EMPTY;
	at t+1: req_o_sig = true;
	at t+1: status1_sig = REQ_STATUS;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_3 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_5 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_7 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_9 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status1_var = REQ_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_11 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status2_var = REQ_STATUS);
	at t: (status1_var = DATA_STAUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = EMPTY_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_13 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: (status2_var = REQ_STATUS);
	at t: (status1_var = DATA_STAUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status3_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_15 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: (status2_var = REQ_STATUS);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = ADDR_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_17 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: (status2_var = REQ_STATUS);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = ADDR_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_19 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status2_var = REQ_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = EMPTY_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_21 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = EMPTY_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_23 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_GRANT_Q);
	at t: not((status1_var = REQ_STATUS));
	at t: not((status2_var = REQ_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_25 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status2_var = ADDR_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_27 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = EMPTY_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_29 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = DATA_STAUS);
	at t: not((status2_var = ADDR_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status2_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_31 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_33 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_35 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_37 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status1_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = DATA_STAUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_39 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_41 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_43 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_45 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_47 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_49 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_PHASE_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status1_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_51 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status1_var = DATA_STAUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = EMPTY_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_53 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status1_var = DATA_STAUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer2_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer2_var_data = buffer3_var_data_at_t;
	at t+1: buffer2_var_opc = buffer3_var_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = ADDR_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status3_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_55 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_57 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_59 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_61 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_63 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_65 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: (updateQ_i_sig = NXT_BTR_Q);
	at t: not((status1_var = DATA_STAUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_67 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status2_var = ADDR_STATUS);
	at t: (status3_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_69 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status2_var = ADDR_STATUS);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_71 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: (status3_var = EMPTY_STATUS);
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_73 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status2_var = ADDR_STATUS));
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_75 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_77 is
dependencies: no_reset;
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
	at t: state_54;
	at t: updateQ_i_sync;
	at t: not((updateQ_i_sig = NXT_GRANT_Q));
	at t: not((updateQ_i_sig = NXT_PHASE_Q));
	at t: not((updateQ_i_sig = NXT_BTR_Q));
	at t: not((status2_var = ADDR_STATUS));
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_80 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_82 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer2_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer2_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer2_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_84 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: (status3_var = EMPTY_STATUS);
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: buffer3_var_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: buffer3_var_data = peripheral_request_i_sig_data_at_t;
	at t+1: buffer3_var_opc = peripheral_request_i_sig_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = peripheral_request_i_sig_abort_at_t;
	at t+1: tmp_buffer_addr = peripheral_request_i_sig_addr_at_t;
	at t+1: tmp_buffer_data = peripheral_request_i_sig_data_at_t;
	at t+1: tmp_buffer_opc = peripheral_request_i_sig_opc_at_t;
end property;


property state_54_86 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: (status1_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = REQ_STATUS;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_88 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: (status2_var = EMPTY_STATUS);
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
	at t+1: buffer2_sig_abort = buffer2_sig_abort_at_t;
	at t+1: buffer2_sig_addr = buffer2_sig_addr_at_t;
	at t+1: buffer2_sig_data = buffer2_sig_data_at_t;
	at t+1: buffer2_sig_opc = buffer2_sig_opc_at_t;
	at t+1: buffer2_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer2_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer2_var_data = tmp_buffer_data_at_t;
	at t+1: buffer2_var_opc = tmp_buffer_opc_at_t;
	at t+1: buffer3_sig_abort = buffer3_sig_abort_at_t;
	at t+1: buffer3_sig_addr = buffer3_sig_addr_at_t;
	at t+1: buffer3_sig_data = buffer3_sig_data_at_t;
	at t+1: buffer3_sig_opc = buffer3_sig_opc_at_t;
	at t+1: buffer3_var_abort = buffer3_var_abort_at_t;
	at t+1: buffer3_var_addr = buffer3_var_addr_at_t;
	at t+1: buffer3_var_data = buffer3_var_data_at_t;
	at t+1: buffer3_var_opc = buffer3_var_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = REQ_STATUS;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = status3_var_at_t;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


property state_54_90 is
dependencies: no_reset;
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
	at t: state_54;
	at t: not(updateQ_i_sync);
	at t: not((status3_var = EMPTY_STATUS));
	at t: not((status1_var = EMPTY_STATUS));
	at t: not((status2_var = EMPTY_STATUS));
	at t: (nextphase = NON_EMPTY);
prove:
	at t+1: state_54;
	at t+1: buffer1_sig_abort = buffer1_sig_abort_at_t;
	at t+1: buffer1_sig_addr = buffer1_sig_addr_at_t;
	at t+1: buffer1_sig_data = buffer1_sig_data_at_t;
	at t+1: buffer1_sig_opc = buffer1_sig_opc_at_t;
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
	at t+1: buffer3_var_abort = tmp_buffer_abort_at_t;
	at t+1: buffer3_var_addr = tmp_buffer_addr_at_t;
	at t+1: buffer3_var_data = tmp_buffer_data_at_t;
	at t+1: buffer3_var_opc = tmp_buffer_opc_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: req_o_sig = req_o_sig_at_t;
	at t+1: status1_sig = status1_sig_at_t;
	at t+1: status1_var = status1_var_at_t;
	at t+1: status2_sig = status2_sig_at_t;
	at t+1: status2_var = status2_var_at_t;
	at t+1: status3_sig = status3_sig_at_t;
	at t+1: status3_var = REQ_STATUS;
	at t+1: tmp_buffer_abort = tmp_buffer_abort_at_t;
	at t+1: tmp_buffer_addr = tmp_buffer_addr_at_t;
	at t+1: tmp_buffer_data = tmp_buffer_data_at_t;
	at t+1: tmp_buffer_opc = tmp_buffer_opc_at_t;
end property;


