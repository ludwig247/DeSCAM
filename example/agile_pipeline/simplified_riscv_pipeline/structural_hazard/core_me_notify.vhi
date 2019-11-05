-- DP SIGNALS --
macro COtoME_port_sig_addrIn : unsigned := COtoME_data_me.addrIn end macro;
macro COtoME_port_sig_dataIn : unsigned := COtoME_data_me.dataIn end macro;
macro COtoME_port_sig_mask : ME_MaskType := COtoME_data_me.mask end macro;
macro COtoME_port_sig_req : ME_AccessType := COtoME_data_me.req end macro;
macro MEtoCO_port_sig_loadedData : unsigned := MEtoCO_data_me.loadedData end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;

-- VISIBLE REGISTERS --
macro COtoME_data_addrIn : unsigned := COtoME_data_me.addrIn end macro;
macro COtoME_data_dataIn : unsigned := COtoME_data_me.dataIn end macro;
macro COtoME_data_mask : ME_MaskType := COtoME_data_me.mask end macro;
macro COtoME_data_req : ME_AccessType := COtoME_data_me.req end macro;
macro MEtoCO_data_loadedData : unsigned := MEtoCO_data_me_reg.loadedData end macro;


-- OPERATIONS --
property reset_to_idle is
assume:
	 reset_sequence;
prove:
	 at t: me_current_state = me_idle;
	 at t: COtoME_notify_me = false;
	 at t: MEtoCO_notify_me = false;
end property;

property idle_to_idle is
dependencies: no_reset;
assume:
	at t: me_current_state = me_idle;
	at t: not(ex_stage_out_ready);
prove:
	at t+1: me_current_state = me_idle;
	at t+1: COtoME_notify_me = false;
	at t+1: MEtoCO_notify_me = false;
end property;

property idle_to_bypass is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_idle;
	at t: ex_stage_out_ready;
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32));
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_bypass;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property idle_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_ex_at_t = MEtoCO_data_ex@t;
assume:
	at t: me_current_state = me_idle;
	at t: ex_stage_out_ready;
	at t: memory_used_by_if;
	at t: ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32)) or ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_wait;
	at t_end: MEtoCO_data_me = MEtoCO_data_ex_at_t;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property idle_to_load_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_idle;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32);
prove:
	at t_end: me_current_state = me_load_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property idle_to_store_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_idle;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t_end: me_current_state = me_store_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property wait_to_wait is
dependencies: no_reset;
freeze:
	MEtoCO_data_me_at_t = MEtoCO_data_me@t;
assume:
	at t: me_current_state = me_wait;
	at t: memory_used_by_if;
	at t: (MEtoCO_data_me.loadedData and resize(127,32)) = resize(3,32) or (MEtoCO_data_me.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t+1: me_current_state = me_wait;
	at t+1: COtoME_notify_me = false;
	at t+1: MEtoCO_notify_me = false;
	at t+1: MEtoCO_data_me = MEtoCO_data_me_at_t;
local_determination_requirements:
	at t+1: determined(MEtoCO_data_me);
end property;

property wait_to_load_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_me_at_t = MEtoCO_data_me@t;
assume:
	at t: me_current_state = me_wait;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_me.loadedData and resize(127,32)) = resize(3,32);
prove:
	at t_end: me_current_state = me_load_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
	at t_end: MEtoCO_data_me = MEtoCO_data_me_at_t;
local_determination_requirements:
	at t_end: determined(MEtoCO_data_me);
end property;

property wait_to_store_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_me_at_t = MEtoCO_data_me@t;
assume:
	at t: me_current_state = me_wait;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_me.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t_end: me_current_state = me_store_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
	at t_end: MEtoCO_data_me = MEtoCO_data_me_at_t;
local_determination_requirements:
	at t_end: determined(MEtoCO_data_me);
end property;

property bypass_to_bypass is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_bypass;
	at t: ex_stage_out_ready;
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32));
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_bypass;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property bypass_to_idle is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_bypass;
	at t: not(ex_stage_out_ready);
prove:
	at t_end: me_current_state = me_idle;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property bypass_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_ex_at_t = MEtoCO_data_ex@t;
