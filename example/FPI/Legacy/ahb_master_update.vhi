macro master_done_notify :  boolean  := end macro;
macro master_result_o_notify :  boolean  := end macro;
macro ready_i_sync   :  boolean  := end macro;
macro updateQ_o_notify :  boolean  := end macro;


-- DP SIGNALS --
macro abort_en_o_sig : bool := end macro;
macro abort_o_sig : bool := end macro;
macro ack_i_sig : ack_t := end macro;
macro addr_en_o_sig : bool := end macro;
macro addr_o_sig : int := end macro;
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
macro data_en_o_sig : bool := end macro;
macro data_i_sig : int := end macro;
macro data_o_sig : int := end macro;
macro gnt_i_sig : bool := end macro;
macro master_done_data_sig : int := end macro;
macro master_done_err_sig : bool := end macro;
macro master_result_o_sig : bool := end macro;
macro opc_o_sig : opc_t := end macro;
macro ready_i_sig : bool := end macro;
macro status1_sig : req_status_t := end macro;
macro status2_sig : req_status_t := end macro;
macro status3_sig : req_status_t := end macro;
macro updateQ_o_sig : update_t := end macro;
macro wait_cnt_end_sig : bool := end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro ack_tmp : ack_t := end macro;
macro btrCnt : int := end macro;
macro buffer1_tmp_abort : bool := end macro;
macro buffer1_tmp_addr : int := end macro;
macro buffer1_tmp_data : int := end macro;
macro buffer1_tmp_opc : opc_t := end macro;
macro buffer2_tmp_abort : bool := end macro;
macro buffer2_tmp_addr : int := end macro;
macro buffer2_tmp_data : int := end macro;
macro buffer2_tmp_opc : opc_t := end macro;
macro buffer3_tmp_abort : bool := end macro;
macro buffer3_tmp_addr : int := end macro;
macro buffer3_tmp_data : int := end macro;
macro buffer3_tmp_opc : opc_t := end macro;
macro gnt : bool := end macro;
macro nop : bool := end macro;
macro result_tmp_data : int := end macro;
macro result_tmp_err : bool := end macro;
macro status1_tmp : req_status_t := end macro;
macro status2_tmp : req_status_t := end macro;
macro status3_tmp : req_status_t := end macro;
macro tmp_bool : bool := end macro;
macro updateQ_cycle_tmp : bool := end macro;
macro updateQ_msg_tmp : update_t := end macro;


-- STATES --
macro ADDR_0 : boolean := section=ADDR end macro;
macro BTR_CONT_4 : boolean := section=BTR_CONT end macro;
macro DATA_10 : boolean := section=DATA end macro;
macro DATA_ADDR_15 : boolean := section=DATA_ADDR end macro;
macro IDLE_21 : boolean := section=IDLE end macro;
macro WAIT_BEFORE_RETRY_24 : boolean := section=WAIT_BEFORE_RETRY end macro;


--Operations --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_21;
	 at t: abort_en_o_sig = false;
	 at t: abort_o_sig = false;
	 at t: ack_tmp = ERR;
	 at t: addr_en_o_sig = false;
	 at t: addr_o_sig = 0;
	 at t: btrCnt = 0;
	 at t: buffer1_tmp_abort = false;
	 at t: buffer1_tmp_addr = 0;
	 at t: buffer1_tmp_data = 0;
	 at t: buffer1_tmp_opc = BTR2_OPC;
	 at t: buffer2_tmp_abort = false;
	 at t: buffer2_tmp_addr = 0;
	 at t: buffer2_tmp_data = 0;
	 at t: buffer2_tmp_opc = BTR2_OPC;
	 at t: buffer3_tmp_abort = false;
	 at t: buffer3_tmp_addr = 0;
	 at t: buffer3_tmp_data = 0;
	 at t: buffer3_tmp_opc = BTR2_OPC;
	 at t: data_en_o_sig = false;
	 at t: data_o_sig = 0;
	 at t: gnt = false;
	 at t: nop = false;
	 at t: opc_o_sig = BTR2_OPC;
	 at t: result_tmp_data = 0;
	 at t: result_tmp_err = false;
	 at t: status1_tmp = ADDR_STATUS;
	 at t: status2_tmp = ADDR_STATUS;
	 at t: status3_tmp = ADDR_STATUS;
	 at t: tmp_bool = false;
	 at t: updateQ_cycle_tmp = false;
	 at t: updateQ_msg_tmp = NXT_BTR_Q;
	 at t: master_done_notify = false;
	 at t: master_result_o_notify = false;
	 at t: updateQ_o_notify = false;
end property;


