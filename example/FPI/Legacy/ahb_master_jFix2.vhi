/*
This is the final result of the manual refinement.

from jFix1:
this is a slave on port ready, i.e., ready_i_notify can be removed. All properties must be 1 cycle long.
(notice that this will then ensure that the previous ready_notify would always be true, since it is set to true at t_end of all properties in jFix1)

removed all *_tmp variables (after checking that they are really no used
(this also means all the buffers ..we simply read *sig when needed)

fixed gnt

ISSUE:
(fixed manually in this file, use jFix1 to see the issue)

(1)
BTR_CONT_1_read_7
has two assignments for result_tmp_data! (one correctly updates to new value, the other keeps the old value)
same issue in BTR_CONT_1_read_8 (and many more)
DONE

(2)
for some reason:
at t+1: addr_o_sig = (1 + buffer1_tmp_addr_at_t);
instead of
at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t);

in property: ADDR_0_read_0, BTR_CONT_1_read_8
and DATA_ADDR_3_read_22 (here for buffer2)
DONE
(3)
master_done_data_sig (but not master_done_err_sig)
is set based on result_tmp in the properties altough result_tmp is read directly before from shared_in data_i
is:
at t+1: master_done_data_sig = result_tmp_data_at_t;
should be:
at t+1: master_done_data_sig = data_i_sig_at_t;
DONE

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
macro ready_i_sync   :  boolean  := end macro;
macro updateQ_o_notify : boolean  := end macro; -- for one cycle
macro master_done_notify : boolean  := end macro; -- for one cycle


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
macro btrCnt : int := end macro;
macro nop : bool := end macro;


-- STATES --
macro ADDR_0 : boolean := section=ADDR end macro;
macro BTR_CONT_1 : boolean := section=BTR_CONT end macro;
macro DATA_2 : boolean := section=DATA end macro;
macro DATA_ADDR_3 : boolean := section=DATA_ADDR end macro;
macro IDLE_4 : boolean := section=IDLE end macro;
macro WAIT_BEFORE_RETRY_5 : boolean := section=WAIT_BEFORE_RETRY end macro;


--Operations --


property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_4;
	 at t: btrCnt = 0;
	 at t: nop = false;
	 at t: updateQ_o_notify = false;
	 at t: master_done_notify = false;
end property;

property wait_ADDR_0 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: ADDR_0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
   	 at t+1: master_done_notify = false;
end property;

property ADDR_0_read_0 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: gnt_i_sig;
	 at t: (((buffer1_opc_sig = BTR2_OPC) or (buffer1_opc_sig = BTR4_OPC)) or (buffer1_opc_sig = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_1;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
     at t+1: addr_o_sig = (1 + buffer1_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;

	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_1 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_2 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_3 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_opc_sig = BTR2_OPC));
	 at t: not((buffer1_opc_sig = BTR4_OPC));
	 at t: not((buffer1_opc_sig = BTR8_OPC));
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_4 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_5 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: not((buffer1_opc_sig = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer1_opc_sig = BTR2_OPC));
	 at t: not((buffer1_opc_sig = BTR4_OPC));
	 at t: not((buffer1_opc_sig = BTR8_OPC));
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property ADDR_0_read_6 is
dependencies: no_reset;
assume:
	 at t: ADDR_0;
	 at t: (buffer1_opc_sig = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer1_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer1_sig_data_at_t;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property wait_BTR_CONT_1 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: BTR_CONT_1;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property BTR_CONT_1_read_7 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_1;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: data_en_o_sig = false;
     at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_8 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: not(((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)));
	 at t: not(((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2)));
	 at t: not(((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_1;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = ((1 + buffer1_sig_addr_at_t) + btrCnt_at_t);
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_9 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_10 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_11 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: not(((btrCnt = 0) and (ack_i_sig = RTY)));
	 at t: ((((buffer1_opc_sig = BTR2_OPC) and (btrCnt = 0)) or ((buffer1_opc_sig = BTR4_OPC) and (btrCnt = 2))) or ((buffer1_opc_sig = BTR8_OPC) and (btrCnt = 6)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = (1 + btrCnt_at_t);
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_12 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: (ack_i_sig = RTY);
	 at t: not(gnt_i_sig);
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property BTR_CONT_1_read_13 is
dependencies: no_reset;
assume:
	 at t: BTR_CONT_1;
	 at t: (ack_i_sig = RTY);
	 at t: gnt_i_sig;
	 at t: (btrCnt = 0);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_2_read_14 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_2_read_15 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (status2_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer2_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property wait_DATA_2 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_2;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property DATA_2_read_16 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_2_read_17 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_2_read_18 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_2_read_19 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: not((status2_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_2_read_20 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: not(nop);
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = gnt_at_t;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_2_read_21 is
dependencies: no_reset;
assume:
	 at t: DATA_2;
	 at t: nop;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = gnt_at_t;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_ADDR_3_read_22 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: gnt_i_sig;
	 at t: (((buffer2_opc_sig = BTR2_OPC) or (buffer2_opc_sig = BTR4_OPC)) or (buffer2_opc_sig = BTR8_OPC));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: BTR_CONT_1;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = (1 + buffer2_sig_addr_at_t);
	 at t+1: btrCnt = 0;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = nop_at_t;
	 at t+1: opc_o_sig = buffer2_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_BTR_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_23 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_24 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_25 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_opc_sig = BTR2_OPC));
	 at t: not((buffer2_opc_sig = BTR4_OPC));
	 at t: not((buffer2_opc_sig = BTR8_OPC));
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_26 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: not((status3_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_2;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = NXT_PHASE_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property wait_DATA_ADDR_3 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property DATA_ADDR_3_read_27 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: not((buffer2_opc_sig = BTR2_OPC));
	 at t: not((buffer2_opc_sig = BTR4_OPC));
	 at t: not((buffer2_opc_sig = BTR8_OPC));
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_28 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: not(((ack_i_sig = RTY) and (buffer1_opc_sig = RMW_OPC)));
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (status3_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: DATA_ADDR_3;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = buffer2_sig_abort_at_t;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer3_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = buffer2_sig_data_at_t;
	 at t+1: master_done_data_sig = data_i_sig_at_t;
	 at t+1: master_done_err_sig = not((ack_i_sig_at_t == OK));
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer3_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = true;
end property;

property DATA_ADDR_3_read_29 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_ADDR_3_read_30 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = false;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_ADDR_3_read_31 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: not((buffer2_opc_sig = WRITE_OPC));
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property DATA_ADDR_3_read_32 is
dependencies: no_reset;
assume:
	 at t: DATA_ADDR_3;
	 at t: (ack_i_sig = RTY);
	 at t: (buffer1_opc_sig = RMW_OPC);
	 at t: (buffer2_opc_sig = WRITE_OPC);
	 at t: gnt_i_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = true;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;
	 at t+1: updateQ_o_sig = RTY_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_33 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_34 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: (status1_sig = REQ_STATUS);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: ADDR_0;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = buffer1_sig_addr_at_t;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = false;
	 at t+1: opc_o_sig = buffer1_sig_opc_at_t;
	 at t+1: updateQ_o_sig = NXT_GRANT_Q;

   	 at t+1: updateQ_o_notify = true;
     at t+1: master_done_notify = false;
end property;

property wait_IDLE_4 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: IDLE_4;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_35 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_36 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_37 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property IDLE_4_read_38 is
dependencies: no_reset;
assume:
	 at t: IDLE_4;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not((status1_sig = REQ_STATUS));
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_39 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_40 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_41 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_42 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: wait_cnt_end_sig;
	 at t: (ready_i_sync = true);
prove:
	 at t+1: IDLE_4;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property wait_WAIT_BEFORE_RETRY_5 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: (ready_i_sync = false);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: nop = nop_at_t;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_43 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_44 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: not(gnt_i_sig);
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = false;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = false;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_45 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: not(nop);
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = false;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;

property WAIT_BEFORE_RETRY_5_read_46 is
dependencies: no_reset;
assume:
	 at t: WAIT_BEFORE_RETRY_5;
	 at t: nop;
	 at t: gnt_i_sig;
	 at t: not(wait_cnt_end_sig);
	 at t: (ready_i_sync = true);
prove:
	 at t+1: WAIT_BEFORE_RETRY_5;
	 at t+1: abort_en_o_sig = true;
	 at t+1: abort_o_sig = false;
	 at t+1: addr_en_o_sig = true;
	 at t+1: addr_o_sig = 0;
	 at t+1: btrCnt = btrCnt_at_t;
	 at t+1: data_en_o_sig = true;
	 at t+1: data_o_sig = 0;
	 at t+1: nop = true;
	 at t+1: opc_o_sig = NOP_OPC;

 	 at t+1: updateQ_o_notify = false;
     at t+1: master_done_notify = false;
end property;
