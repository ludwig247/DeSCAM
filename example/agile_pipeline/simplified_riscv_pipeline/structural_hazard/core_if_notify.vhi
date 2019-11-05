-- DP SIGNALS --
macro COtoME_port_sig_addrIn : unsigned := COtoME_data_if.addrIn end macro;
macro COtoME_port_sig_dataIn : unsigned := COtoME_data_if.dataIn end macro;
macro COtoME_port_sig_mask : ME_MaskType := COtoME_data_if.mask end macro;
macro COtoME_port_sig_req : ME_AccessType := COtoME_data_if.req end macro;
macro MEtoCO_port_sig_loadedData : unsigned := MEtoCO_data_if.loadedData end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro COtoME_data_addrIn : unsigned := COtoME_data_if.addrIn end macro;
macro COtoME_data_dataIn : unsigned := COtoME_data_if.dataIn end macro;
macro COtoME_data_mask : ME_MaskType := COtoME_data_if.mask end macro;
macro COtoME_data_req : ME_AccessType := COtoME_data_if.req end macro;
macro MEtoCO_data_loadedData : unsigned := MEtoCO_data_if_reg.loadedData end macro;


-- OPERATIONS --
property reset_to_write is
assume:
	 reset_sequence;
prove:
	 at t: if_current_state = if_write;
	 at t: COtoME_notify_if = true;
	 at t: MEtoCO_notify_if = false;
end property;

property write_to_write is
dependencies: no_reset;
assume:
	at t: if_current_state = if_write;
	at t: not(COtoME_port_sync);
prove:
	at t+1: if_current_state = if_write;
	at t+1: COtoME_notify_if = true;
	at t+1: MEtoCO_notify_if = false;
end property;

property write_to_read is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_write;
	at t: COtoME_port_sync;
prove:
	at t_end: if_current_state = if_read;
	during[t+1, t_end]: COtoME_notify_if = false;
	during[t+1, t_end-1]: MEtoCO_notify_if = false;
	at t_end: MEtoCO_notify_if = true;
end property;

property read_to_read is
dependencies: no_reset;
assume:
	at t: if_current_state = if_read;
	at t: not(MEtoCO_port_sync);
prove:
	at t+1: if_current_state = if_read;
	at t+1: COtoME_notify_if = false;
	at t+1: MEtoCO_notify_if = true;
end property;

property read_to_stall is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_read;
	at t: MEtoCO_port_sync;
	at t: not(de_stage_in_ready);
prove:
	at t_end: if_current_state = if_stall;
	during[t+1, t_end]: COtoME_notify_if = false;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;

property read_to_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_read;
	at t: MEtoCO_port_sync;
	at t: de_stage_in_ready;
	at t: not(memory_used_by_me);
prove:
	at t_end: if_current_state = if_write;
	during[t+1, t_end-1]: COtoME_notify_if = false;
	at t_end: COtoME_notify_if = true;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;

property read_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_read;
	at t: MEtoCO_port_sync;
	at t: de_stage_in_ready;
	at t: memory_used_by_me;
prove:
	at t_end: if_current_state = if_wait;
	during[t+1, t_end]: COtoME_notify_if = false;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;

property stall_to_stall is
dependencies: no_reset;
assume:
	at t: if_current_state = if_stall;
	at t: not(de_stage_in_ready);
prove:
	at t+1: if_current_state = if_stall;
	at t+1: COtoME_notify_if = false;
	at t+1: MEtoCO_notify_if = false;
end property;

property stall_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_stall;
	at t: de_stage_in_ready;
	at t: memory_used_by_me;
prove:
	at t_end: if_current_state = if_wait;
	during[t+1, t_end]: COtoME_notify_if = false;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;

property stall_to_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_stall;
	at t: de_stage_in_ready;
	at t: not(memory_used_by_me);
prove:
	at t_end: if_current_state = if_write;
	during[t+1, t_end-1]: COtoME_notify_if = false;
	at t_end: COtoME_notify_if = true;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;

property wait_to_wait is
dependencies: no_reset;
assume:
	at t: if_current_state = if_wait;
	at t: memory_used_by_me;
prove:
	at t+1: if_current_state = if_wait;
	at t+1: COtoME_notify_if = false;
	at t+1: MEtoCO_notify_if = false;
end property;

property wait_to_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: if_current_state = if_wait;
	at t: not(memory_used_by_me);
prove:
	at t_end: if_current_state = if_write;
	during[t+1, t_end-1]: COtoME_notify_if = false;
	at t_end: COtoME_notify_if = true;
	during[t+1, t_end]: MEtoCO_notify_if = false;
end property;