property ADDR_0_read_0 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: gnt_i_sig;
	 at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_BTR_Q;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_1 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: gnt_i_sig;
	 at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_BTR_Q;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_2 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_sig_opc = BTR2_OPC));
	 at t: not((buffer1_sig_opc = BTR4_OPC));
	 at t: not((buffer1_sig_opc = BTR8_OPC));
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_3 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_4 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_sig_opc = BTR2_OPC));
	 at t: not((buffer1_sig_opc = BTR4_OPC));
	 at t: not((buffer1_sig_opc = BTR8_OPC));
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_5 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_6 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_7 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_8 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_9 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_10 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_sig_opc = BTR2_OPC));
	 at t: not((buffer1_sig_opc = BTR4_OPC));
	 at t: not((buffer1_sig_opc = BTR8_OPC));
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_11 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_sig_opc = BTR2_OPC));
	 at t: not((buffer1_sig_opc = BTR4_OPC));
	 at t: not((buffer1_sig_opc = BTR8_OPC));
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_12 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property ADDR_0_read_13 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: ADDR_0;
	 at t: (buffer1_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_14 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: (ack_i_sig = RTY);
	 at t: gnt_i_sig;
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_15 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: (ack_i_sig = RTY);
	 at t: not(gnt_i_sig);
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_16 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: (ack_i_sig = RTY);
	 at t: not(gnt_i_sig);
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_17 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: (ack_i_sig = RTY);
	 at t: gnt_i_sig;
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_18 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property BTR_CONT_4_read_19 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property BTR_CONT_4_read_20 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property BTR_CONT_4_read_21 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property BTR_CONT_4_read_22 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_23 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_24 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_25 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_26 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property BTR_CONT_4_read_27 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_28 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = gnt_i_sig_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_29 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = gnt_i_sig_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_30 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = gnt_i_sig_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_31 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = gnt_i_sig_at_t;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_32 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_33 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_34 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_35 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_36 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_37 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_38 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_39 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_40 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_41 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_42 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_10_read_43 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_44 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_45 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_46 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_47 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_48 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_49 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_50 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_51 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_sig_opc = RMW_OPC);
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = RTY_Q;
	 at t+1: updateQ_o_sig = RTY_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_52 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property DATA_ADDR_15_read_53 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property DATA_ADDR_15_read_54 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property DATA_ADDR_15_read_55 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property DATA_ADDR_15_read_56 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = (1 + buffer2_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_BTR_Q;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_57 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: BTR_CONT_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = (1 + buffer2_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_BTR_Q;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_58 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_sig_opc = BTR2_OPC));
	 at t: not((buffer2_sig_opc = BTR4_OPC));
	 at t: not((buffer2_sig_opc = BTR8_OPC));
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_59 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_sig_opc = BTR2_OPC));
	 at t: not((buffer2_sig_opc = BTR4_OPC));
	 at t: not((buffer2_sig_opc = BTR8_OPC));
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_60 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_61 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_15;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_62 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_sig_opc = BTR2_OPC));
	 at t: not((buffer2_sig_opc = BTR4_OPC));
	 at t: not((buffer2_sig_opc = BTR8_OPC));
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_63 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_64 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: not((buffer2_sig_opc = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_sig_opc = BTR2_OPC));
	 at t: not((buffer2_sig_opc = BTR4_OPC));
	 at t: not((buffer2_sig_opc = BTR8_OPC));
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property DATA_ADDR_15_read_65 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_sig_data@t,
	master_done_sig_err_at_t = master_done_sig_err@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	 at t: (buffer2_sig_opc = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_10;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: ack_tmp = ack_i_sig_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: master_done_sig_data = data_i_sig_at_t;
	 at t+1: master_done_sig_err = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = data_i_sig_at_t;
	 at t+1: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;
	 at t+1: master_done_notify = true;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property IDLE_21_read_66 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_67 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_68 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_69 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_70 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_71 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_72 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_73 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = false;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property IDLE_21_read_74 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property IDLE_21_read_75 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = ready_i_sig_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property IDLE_21_read_76 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property IDLE_21_read_77 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t,
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_sig_at_t;
	 at t+1: status2_tmp = status2_sig_at_t;
	 at t+1: status3_tmp = status3_sig_at_t;
	 at t+1: tmp_bool = tmp_bool_at_t;
	 at t+1: updateQ_cycle_tmp = true;
	 at t+1: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_78 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_79 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_80 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_81 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_82 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_83 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_84 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_85 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_21;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_86 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_87 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_88 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_89 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_90 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: addr_o_sig = addr_o_sig_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = opc_o_sig_at_t;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_91 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = false;
	 at t+1: abort_o_sig = abort_o_sig_at_t;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: data_o_sig = data_o_sig_at_t;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_92 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;

property WAIT_BEFORE_RETRY_24_read_93 is
dependencies: no_reset;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_tmp_abort_at_t = buffer1_tmp_abort@t,
	buffer1_tmp_addr_at_t = buffer1_tmp_addr@t,
	buffer1_tmp_data_at_t = buffer1_tmp_data@t,
	buffer1_tmp_opc_at_t = buffer1_tmp_opc@t,
	buffer2_tmp_abort_at_t = buffer2_tmp_abort@t,
	buffer2_tmp_addr_at_t = buffer2_tmp_addr@t,
	buffer2_tmp_data_at_t = buffer2_tmp_data@t,
	buffer2_tmp_opc_at_t = buffer2_tmp_opc@t,
	buffer3_tmp_abort_at_t = buffer3_tmp_abort@t,
	buffer3_tmp_addr_at_t = buffer3_tmp_addr@t,
	buffer3_tmp_data_at_t = buffer3_tmp_data@t,
	buffer3_tmp_opc_at_t = buffer3_tmp_opc@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_24;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: ack_tmp = ack_tmp_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t+1: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t+1: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t+1: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t+1: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t+1: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t+1: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t+1: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t+1: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t+1: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t+1: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t+1: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: gnt = gnt_i_sig_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: result_tmp_data = result_tmp_data_at_t;
	 at t+1: result_tmp_err = result_tmp_err_at_t;
	 at t+1: status1_tmp = status1_tmp_at_t;
	 at t+1: status2_tmp = status2_tmp_at_t;
	 at t+1: status3_tmp = status3_tmp_at_t;
	 at t+1: tmp_bool = wait_cnt_end_sig_at_t;
	 at t+1: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t+1: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 at t+1: master_done_notify = false;
	 at t+1: master_result_o_notify = false;
	 at t+1: updateQ_o_notify = false;
end property;