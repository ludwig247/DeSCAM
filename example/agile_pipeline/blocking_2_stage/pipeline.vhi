
-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in_sync : boolean := end macro;
--macro b_out_sync : boolean := end macro;

-- DP SIGNALS --
macro b_in_sig : signed := b_in end macro;
macro b_out_sig : signed := b_out end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;

-- VISIBLE REGISTERS --
--macro b_out_store1 : signed := end macro;
--macro b_out_store2 : signed := end macro;


-- STATES --
macro st_aaw : boolean := (b_in_state=a  and b_out_state=aw) and (b_out_store1_write = true)  end macro;
macro st_ab  : boolean := (b_in_state=a  and b_out_state=b)  and (b_out_store1_write = true)  end macro;
macro st_awa : boolean := (b_in_state=a  and b_out_state=aw) and (b_out_store1_write = false) end macro;
macro st_bbw : boolean := (b_in_state=bw and b_out_state=b)  and (b_out_store1_write = true)  end macro;
macro st_ba  : boolean := (b_in_state=a  and b_out_state=b)  and (b_out_store1_write = false) end macro;
macro st_bwb : boolean := (b_in_state=bw and b_out_state=b)  and (b_out_store1_write = false) end macro;

--macro st_aaw : boolean := (b_in_state=a  and b_out_state=aw) and (b_out_store1_read = true)  end macro;
--macro st_ab  : boolean := (b_in_state=a  and b_out_state=b)  and (b_out_store1_read = false) end macro;
--macro st_awa : boolean := (b_in_state=a  and b_out_state=aw) and (b_out_store1_read = false) end macro;
--macro st_bbw : boolean := (b_in_state=bw and b_out_state=b)  and (b_out_store1_read = true)  end macro;
--macro st_ba  : boolean := (b_in_state=a  and b_out_state=b)  and (b_out_store1_read = true)  end macro;
--macro st_bwb : boolean := (b_in_state=bw and b_out_state=b)  and (b_out_store1_read = false) end macro;

-- OPERATIONS --
-- reset
property reset is
assume:
	reset_sequence;
prove:
	at t: st_aaw;
	at t: b_in_notify = true;
	at t: b_out_notify = false;
end property;

-- wait operations
property op_awa_wait is
dependencies: no_reset; 
assume:
	at t: st_awa;
	at t: not(b_in_sync);
prove:
	at t+1: st_awa;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;

property op_aaw_wait is
dependencies: no_reset; 
assume:
	at t: st_aaw;
	at t: not(b_in_sync);
prove:
	at t+1: st_aaw;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = false;
end property;

property op_bwb_wait is
dependencies: no_reset;
freeze:
	b_out_store1_at_t = b_out_store1@t,
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: st_bwb;
	at t: not(b_out_sync);
prove:
	at t+1: st_bwb;
	at t+1: b_out_store1 = b_out_store1_at_t;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
local_determination_requirements:
	at t+1: determined(b_out_store1);
end property;

property op_bbw_wait is
dependencies: no_reset;
freeze:
	b_out_store2_at_t = b_out_store2@t,
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: st_bbw;
	at t: not(b_out_sync);
prove:
	at t+1: st_bbw;
	at t+1: b_out_store2 = b_out_store2_at_t;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify = false;
	at t+1: b_out_notify = true;
local_determination_requirements:
	at t+1: determined(b_out_store2);
end property;

property op_ab_wait is
dependencies: no_reset; 
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: st_ab;
	at t: not(b_in_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_ab;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = true;
end property;

property op_ba_wait is
dependencies: no_reset; 
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: st_ba;
	at t: not(b_in_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_ba;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify = true;
end property;

-- other operations
property op_ab_to_ba is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_ab;
	at t: b_in_sync;
	at t: b_out_sync;
prove:
	at t_end: st_ba;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_ba_to_ab is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_ba;
	at t: b_in_sync;
	at t: b_out_sync;
prove:
	at t_end: st_ab;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_awa_to_ab is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_awa;
	at t: b_in_sync;
prove:
	at t_end: st_ab;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_aaw_to_ba is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_aaw;
	at t: b_in_sync;
prove:
	at t_end: st_ba;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bbw_to_ab is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_out_store2_at_t = b_out_store2@t;
assume:
	at t: st_bbw;
	at t: b_out_sync;
prove:
	at t_end: st_ab;
	at t_end: b_out_sig = b_out_store2_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bwb_to_ba is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_out_store1_at_t = b_out_store1@t;
assume:
	at t: st_bwb;
	at t: b_out_sync;
prove:
	at t_end: st_ba;
	at t_end: b_out_sig = b_out_store1_at_t;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_ba_to_awa is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_ba;
	at t: not(b_in_sync);
	at t: b_out_sync;
prove:
	at t_end: st_awa;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_ab_to_aaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_ab;
	at t: not(b_in_sync);
	at t: b_out_sync;
prove:
	at t_end: st_aaw;
	during[t+1, t_end-1]: b_in_notify = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_ab_to_bwb is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_ab;
	at t: b_in_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_bwb;
	at t_end: b_out_sig = b_out_sig_at_t;
	at t_end: b_out_store1 = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_ba_to_bbw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_out_sig_at_t = b_out_sig@t,
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_ba;
	at t: b_in_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_bbw;
	at t_end: b_out_sig = b_out_sig_at_t;
	at t_end: b_out_store2 = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

