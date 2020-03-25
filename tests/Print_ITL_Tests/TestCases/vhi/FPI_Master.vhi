-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro ready_i_sync : boolean := end macro;
macro master_done_notify : boolean := end macro;
macro master_result_o_notify : boolean := end macro;
macro updateQ_o_notify : boolean := end macro;


-- DP SIGNALS --
macro abort_en_o_sig : boolean := end macro;
macro abort_o_sig : boolean := end macro;
macro ack_i_sig : ack_t := end macro;
macro addr_en_o_sig : boolean := end macro;
macro addr_o_sig : signed := end macro;
macro buffer1_sig : req_t := end macro;
macro buffer1_sig_abort : boolean := end macro;
macro buffer1_sig_addr : signed := end macro;
macro buffer1_sig_data : signed := end macro;
macro buffer1_sig_opc : opc_t := end macro;
macro buffer2_sig : req_t := end macro;
macro buffer2_sig_abort : boolean := end macro;
macro buffer2_sig_addr : signed := end macro;
macro buffer2_sig_data : signed := end macro;
macro buffer2_sig_opc : opc_t := end macro;
macro buffer3_sig : req_t := end macro;
macro buffer3_sig_abort : boolean := end macro;
macro buffer3_sig_addr : signed := end macro;
macro buffer3_sig_data : signed := end macro;
macro buffer3_sig_opc : opc_t := end macro;
macro data_en_o_sig : boolean := end macro;
macro data_i_sig : signed := end macro;
macro data_o_sig : signed := end macro;
macro gnt_i_sig : boolean := end macro;
macro master_done_sig : result_t := end macro;
macro master_done_sig_data : signed := end macro;
macro master_done_sig_err : boolean := end macro;
macro master_result_o_sig : boolean := end macro;
macro opc_o_sig : opc_t := end macro;
macro ready_i_sig : boolean := end macro;
macro status1_sig : req_status_t := end macro;
macro status2_sig : req_status_t := end macro;
macro status3_sig : req_status_t := end macro;
macro updateQ_o_sig : update_t := end macro;
macro wait_cnt_end_sig : boolean := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro btrCnt : signed := end macro;
macro nextphase : Phases := end macro;
macro nop : boolean := end macro;


-- STATES --
macro state_1 : boolean := true end macro;
macro state_2 : boolean := true end macro;
macro state_3 : boolean := true end macro;
macro state_4 : boolean := true end macro;
macro state_5 : boolean := true end macro;
macro state_6 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: state_1;
	 at t: abort_en_o_sig = false;
	 at t: abort_o_sig = false;
	 at t: addr_en_o_sig = false;
	 at t: addr_o_sig = resize(0,32);
	 at t: btrCnt = resize(0,32);
	 at t: data_en_o_sig = false;
	 at t: data_o_sig = resize(0,32);
	 at t: nextphase = IDLE;
	 at t: nop = false;
	 at t: opc_o_sig = NOP_OPC;
	 at t: master_done_notify = false;
	 at t: master_result_o_notify = false;
	 at t: updateQ_o_notify = false;
end property;


