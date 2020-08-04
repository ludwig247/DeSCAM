/*
This is step 1 of the manual refinement.
(Do not use this, only kept to better understand the refinement process)

TODO:
  -  in the reset property, the prove part starts from t (not t+1 as the other properties)
  - wait operations: are always of length 1: no need for t_end. just use t+1 for everything

master_result_o is not used: removed it fully (should also be removed from ESL)

gnt is wrong in ESL. It is now an internal variable which is never set, should be a tmp for gnt_i


shareds --> 1-cycle-output
  updateQ_o
  master_done

added: updateQ_o_notify, master_done_notify

updateQ_o_notify set to true at t_end for all properties where updateQ_cycle_tmp=true, otherwise false
master_done_notify, set to true at t_end when when master_done*sig is set to explicit value, false otherwise

updateQ_o_sig   only verified when updateQ_o_notify==true (was already like this, but should not have been, see comments in requestQ)
master_done_data_sig and master_done_err_sig   only verified when master_done_notify==true

*/


-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro ready_i_notify :  boolean  := end macro;
macro ready_i_sync   :  boolean  := end macro;
macro updateQ_o_notify : boolean  := end macro;
macro master_done_notify : boolean  := end macro;


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
macro BTR_CONT_1 : boolean := section=BTR_CONT end macro;
macro DATA_2 : boolean := section=DATA end macro;
macro DATA_ADDR_3 : boolean := section=DATA_ADDR end macro;
macro IDLE_4 : boolean := section=IDLE end macro;
macro WAIT_BEFORE_RETRY_5 : boolean := section=WAIT_BEFORE_RETRY end macro;


--Operations --


property reset is
for timepoints:
	t_end = t+1;
assume:
	 reset_sequence;
prove:
	 at t_end: IDLE_4;
	 at t_end: ack_tmp = ERR;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

	 during[t+1, t_end]: updateQ_o_notify = false;
	 during[t+1, t_end]: master_done_notify = false;
end property;