assume:
	at t: me_current_state = me_bypass;
	at t: ex_stage_out_ready;
	at t: memory_used_by_if;
	at t: ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32)) or ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_wait;
	at t_end: MEtoCO_data_me = MEtoCO_data_ex_at_t;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property bypass_to_load_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_bypass;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32);
prove:
	at t_end: me_current_state = me_load_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property bypass_to_store_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_bypass;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t_end: me_current_state = me_store_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property store_write_to_store_write is
dependencies: no_reset;
assume:
	at t: me_current_state = me_store_write;
	at t: not(COtoME_port_sync);
prove:
	at t+1: me_current_state = me_store_write;
	at t+1: COtoME_notify_me = true;
	at t+1: MEtoCO_notify_me = false;
end property;

property load_write_to_load_write is
dependencies: no_reset;
assume:
	at t: me_current_state = me_load_write;
	at t: not(COtoME_port_sync);
prove:
	at t+1: me_current_state = me_load_write;
	at t+1: COtoME_notify_me = true;
	at t+1: MEtoCO_notify_me = false;
end property;

property load_write_to_load_read is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_load_write;
	at t: COtoME_port_sync;
prove:
	at t_end: me_current_state = me_load_read;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end-1]: MEtoCO_notify_me = false;
	at t_end: MEtoCO_notify_me = true;
end property;

property store_write_to_bypass is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_store_write;
	at t: COtoME_port_sync;
	at t: ex_stage_out_ready;
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32));
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_bypass;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property store_write_to_idle is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_store_write;
	at t: COtoME_port_sync;
	at t: not(ex_stage_out_ready);
prove:
	at t_end: me_current_state = me_idle;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property store_write_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_ex_at_t = MEtoCO_data_ex@t;
assume:
	at t: me_current_state = me_store_write;
	at t: COtoME_port_sync;
	at t: ex_stage_out_ready;
	at t: memory_used_by_if;
	at t: ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32)) or ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_wait;
	at t_end: MEtoCO_data_me = MEtoCO_data_ex_at_t;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property store_write_to_load_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_store_write;
	at t: COtoME_port_sync;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32);
prove:
	at t_end: me_current_state = me_load_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property store_write_to_store_write2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_store_write;
	at t: COtoME_port_sync;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t_end: me_current_state = me_store_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_bypass is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_load_read;
	at t: MEtoCO_port_sync;
	at t: ex_stage_out_ready;
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32));
	at t: not((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_bypass;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_idle is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_load_read;
	at t: MEtoCO_port_sync;
	at t: not(ex_stage_out_ready);
prove:
	at t_end: me_current_state = me_idle;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_wait is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	MEtoCO_data_ex_at_t = MEtoCO_data_ex@t;
assume:
	at t: me_current_state = me_load_read;
	at t: MEtoCO_port_sync;
	at t: ex_stage_out_ready;
	at t: memory_used_by_if;
	at t: ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32)) or ((MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32));
prove:
	at t_end: me_current_state = me_wait;
	at t_end: MEtoCO_data_me = MEtoCO_data_ex_at_t;
	during[t+1, t_end]: COtoME_notify_me = false;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_load_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_load_read;
	at t: MEtoCO_port_sync;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(3,32);
prove:
	at t_end: me_current_state = me_load_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_store_write is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: me_current_state = me_load_read;
	at t: MEtoCO_port_sync;
	at t: ex_stage_out_ready;
	at t: not(memory_used_by_if);
	at t: (MEtoCO_data_ex.loadedData and resize(127,32)) = resize(35,32);
prove:
	at t_end: me_current_state = me_store_write;
	during[t+1, t_end-1]: COtoME_notify_me = false;
	at t_end: COtoME_notify_me = true;
	during[t+1, t_end]: MEtoCO_notify_me = false;
end property;

property load_read_to_load_read is
dependencies: no_reset;
assume:
	at t: me_current_state = me_load_read;
	at t: not(MEtoCO_port_sync);
prove:
	at t+1: me_current_state = me_load_read;
	at t+1: COtoME_notify_me = false;
	at t+1: MEtoCO_notify_me = true;
end property;


