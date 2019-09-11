-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro block_in_notify :  boolean  := end macro; 
--macro block_in_sync   :  boolean  := end macro; 
--macro block_out_notify :  boolean  := end macro; 
--macro block_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro block_in_sig : int := block_in end macro; 
macro block_out_sig : int := block_out end macro; 
macro share_out_sig : bool := share_out end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 
constraint bounded_counter := succ_cnt <= 2147483646; end constraint;


-- VISIBLE REGISTERS --
macro succ_cnt : int := succ_cnt_signal end macro; 


-- STATES -- 
macro run_0 : boolean := (block_in_notify and not(block_out_notify)) end macro;
macro run_1 : boolean := (not(block_in_notify) and block_out_notify) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: share_out_sig = false;
	 at t: succ_cnt = 0;
	 at t: block_in_notify = true;
	 at t: block_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	share_out_sig_at_t = share_out_sig@t,
	succ_cnt_at_t = succ_cnt@t;
assume: 
	 at t: run_0;
	 at t: (block_in_sig <= 10);
	 at t: block_in_sync;
prove:
	 at t_end: run_0;
	 at t_end: share_out_sig = share_out_sig_at_t;
	 at t_end: succ_cnt = 0;
	 during[t+1, t_end-1]: share_out_sig=share_out_sig_at_t;
	 during[t+1, t_end-1]: block_in_notify = false;
	 at t_end: block_in_notify = true;
	 during[t+1, t_end]: block_out_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset, bounded_counter;
for timepoints:
	 t_end = t+1;
freeze:
	block_out_sig_at_t = block_out_sig@t,
	share_out_sig_at_t = share_out_sig@t,
	succ_cnt_at_t = succ_cnt@t;
assume: 
	 at t: run_0;
	 at t: (block_in_sig >= 11);
	 at t: block_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: block_out_sig = (1 + succ_cnt_at_t);
	 at t_end: share_out_sig = share_out_sig_at_t;
	 at t_end: succ_cnt = (1 + succ_cnt_at_t);
	 during[t+1, t_end-1]: share_out_sig=share_out_sig_at_t;
	 during[t+1, t_end]: block_in_notify = false;
	 during[t+1, t_end-1]: block_out_notify = false;
	 at t_end: block_out_notify = true;
end property;

property run_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	share_out_sig_at_t = share_out_sig@t,
	succ_cnt_at_t = succ_cnt@t,
	block_out_sync_at_t = block_out_sync@t;
assume: 
	 at t: run_1;
	 at t: block_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: share_out_sig = block_out_sync_at_t;
	 at t_end: succ_cnt = succ_cnt_at_t;
	 during[t+1, t_end-1]: share_out_sig=share_out_sig_at_t;
	 during[t+1, t_end-1]: block_in_notify = false;
	 at t_end: block_in_notify = true;
	 during[t+1, t_end]: block_out_notify = false;
end property;

property run_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	share_out_sig_at_t = share_out_sig@t,
	succ_cnt_at_t = succ_cnt@t;
assume: 
	 at t: run_1;
	 at t: not(block_out_sync);
prove:
	 at t_end: run_0;
	 at t_end: share_out_sig = false;
	 at t_end: succ_cnt = succ_cnt_at_t;
	 during[t+1, t_end-1]: share_out_sig=share_out_sig_at_t;
	 during[t+1, t_end-1]: block_in_notify = false;
	 at t_end: block_in_notify = true;
	 during[t+1, t_end]: block_out_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	share_out_sig_at_t = share_out_sig@t,
	succ_cnt_at_t = succ_cnt@t;
assume: 
	 at t: run_0;
	 at t: not(block_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: share_out_sig = share_out_sig_at_t;
	 at t+1: succ_cnt = succ_cnt_at_t;
	 at t+1: block_in_notify = true;
	 at t+1: block_out_notify = false;
	 at t+1: block_in_notify = true;
end property;