property wait_ADDR_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
   	 during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: ADDR_0;
	 at t: gnt;
	 at t: (((buffer1_opc_sig = BTR2_OPC) or (buffer1_opc_sig = BTR4_OPC)) or (buffer1_opc_sig = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_1;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_BTR_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

	 during[t+1, t_end-1]: updateQ_o_notify = false;
	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
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
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
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
	 at t_end: DATA_ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property ADDR_0_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property wait_BTR_CONT_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: BTR_CONT_1;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: BTR_CONT_1;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property BTR_CONT_1_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_1;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = nop_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_1;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = ((1 + buffer1_tmp_addr_at_t) + btrCnt_at_t);
	 at t_end: btrCnt = (1 + btrCnt_at_t);
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = false;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = 0;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	 at t_end: btrCnt = (1 + btrCnt_at_t);
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: BTR_CONT_1;
	 at t: (ack_i_sig = RTY);
	 at t: not(gnt);
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property BTR_CONT_1_read_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: BTR_CONT_1;
	 at t: (ack_i_sig = RTY);
	 at t: gnt;
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_2_read_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_2_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property wait_DATA_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: DATA_2;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: DATA_2;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_2_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_2_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
	nop_at_t = nop@t,
	result_tmp_data_at_t = result_tmp_data@t,
	result_tmp_err_at_t = result_tmp_err@t,
	status1_tmp_at_t = status1_tmp@t,
	status2_tmp_at_t = status2_tmp@t,
	status3_tmp_at_t = status3_tmp@t,
	tmp_bool_at_t = tmp_bool@t,
	updateQ_cycle_tmp_at_t = updateQ_cycle_tmp@t,
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_2_read_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_2_read_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = 0;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_2_read_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_2_read_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_ADDR_3_read_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt;
	 at t: (((buffer2_opc_sig = BTR2_OPC) or (buffer2_opc_sig = BTR4_OPC)) or (buffer2_opc_sig = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: BTR_CONT_1;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = (1 + buffer2_tmp_addr_at_t);
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = nop_at_t;
	 at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_BTR_Q;
	 at t_end: updateQ_o_sig = NXT_BTR_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer2_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = false;
	 at t_end: updateQ_msg_tmp = updateQ_msg_tmp_at_t;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: not((buffer2_opc_sig = BTR2_OPC));
	 at t: not((buffer2_opc_sig = BTR4_OPC));
	 at t: not((buffer2_opc_sig = BTR8_OPC));
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = false;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_2;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: result_tmp_data = data_i_sig_at_t;
	 at t_end: data_en_o_sig = true;
	 at t_end: data_o_sig = buffer2_sig_data_at_t;
	 at t_end: gnt = gnt_at_t;
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = true;
	 at t_end: opc_o_sig = NOP_OPC;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_PHASE_Q;
	 at t_end: updateQ_o_sig = NXT_PHASE_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property wait_DATA_ADDR_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: DATA_ADDR_3;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: DATA_ADDR_3;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_ADDR_3_read_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: not((buffer2_opc_sig = BTR2_OPC));
	 at t: not((buffer2_opc_sig = BTR4_OPC));
	 at t: not((buffer2_opc_sig = BTR8_OPC));
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer3_sig_addr_at_t;
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	result_tmp_data_at_t = result_tmp_data@t,
	data_en_o_sig_at_t = data_en_o_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_at_t = gnt@t,
	master_done_sig_data_at_t = master_done_data_sig@t,
	master_done_sig_err_at_t = master_done_err_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: DATA_ADDR_3;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	 at t_end: ack_tmp = ack_i_sig_at_t;
	 at t_end: addr_en_o_sig = true;
	 at t_end: addr_o_sig = buffer3_sig_addr_at_t;
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
	 at t_end: master_done_data_sig = result_tmp_data_at_t;
	 at t_end: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t_end: nop = false;
	 at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	 at t_end: result_tmp_data = result_tmp_data_at_t;
	 at t_end: result_tmp_err = not((ack_i_sig_at_t == OK));
	 at t_end: status1_tmp = status1_sig_at_t;
	 at t_end: status2_tmp = status2_sig_at_t;
	 at t_end: status3_tmp = status3_sig_at_t;
	 at t_end: tmp_bool = tmp_bool_at_t;
	 at t_end: updateQ_cycle_tmp = true;
	 at t_end: updateQ_msg_tmp = NXT_GRANT_Q;
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end-1]: master_done_notify = false;
     at t_end: master_done_notify = true;
end property;

property DATA_ADDR_3_read_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_ADDR_3_read_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t,
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_ADDR_3_read_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property DATA_ADDR_3_read_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = true;
	 at t_end: ack_tmp = ack_i_sig_at_t;
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
	 at t_end: updateQ_o_sig = RTY_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: gnt;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_o_sig_at_t = updateQ_o_sig@t;
assume:
	 at t: IDLE_4;
	 at t: nop;
	 at t: gnt;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: ADDR_0;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 at t_end: updateQ_o_sig = NXT_GRANT_Q;
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end-1]: updateQ_o_notify = false;
   	 at t_end: updateQ_o_notify = true;
     during[t+1, t_end]: master_done_notify = false;
end property;

property wait_IDLE_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: IDLE_4;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: IDLE_4;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: IDLE_4;
	 at t: nop;
	 at t: not(gnt);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: gnt;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property IDLE_4_read_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: IDLE_4;
	 at t: nop;
	 at t: gnt;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: not(gnt);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: gnt;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_42 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: gnt;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t_end: IDLE_4;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property wait_WAIT_BEFORE_RETRY_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: (ready_i_sync = false);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: not(gnt);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
	abort_o_sig_at_t = abort_o_sig@t,
	ack_tmp_at_t = ack_tmp@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: not(gnt);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_en_o_sig_at_t = abort_en_o_sig@t,
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
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: gnt;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	updateQ_msg_tmp_at_t = updateQ_msg_tmp@t;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: gnt;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t_end: WAIT_BEFORE_RETRY_5;
	 at t_end: abort_en_o_sig = true;
	 at t_end: abort_o_sig = false;
	 at t_end: ack_tmp = ack_tmp_at_t;
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
	 during[t+1, t_end-1]: ready_i_notify = false;
	 at t_end: ready_i_notify = true;

 	 during[t+1, t_end]: updateQ_o_notify = false;
     during[t+1, t_end]: master_done_notify = false;
end property;
