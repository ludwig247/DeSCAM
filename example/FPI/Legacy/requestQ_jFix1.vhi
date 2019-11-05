/*
+ In empty, the updateQ read doesnt actually do anything (so is removed fully)
+ fixed all of these : (some_object=true) and some_object --> rewritten "some_object"

TODO: this is a 1-cycle slave for peripheral_request and updateQ --> no notify needed
TODO from TOBI: This actually not true ... there are paths that result in no reading peripheral_request so it's not read in every cycle.

+ signals are missing in many operations
(shared variables must be verified at every timepoint, while datapath sigs of real ports are verified only when actually sent (notify is high)

+ wold be nice to have a feature for shared variables that would allow us not to double up on everything.
  Now, for outgoing, we require both the variable part for reading and the sig for writing
  The var should not really be required..

+ operation 15 to 27 ends in NON_EMPTY_3 (where peripheral is read).
  These are now merged with the NON_EMPTY_3_* operations (28 to 32)
  Merge created 13 operations x 5 operations -> 65 operations

    minus unrechable ops:
     property NON_EMPTY_2_read_16_30 is
     property NON_EMPTY_2_read_16_28 is
     property NON_EMPTY_2_read_19_28 is
     property NON_EMPTY_2_read_19_30 is
     property NON_EMPTY_2_read_21_31 is
     property NON_EMPTY_2_read_23_31 is
     property NON_EMPTY_2_read_24_28 is
     property NON_EMPTY_2_read_24_30 is
     property NON_EMPTY_2_read_24_31 is
     property NON_EMPTY_2_read_25_28 is
     property NON_EMPTY_2_read_25_30 is
     property NON_EMPTY_2_read_26_28 is
     property NON_EMPTY_2_read_26_31 is
     property NON_EMPTY_2_read_27_28 is
     property NON_EMPTY_2_read_27_30 is


---> must be verified for ALL timepoints
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
macro req_o_sig : bool := end macro;
macro status1_sig : req_status_t := end macro;
macro status2_sig : req_status_t := end macro;
macro status3_sig : req_status_t := end macro;


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
macro NON_EMPTY_2 : boolean := section=NON_EMPTY end macro;

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
	 at t: EMPTY_0;
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







--------



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



----------

property NON_EMPTY_2_read_15_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 ----
   	 at t: (status1_var = EMPTY_STATUS);
   	 at t: (peripheral_request_i_sync = false);
     -----
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
	 ----
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));

end property;

property NON_EMPTY_2_read_15_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
----
 	 at t: not((status1_var = EMPTY_STATUS));
   	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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
	 ---
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;

property NON_EMPTY_2_read_15_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status1_var = REQ_STATUS; ---change
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
	 ----
 	 at t_end: req_o_sig = (((REQ_STATUS == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;

property NON_EMPTY_2_read_15_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 -----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status2_var = REQ_STATUS; --change
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
	 ----
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;

property NON_EMPTY_2_read_15_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = false);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS; --change
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
	 ----
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;



-----

property NON_EMPTY_2_read_16_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
---
	 at t: not((status1_var = EMPTY_STATUS));
   	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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
	 ----
     at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (REQ_STATUS == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;


property NON_EMPTY_2_read_16_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
-----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status2_var = REQ_STATUS; --changed
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

property NON_EMPTY_2_read_16_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status1_var = REQ_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
 	 at t: peripheral_request_i_sync;
   	 at t: not((status1_var = EMPTY_STATUS));
   	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS; --changed
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
	 ---
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (REQ_STATUS == REQ_STATUS));
end property;


--------------
property NON_EMPTY_2_read_17_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
 	 at t: (status1_var = EMPTY_STATUS);
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
	 --
	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;

property NON_EMPTY_2_read_17_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 --
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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
	 --
 	 at t_end: req_o_sig = (((status1_var_at_t == REQ_STATUS) or (status2_var_at_t == REQ_STATUS)) or (status3_var_at_t == REQ_STATUS));
end property;

property NON_EMPTY_2_read_17_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 --
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_17_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_17_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: not((status1_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 --
 	 at t: peripheral_request_i_sync;
   	 at t: not((status1_var = EMPTY_STATUS));
   	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

-------

property NON_EMPTY_2_read_18_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: (status1_var = EMPTY_STATUS);
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

property NON_EMPTY_2_read_18_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_18_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_18_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_18_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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
-------------

property NON_EMPTY_2_read_19_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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


property NON_EMPTY_2_read_19_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_19_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 --
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

----------

property NON_EMPTY_2_read_20_28 is ---DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: (status1_var = EMPTY_STATUS);
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

property NON_EMPTY_2_read_20_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_20_30 is ---DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 -----
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_20_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_20_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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
-----

property NON_EMPTY_2_read_21_28 is ---DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: (status1_var = EMPTY_STATUS);
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

property NON_EMPTY_2_read_21_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_21_30 is --Difficult UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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



property NON_EMPTY_2_read_21_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: (status2_var = REQ_STATUS);
	 at t: not((status1_var = DATA_STAUS));
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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
------

property NON_EMPTY_2_read_22_28 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: (status1_var = EMPTY_STATUS);
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: EMPTY_0;
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

property NON_EMPTY_2_read_22_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_22_30 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
	 --
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status1_var = REQ_STATUS;
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

property NON_EMPTY_2_read_22_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status2_var = REQ_STATUS;
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

property NON_EMPTY_2_read_22_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: not((status1_var = REQ_STATUS));
	 at t: not((status2_var = REQ_STATUS));
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

-------

property NON_EMPTY_2_read_23_28 is --DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: (status1_var = EMPTY_STATUS);
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

property NON_EMPTY_2_read_23_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_23_30 is --DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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




property NON_EMPTY_2_read_23_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: not((updateQ_i_sig = NXT_GRANT_Q));
	 at t: not((updateQ_i_sig = NXT_PHASE_Q));
	 at t: not((updateQ_i_sig = NXT_BTR_Q));
	 at t: (status2_var = ADDR_STATUS);
	 at t: (status3_var = EMPTY_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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


-----


property NON_EMPTY_2_read_24_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = ADDR_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_24_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (status2_var = ADDR_STATUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

--------

property NON_EMPTY_2_read_25_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_25_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (updateQ_i_sync = true);
	 -----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status2_var = REQ_STATUS;
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

property NON_EMPTY_2_read_25_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_PHASE_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: not((status2_var = ADDR_STATUS));
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

------------



property NON_EMPTY_2_read_26_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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

property NON_EMPTY_2_read_26_30 is ---DIFFICULT UNREACHABLE
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: (status1_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status1_var = REQ_STATUS;
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

property NON_EMPTY_2_read_26_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_GRANT_Q);
	 at t: (status2_var = REQ_STATUS);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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

-----------

property NON_EMPTY_2_read_27_29 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (peripheral_request_i_sync = false);
prove:
	 at t_end: NON_EMPTY_2;
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


property NON_EMPTY_2_read_27_31 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ----
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: (status2_var = EMPTY_STATUS);
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status2_var = REQ_STATUS;
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

property NON_EMPTY_2_read_27_32 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	 at t: NON_EMPTY_2;
	 at t: updateQ_i_sync;
	 at t: (updateQ_i_sig = NXT_BTR_Q);
	 at t: (status1_var = DATA_STAUS);
	 at t: (updateQ_i_sync = true);
	 ---
	 at t: peripheral_request_i_sync;
	 at t: not((status1_var = EMPTY_STATUS));
	 at t: not((status2_var = EMPTY_STATUS));
prove:
	 at t_end: NON_EMPTY_2;
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
	 at t_end: status3_var = REQ_STATUS;
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


