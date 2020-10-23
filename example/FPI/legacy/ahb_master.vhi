-I- 103 operations created
-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro master_done_notify :  boolean  := end macro;
macro master_done_sync   :  boolean  := end macro;
macro master_result_o_notify :  boolean  := end macro;
macro master_result_o_sync   :  boolean  := end macro;
macro ready_i_notify :  boolean  := end macro;
macro ready_i_sync   :  boolean  := end macro;
macro updateQ_o_notify :  boolean  := end macro;
macro updateQ_o_sync   :  boolean  := end macro;


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
macro opc_o_sig : opc_t := end macro;
macro status1_sig : req_status_t := end macro;
macro status2_sig : req_status_t := end macro;
macro status3_sig : req_status_t := end macro;
macro updateQ_o_sig : update_t := end macro;
macro wait_cnt_end_sig : bool := end macro;


--CONSTRAINTS--
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro ack : ack_t := end macro;
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
macro ADDR_1 : boolean := section=ADDR end macro;
macro ADDR_2 : boolean := section=ADDR end macro;
macro ADDR_3 : boolean := section=ADDR end macro;
macro BTR_CONT_4 : boolean := section=BTR_CONT end macro;
macro BTR_CONT_5 : boolean := section=BTR_CONT end macro;
macro BTR_CONT_6 : boolean := section=BTR_CONT end macro;
macro BTR_CONT_7 : boolean := section=BTR_CONT end macro;
macro BTR_CONT_8 : boolean := section=BTR_CONT end macro;
macro BTR_CONT_9 : boolean := section=BTR_CONT end macro;
macro DATA_10 : boolean := section=DATA end macro;
macro DATA_11 : boolean := section=DATA end macro;
macro DATA_12 : boolean := section=DATA end macro;
macro DATA_13 : boolean := section=DATA end macro;
macro DATA_14 : boolean := section=DATA end macro;
macro DATA_ADDR_15 : boolean := section=DATA_ADDR end macro;
macro DATA_ADDR_16 : boolean := section=DATA_ADDR end macro;
macro DATA_ADDR_17 : boolean := section=DATA_ADDR end macro;
macro DATA_ADDR_18 : boolean := section=DATA_ADDR end macro;
macro DATA_ADDR_19 : boolean := section=DATA_ADDR end macro;
macro DATA_ADDR_20 : boolean := section=DATA_ADDR end macro;
macro IDLE_21 : boolean := section=IDLE end macro;
macro IDLE_22 : boolean := section=IDLE end macro;
macro IDLE_23 : boolean := section=IDLE end macro;
macro WAIT_BEFORE_RETRY_24 : boolean := section=WAIT_BEFORE_RETRY end macro;


--Operations --


property reset is
for timepoints:
	t_end = t+1;
assume:
	 reset_sequence;