property state_1_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_1_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_1_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_1_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_1_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_1;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: (status1_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer1_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_1_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_1;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not((status1_sig = REQ_STATUS));
	at t: (nextphase = IDLE);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_2_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_data_at_t = buffer1_sig_data@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: (buffer1_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer1_sig_data_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: gnt_i_sig;
	at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = (1 + buffer1_sig_addr_at_t)(31 downto 0);
	at t_end: btrCnt = 0;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = BTR_CONT;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_20 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer1_sig_addr_at_t = buffer1_sig_addr@t,
	buffer1_sig_opc_at_t = buffer1_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: gnt_i_sig;
	at t: (((buffer1_sig_opc = BTR2_OPC) or (buffer1_sig_opc = BTR4_OPC)) or (buffer1_sig_opc = BTR8_OPC));
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = (1 + buffer1_sig_addr_at_t)(31 downto 0);
	at t_end: btrCnt = 0;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = BTR_CONT;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_21 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_22 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_23 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_24 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer1_sig_opc = BTR2_OPC));
	at t: not((buffer1_sig_opc = BTR4_OPC));
	at t: not((buffer1_sig_opc = BTR8_OPC));
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_25 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_2;
	at t: ready_i_sync;
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_2_26 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer1_sig_abort_at_t = buffer1_sig_abort@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_2;
	at t: not(ready_i_sync);
	at t: not((buffer1_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer1_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_27 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: nop;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = gnt_i_sig_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: nop;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = gnt_i_sig_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_33 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_34 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_35 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: not(nop);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = gnt_i_sig_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_36 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_en_o_sig_at_t = addr_en_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	gnt_i_sig_at_t = gnt_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = gnt_i_sig_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_37 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_38 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_2;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_39 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_40 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_41 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_3_42 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_3;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_43 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_44 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_45 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_46 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_47 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_48 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_49 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_50 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: (buffer1_sig_opc = RMW_OPC);
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_51 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status3_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer3_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_52 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: (status3_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer3_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_53 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_54 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: gnt_i_sig;
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_55 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_4_56 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_data_at_t = buffer2_sig_data@t,
	data_i_sig_at_t = data_i_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: (buffer2_sig_opc = WRITE_OPC);
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = buffer2_sig_data_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_4_57 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = (1 + buffer2_sig_addr_at_t)(31 downto 0);
	at t_end: btrCnt = 0;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = BTR_CONT;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_58 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	nop_at_t = nop@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: gnt_i_sig;
	at t: (((buffer2_sig_opc = BTR2_OPC) or (buffer2_sig_opc = BTR4_OPC)) or (buffer2_sig_opc = BTR8_OPC));
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = (1 + buffer2_sig_addr_at_t)(31 downto 0);
	at t_end: btrCnt = 0;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = BTR_CONT;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_BTR_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_59 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: (status3_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer3_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_60 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	buffer3_sig_addr_at_t = buffer3_sig_addr@t,
	buffer3_sig_opc_at_t = buffer3_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: (status3_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer3_sig_addr_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer3_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_61 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_62 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: gnt_i_sig;
	at t: not((buffer2_sig_opc = BTR2_OPC));
	at t: not((buffer2_sig_opc = BTR4_OPC));
	at t: not((buffer2_sig_opc = BTR8_OPC));
	at t: not((status3_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_4_63 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: ready_i_sync;
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_4_64 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_abort_at_t = buffer2_sig_abort@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_4;
	at t: not(ready_i_sync);
	at t: not(((ack_i_sig = RTY) and (buffer1_sig_opc = RMW_OPC)));
	at t: not((buffer2_sig_opc = WRITE_OPC));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = buffer2_sig_abort_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_5_65 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: gnt_i_sig;
	at t: (btrCnt = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_66 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: gnt_i_sig;
	at t: (btrCnt = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_67 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_5;
	at t: ready_i_sync;
	at t: (ack_i_sig = RTY);
	at t: not(gnt_i_sig);
	at t: (btrCnt = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_68 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_5;
	at t: not(ready_i_sync);
	at t: (ack_i_sig = RTY);
	at t: not(gnt_i_sig);
	at t: (btrCnt = resize(0,32));
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = true;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = WAIT_BEFORE_RETRY;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = RTY_Q;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_69 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_70 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	buffer2_sig_addr_at_t = buffer2_sig_addr@t,
	buffer2_sig_opc_at_t = buffer2_sig_opc@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (status2_sig = REQ_STATUS);
prove:
	at t_end: state_4;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = buffer2_sig_addr_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA_ADDR;
	at t_end: nop = false;
	at t_end: opc_o_sig = buffer2_sig_opc_at_t;
	at t_end: updateQ_o_sig = NXT_GRANT_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_71 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_72 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_5;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: not((status2_sig = REQ_STATUS));
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_73 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_5;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_74 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	ack_i_sig_at_t = ack_i_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_i_sig_at_t = data_i_sig@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_5;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: ((((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))) or ((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32)))) or ((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
prove:
	at t_end: state_3;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = DATA;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t_end: updateQ_o_sig = NXT_PHASE_Q;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = true;
end property;


property state_5_75 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_5;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (nextphase = BTR_CONT);
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = ((2 + buffer1_sig_addr_at_t)(31 downto 0) + btrCnt_at_t)(31 downto 0);
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_5_76 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_5;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: gnt_i_sig;
	at t: (nextphase = BTR_CONT);
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = ((2 + buffer1_sig_addr_at_t)(31 downto 0) + btrCnt_at_t)(31 downto 0);
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = buffer1_sig_opc_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_5_77 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_5;
	at t: ready_i_sync;
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
	at t: (nextphase = BTR_CONT);
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_5_78 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
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
	at t: state_5;
	at t: not(ready_i_sync);
	at t: not(((btrCnt = resize(0,32)) and (ack_i_sig = RTY)));
	at t: not(((buffer1_sig_opc = BTR2_OPC) and (btrCnt = resize(0,32))));
	at t: not(((buffer1_sig_opc = BTR4_OPC) and (btrCnt = resize(2,32))));
	at t: not(((buffer1_sig_opc = BTR8_OPC) and (btrCnt = resize(6,32))));
	at t: not(gnt_i_sig);
	at t: (nextphase = BTR_CONT);
prove:
	at t_end: state_5;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = addr_en_o_sig_at_t;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = (1 + btrCnt_at_t)(31 downto 0);
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: master_done_sig_data = data_i_sig_at_t;
	at t_end: master_done_sig_err = not((ack_i_sig_at_t = OK));
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = nop_at_t;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = true;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_79 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_80 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_81 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: nop;
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_82 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: nop;
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_83 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_84 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_85 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: nop;
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_86 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: nop;
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = true;
	at t_end: abort_o_sig = false;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = true;
	at t_end: data_o_sig = 0;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_87 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_88 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = IDLE;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_89 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_90 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: gnt_i_sig;
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = true;
	at t_end: addr_o_sig = 0;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = true;
	at t_end: opc_o_sig = NOP_OPC;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_91 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_92 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: wait_cnt_end_sig;
prove:
	at t_end: state_1;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = IDLE;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_93 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: ready_i_sync;
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


property state_6_94 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	abort_o_sig_at_t = abort_o_sig@t,
	addr_o_sig_at_t = addr_o_sig@t,
	btrCnt_at_t = btrCnt@t,
	data_o_sig_at_t = data_o_sig@t,
	nextphase_at_t = nextphase@t,
	opc_o_sig_at_t = opc_o_sig@t;
assume:
	at t: state_6;
	at t: not(ready_i_sync);
	at t: not(nop);
	at t: not(gnt_i_sig);
	at t: not(wait_cnt_end_sig);
	at t: (nextphase = WAIT_BEFORE_RETRY);
prove:
	at t_end: state_6;
	at t_end: abort_en_o_sig = false;
	at t_end: abort_o_sig = abort_o_sig_at_t;
	at t_end: addr_en_o_sig = false;
	at t_end: addr_o_sig = addr_o_sig_at_t;
	at t_end: btrCnt = btrCnt_at_t;
	at t_end: data_en_o_sig = false;
	at t_end: data_o_sig = data_o_sig_at_t;
	at t_end: nextphase = nextphase_at_t;
	at t_end: nop = false;
	at t_end: opc_o_sig = opc_o_sig_at_t;
	at t+1: master_done_notify = false;
	at t+1: master_result_o_notify = false;
	at t+1: updateQ_o_notify = false;
end property;


