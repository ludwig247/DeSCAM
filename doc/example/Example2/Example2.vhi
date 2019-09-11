-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro msg_port_notify :  boolean  := end macro; 
--macro msg_port_sync   :  boolean  := end macro; 
--macro new_frame_found_notify :  boolean  := end macro; 
--macro new_frame_found_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro msg_port_addr_sig : int := msg_signal.addr end macro; 
macro msg_port_data_sig : int := msg_signal.data end macro; 
macro new_frame_found_sig : bool := new_frame_found end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro cnt : int := cnt_signal end macro; 


-- STATES -- 
macro idle_0 : boolean := (new_frame_found_notify and not(msg_port_notify)) end macro;
macro reading_1 : boolean := (not(new_frame_found_notify) and msg_port_notify) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: idle_0;
	 at t: cnt = 0;
	 at t: msg_port_notify = false;
	 at t: new_frame_found_notify = true;
end property;


property idle_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: idle_0;
	 at t: not(new_frame_found_sig);
	 at t: new_frame_found_sync;
prove:
	 at t_end: idle_0;
	 at t_end: cnt = cnt_at_t;
	 during[t+1, t_end]: msg_port_notify = false;
	 during[t+1, t_end-1]: new_frame_found_notify = false;
	 at t_end: new_frame_found_notify = true;
end property;

property idle_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: idle_0;
	 at t: new_frame_found_sig;
	 at t: new_frame_found_sync;
prove:
	 at t_end: reading_1;
	 at t_end: cnt = cnt_at_t;
	 during[t+1, t_end-1]: msg_port_notify = false;
	 at t_end: msg_port_notify = true;
	 during[t+1, t_end]: new_frame_found_notify = false;
end property;


property reading_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: reading_1;
	 at t: (cnt >= 4);
	 at t: msg_port_sync;
prove:
	 at t_end: idle_0;
	 at t_end: cnt = 0;
	 during[t+1, t_end]: msg_port_notify = false;
	 during[t+1, t_end-1]: new_frame_found_notify = false;
	 at t_end: new_frame_found_notify = true;
end property;

property reading_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: reading_1;
	 at t: (cnt <= 3);
	 at t: msg_port_sync;
prove:
	 at t_end: reading_1;
	 at t_end: cnt = (1 + cnt_at_t);
	 during[t+1, t_end-1]: msg_port_notify = false;
	 at t_end: msg_port_notify = true;
	 during[t+1, t_end]: new_frame_found_notify = false;
end property;

property wait_idle_0 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: idle_0;
	 at t: not(new_frame_found_sync);
prove:
	 at t+1: idle_0;
	 at t+1: cnt = cnt_at_t;
	 at t+1: msg_port_notify = false;
	 at t+1: new_frame_found_notify = true;
end property;

property wait_reading_1 is
dependencies: no_reset;
freeze:
	cnt_at_t = cnt@t;
assume: 
	 at t: reading_1;
	 at t: not(msg_port_sync);
prove:
	 at t+1: reading_1;
	 at t+1: cnt = cnt_at_t;
	 at t+1: msg_port_notify = true;
	 at t+1: new_frame_found_notify = false;
end property;