-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro ready_i_sync : boolean := end macro;
--macro master_done_notify : boolean := end macro;
--macro master_result_o_notify : boolean := end macro;
--macro updateQ_o_notify : boolean := end macro;


-- DP SIGNALS --
 macro abort_en_o_sig : bool := abort_en_o end macro;
 macro abort_o_sig : bool := abort_o end macro;
 macro ack_i_sig : ack_t := ack_i end macro;
 macro addr_en_o_sig : bool := addr_en_o end macro;
 macro addr_o_sig : int := addr_o end macro;
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
 macro data_en_o_sig : bool := data_en_o end macro;
 macro data_i_sig : int := data_i end macro;
 macro data_o_sig : int := data_o end macro;
 macro gnt_i_sig : bool :=  gnt_i end macro;
 macro master_done_sig_data : int := master_done.data end macro;
 macro master_done_sig_err : bool := master_done.err end macro;
 --macro master_result_o_sig : bool := master_result_o end macro;
 macro opc_o_sig : opc_t :=  opc_o end macro;
 macro ready_i_sig : bool := ready_i end macro;
 macro status1_sig : req_status_t := status1 end macro;
 macro status2_sig : req_status_t := status2 end macro;
 macro status3_sig : req_status_t := status3 end macro;
 macro updateQ_o_sig : update_t := updateQ_o end macro;
 macro wait_cnt_end_sig : bool := wait_cnt_end end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro btrCnt : int :=  btrCnt_signal end macro;
macro nextphase : FPI_Master_SECTIONS := section end macro;
macro nop : bool := nop_signal end macro;


-- STATES --
macro state_126 : boolean := section = DATA end macro;
macro state_180 : boolean := section = DATA_ADDR end macro;
macro state_257 : boolean := section = BTR_CONT end macro;
macro state_324 : boolean := section = WAIT_BEFORE_RETRY end macro;
macro state_39 : boolean := section = IDLE end macro;
macro state_76 : boolean := section = ADDR end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_39;
	 at t: abort_en_o_sig = false;
	 at t: abort_o_sig = false;
	 at t: addr_en_o_sig = false;
	 at t: addr_o_sig = resize(0,32);
	 at t: btrCnt = resize(0,32);
	 at t: data_en_o_sig = false;
	 at t: data_o_sig = resize(0,32);
	 at t: nextphase = IDLE;
	 at t: nop = false;
	 at t: opc_o_sig = BTR2_OPC;
	 at t: master_done_notify = false;
	 at t: master_result_o_notify = false;
	 at t: updateQ_o_notify = false;
end property;


property state_126_27 is
dependencies: no_reset;
freeze:
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: nop;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = gnt_i_sig_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_28 is
dependencies: no_reset;
freeze:
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: nop;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = gnt_i_sig_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_29 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_30 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_31 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_32 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_33 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_34 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_35 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: not(nop);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = gnt_i_sig_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_36 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = gnt_i_sig_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_37 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_38 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_39 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_40 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_41 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_126_42 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_126;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_43 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_44 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_45 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_46 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_47 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_48 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_49 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_50 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_51 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status3_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_52 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status3_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_53 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_54 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_55 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_180_56 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer2_sig_data_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_180_57 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = (1 + buffer2_sig_addr_at_t)(31 downto 0);
	at t+1: btrCnt = 0;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = BTR_CONT;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_58 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = (1 + buffer2_sig_addr_at_t)(31 downto 0);
	at t+1: btrCnt = 0;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = BTR_CONT;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_59 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: (status3_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_60 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: (status3_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_61 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_62 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_180_63 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_180_64 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_180;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_257_65 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: gnt_i_sig;
	at t: (btrCnt = resize(0,32));
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_66 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: gnt_i_sig;
	at t: (btrCnt = resize(0,32));
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_67 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: not(gnt_i_sig);
	at t: (btrCnt = resize(0,32));
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_68 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: not(gnt_i_sig);
	at t: (btrCnt = resize(0,32));
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = true;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = WAIT_BEFORE_RETRY;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_69 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_70 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_71 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_72 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_73 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_74 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_257_75 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	nop_at_t = nop@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (nextphase = BTR_CONT);
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = ((2 + buffer1_sig_addr_at_t)(31 downto 0) + btrCnt_at_t)(31 downto 0);
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_257_76 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	nop_at_t = nop@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (nextphase = BTR_CONT);
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = ((2 + buffer1_sig_addr_at_t)(31 downto 0) + btrCnt_at_t)(31 downto 0);
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_257_77 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
	at t: (nextphase = BTR_CONT);
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_257_78 is
dependencies: no_reset;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	nop_at_t = nop@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_257;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
	at t: (nextphase = BTR_CONT);
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = addr_en_o_sig_at_t;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: master_done_sig_data = data_i_sig_at_t;
	at t+1: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_79 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_80 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_81 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_82 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_83 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_84 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_85 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_86 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_87 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_88 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = IDLE;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_89 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_90 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_91 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_92 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = IDLE;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_93 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_324_94 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_324;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t+1: state_324;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_1 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_39_2 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_39_3 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_4 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_5 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_6 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = false;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = 0;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_7 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_39_8 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t+1: state_76;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_39_9 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_10 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_11 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_39;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_39_12 is
dependencies: no_reset;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_39;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t+1: state_39;
	at t+1: abort_en_o_sig = false;
	at t+1: abort_o_sig = abort_o_sig_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = nextphase_at_t;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_76_13 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_14 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_15 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_16 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_17 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_18 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = true;
	at t+1: data_o_sig = buffer1_sig_data_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_19 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: gnt_i_sig;
	at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t)(31 downto 0);
	at t+1: btrCnt = 0;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = BTR_CONT;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_20 is
dependencies: no_reset;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: gnt_i_sig;
	at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
prove:
	at t+1: state_257;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t)(31 downto 0);
	at t+1: btrCnt = 0;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = BTR_CONT;
	at t+1: nop = nop_at_t;
	at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_21 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_22 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: (status2_sig = REQ_STATUS);
prove:
	at t+1: state_180;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA_ADDR;
	at t+1: nop = false;
	at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	at t+1: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_23 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_24 is
dependencies: no_reset;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = true;
	at t+1: addr_o_sig = 0;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = true;
	at t+1: opc_o_sig = NOP_OPC;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_25 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_76;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_76_26 is
dependencies: no_reset;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_76;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t+1: state_126;
	at t+1: abort_en_o_sig = true;
	at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	at t+1: addr_en_o_sig = false;
	at t+1: addr_o_sig = addr_o_sig_at_t;
	at t+1: btrCnt = btrCnt_at_t;
	at t+1: data_en_o_sig = false;
	at t+1: data_o_sig = data_o_sig_at_t;
	at t+1: nextphase = DATA;
	at t+1: nop = false;
	at t+1: opc_o_sig = opc_o_sig_at_t;
	at t+1: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