prove:
	 at t_end: IDLE_21;
	 at t_end: ack = ERR;
	 at t_end: btrCnt = 0;
	 at t_end: buffer1_tmp_abort = false;
	 at t_end: buffer1_tmp_addr = 0;
	 at t_end: buffer1_tmp_data = 0;
	 at t_end: buffer1_tmp_opc = BTR2_OPC;
	 at t_end: buffer2_tmp_abort = false;
	 at t_end: buffer2_tmp_addr = 0;
	 at t_end: buffer2_tmp_data = 0;
	 at t_end: buffer2_tmp_opc = BTR2_OPC;
	 at t_end: buffer3_tmp_abort = false;
	 at t_end: buffer3_tmp_addr = 0;
	 at t_end: buffer3_tmp_data = 0;
	 at t_end: buffer3_tmp_opc = BTR2_OPC;
	 at t_end: gnt = false;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = 0;
	 at t_end: result_tmp_err = false;
	 at t_end: status1_tmp = ADDR_STATUS;
	 at t_end: status2_tmp = ADDR_STATUS;
	 at t_end: status3_tmp = ADDR_STATUS;
	 at t_end: tmp_bool = false;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = NXT_BTR_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_ADDR_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: ADDR_0;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property ADDR_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: gnt;
	 at t: (((buffer1_opc_sig = BTR2_OPC) or (buffer1_opc_sig = BTR4_OPC)) or (buffer1_opc_sig = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_1;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = (1 + buffer1_tmp_addr_at_t);
	 at t_end: btrCnt = 0;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_BTR_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: not((buffer1_opc_sig = BTR2_OPC));
	 at t: not((buffer1_opc_sig = BTR4_OPC));
	 at t: not((buffer1_opc_sig = BTR8_OPC));
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer1_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer1_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: not((buffer1_opc_sig = BTR2_OPC));
	 at t: not((buffer1_opc_sig = BTR4_OPC));
	 at t: not((buffer1_opc_sig = BTR8_OPC));
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_0_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer1_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property wait_ADDR_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_1;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: ADDR_1;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_1_write_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_1;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_ADDR_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_2;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: ADDR_2;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_2_write_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_2;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_ADDR_15;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_ADDR_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_3;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: ADDR_3;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property ADDR_3_write_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: ADDR_3;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_BTR_CONT_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_4;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_4_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_4;
	 at t: (ack = RTY);
	 at t: not(gnt);
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_4_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_4;
	 at t: (ack = RTY);
	 at t: gnt;
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_4_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_4;
	 at t: not(((btrCnt = 0) and (ack = RTY)));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_6;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: master_done_notify = true;
	 at t_end: master_done_data_sig = result_tmp_data;
	 at t_end: master_done_err_sig = result_tmp_err;
end property;

property wait_BTR_CONT_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_5;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: BTR_CONT_5;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_5_write_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_5;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_6_write_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_6_write_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_6_write_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_6_write_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_6_write_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: (status2_tmp = REQ_STATUS);
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_7;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_tmp_addr_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: (status2_tmp = REQ_STATUS);
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_7;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_tmp_addr_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_8;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_8;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: not((status2_tmp = REQ_STATUS));
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_8;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: ((((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: not((status2_tmp = REQ_STATUS));
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_8;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_9;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_9;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = true);
prove:
	 at t_end: BTR_CONT_9;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_6_write_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_6;
	 at t: not(((buffer1_tmp_opc = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_tmp_opc = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_tmp_opc = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = false);
prove:
	 at t_end: BTR_CONT_9;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t_end: btrCnt = (1 + btrCnt_at_t);
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property wait_BTR_CONT_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_7;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: BTR_CONT_7;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_7_write_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_7;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_ADDR_15;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_BTR_CONT_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_8;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: BTR_CONT_8;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property BTR_CONT_8_write_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_8;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property BTR_CONT_9_write_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_9;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_BTR_CONT_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: BTR_CONT_9;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: BTR_CONT_9;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property wait_DATA_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_10;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_10_read_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_11;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = gnt_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_10_read_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_11;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = gnt_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_10_read_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_10;
	 at t: not(nop);
	 at t: not(((ack = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_12;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: master_done_notify = true;
	 at t_end: master_done_data_sig = result_tmp_data;
	 at t_end: master_done_err_sig = result_tmp_err;
end property;

property DATA_10_read_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_10;
	 at t: nop;
	 at t: not(((ack = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_12;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: master_done_notify = true;
	 at t_end: master_done_data_sig = result_tmp_data;
	 at t_end: master_done_err_sig = result_tmp_err;
end property;

property wait_DATA_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_11;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_11;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_11_write_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_11;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_12_write_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: gnt;
	 at t: (status2_tmp = REQ_STATUS);
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_13;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_tmp_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_12_write_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: gnt;
	 at t: (status2_tmp = REQ_STATUS);
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_13;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_tmp_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_12_write_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: not(gnt);
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_14;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_12_write_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: not(gnt);
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_14;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_12_write_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: gnt;
	 at t: not((status2_tmp = REQ_STATUS));
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_14;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_12_write_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_12;
	 at t: gnt;
	 at t: not((status2_tmp = REQ_STATUS));
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_14;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_13_write_42 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_13;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_DATA_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_13;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_13;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property wait_DATA_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_14;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_14;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_14_write_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_14;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_DATA_ADDR_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: DATA_ADDR_15;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_ADDR_15_read_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_16;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_15_read_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_16;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_15_read_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_16;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_15_read_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: (ack = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_16;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = RTY_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_15_read_48 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_17;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: master_done_notify = true;
	 at t_end: master_done_data_sig = result_tmp_data;
	 at t_end: master_done_err_sig = result_tmp_err;
end property;

property DATA_ADDR_15_read_49 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_15;
	 at t: not(((ack = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_17;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer2_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: master_done_notify = true;
	 at t_end: master_done_data_sig = result_tmp_data;
	 at t_end: master_done_err_sig = result_tmp_err;
end property;

property wait_DATA_ADDR_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_16;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_ADDR_16;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_16_write_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_16;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_ADDR_17_write_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: not(gnt);
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_ADDR_17_write_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: not(gnt);
	 at t: not(updateQ_cycle_tmp);
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property DATA_ADDR_17_write_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: (((buffer2_tmp_opc = BTR2_OPC) or (buffer2_tmp_opc = BTR4_OPC)) or (buffer2_tmp_opc = BTR8_OPC));
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_ADDR_18;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = (1 + buffer2_tmp_addr_at_t);
	 at t_end: btrCnt = 0;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_BTR_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: (((buffer2_tmp_opc = BTR2_OPC) or (buffer2_tmp_opc = BTR4_OPC)) or (buffer2_tmp_opc = BTR8_OPC));
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_ADDR_18;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = (1 + buffer2_tmp_addr_at_t);
	 at t_end: btrCnt = 0;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer2_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_BTR_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_55 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: not((buffer2_tmp_opc = BTR2_OPC));
	 at t: not((buffer2_tmp_opc = BTR4_OPC));
	 at t: not((buffer2_tmp_opc = BTR8_OPC));
	 at t: (status3_tmp = REQ_STATUS);
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_ADDR_19;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer3_tmp_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer3_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_56 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: not((buffer2_tmp_opc = BTR2_OPC));
	 at t: not((buffer2_tmp_opc = BTR4_OPC));
	 at t: not((buffer2_tmp_opc = BTR8_OPC));
	 at t: (status3_tmp = REQ_STATUS);
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_ADDR_19;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer3_tmp_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer3_tmp_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_57 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: not(gnt);
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_ADDR_20;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_58 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: not(gnt);
	 at t: updateQ_cycle_tmp;
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_ADDR_20;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_59 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: not((buffer2_tmp_opc = BTR2_OPC));
	 at t: not((buffer2_tmp_opc = BTR4_OPC));
	 at t: not((buffer2_tmp_opc = BTR8_OPC));
	 at t: not((status3_tmp = REQ_STATUS));
	 at t: (master_done_sync = true);
prove:
	 at t_end: DATA_ADDR_20;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_17_write_60 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_17;
	 at t: gnt;
	 at t: not((buffer2_tmp_opc = BTR2_OPC));
	 at t: not((buffer2_tmp_opc = BTR4_OPC));
	 at t: not((buffer2_tmp_opc = BTR8_OPC));
	 at t: not((status3_tmp = REQ_STATUS));
	 at t: (master_done_sync = false);
prove:
	 at t_end: DATA_ADDR_20;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_18_write_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_18;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: BTR_CONT_4;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_DATA_ADDR_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_18;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_ADDR_18;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_19_write_62 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_19;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_ADDR_15;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_DATA_ADDR_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_19;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_ADDR_19;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property DATA_ADDR_20_write_63 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_20;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: DATA_10;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_DATA_ADDR_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: DATA_ADDR_20;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: DATA_ADDR_20;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property wait_IDLE_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: IDLE_21;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property IDLE_21_read_64 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property IDLE_21_read_65 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property IDLE_21_read_66 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property IDLE_21_read_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property IDLE_21_read_68 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: not(nop);
	 at t: gnt;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_22;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property IDLE_21_read_69 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_21;
	 at t: nop;
	 at t: gnt;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_22;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_sig_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_sig_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_sig_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_sig_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_sig_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_sig_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_sig_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_sig_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_sig_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_sig_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_sig_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_sig_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property IDLE_22_write_70 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_22;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_IDLE_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_22;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: IDLE_22;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property IDLE_23_write_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_23;
	 at t: (updateQ_o_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_IDLE_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_23;
	 at t: (updateQ_o_sync = false);
prove:
	 at t_end: IDLE_23;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end]: ready_i_notify = false;
	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
	 at t_end: updateQ_o_sig = updateQ_msg_tmp;
end property;

property WAIT_BEFORE_RETRY_24_read_72 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_73 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_74 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_21;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property wait_WAIT_BEFORE_RETRY_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_at_t = ack@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: ack = ack_at_t;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_76 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	gnt_at_t = gnt@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_77 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: not(gnt);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_78 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: not(nop);
	 at t: gnt;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;

property WAIT_BEFORE_RETRY_24_read_79 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_at_t = ack@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_24;
	 at t: nop;
	 at t: gnt;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_24;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack = ack_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = btrCnt_at_t;
	 at t_end: buffer1_tmp_abort = buffer1_tmp_abort_at_t;
	 at t_end: buffer1_tmp_addr = buffer1_tmp_addr_at_t;
	 at t_end: buffer1_tmp_data = buffer1_tmp_data_at_t;
	 at t_end: buffer1_tmp_opc = buffer1_tmp_opc_at_t;
	 at t_end: buffer2_tmp_abort = buffer2_tmp_abort_at_t;
	 at t_end: buffer2_tmp_addr = buffer2_tmp_addr_at_t;
	 at t_end: buffer2_tmp_data = buffer2_tmp_data_at_t;
	 at t_end: buffer2_tmp_opc = buffer2_tmp_opc_at_t;
	 at t_end: buffer3_tmp_abort = buffer3_tmp_abort_at_t;
	 at t_end: buffer3_tmp_addr = buffer3_tmp_addr_at_t;
	 at t_end: buffer3_tmp_data = buffer3_tmp_data_at_t;
	 at t_end: buffer3_tmp_opc = buffer3_tmp_opc_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = result_tmp_err_at_t;
	 at t_end: status1_tmp = status1_tmp_at_t;
	 at t_end: status2_tmp = status2_tmp_at_t;
	 at t_end: status3_tmp = status3_tmp_at_t;
	 at t_end: tmp_bool = wait_cnt_end_sig_at_t;
	 at t_end: updateQ_cycle_tmp = updateQ_cycle_tmp_at_t;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end]: master_done_notify = false;
	 during[t+1, t_end]: master_result_o_notify = false;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 during[t+1, t_end]: updateQ_o_notify = false;
	 at t_end: ready_i_notify = true;
end property;