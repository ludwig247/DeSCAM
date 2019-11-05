-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in_sync : boolean := end macro;
--macro b_out_sync : boolean := end macro;
macro b_in_notify_local : boolean := b_in_notify end macro;
macro b_out_notify_local : boolean := b_out_notify end macro;


-- DP SIGNALS --
macro b_in_sig : signed := b_in end macro;
macro b_out_sig : signed := b_out end macro;

-- PIPELINE SIGNALS --
--macro b_out_free : boolean := s1/b_out_free end macro;
--macro b_in_free : boolean := s1/b_in_free end macro;



-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
--macro b_out_store : signed := end macro;

-- STATES --
macro st_a : boolean := state=a end macro;
macro st_aw : boolean := state=aw end macro;
macro st_b : boolean := state=b end macro;
macro st_bw : boolean := state=bw end macro;

macro initial_state_def : boolean := if (initial_state=aw) then (
	st_aw and 
	b_in_notify = false and 
	b_out_notify = false
) else (
	st_a and
	b_in_notify = true and 
	b_out_notify = false
) end if; end macro;


-- OPERATIONS --

property reset is
assume:
	 reset_sequence;
prove:
	 at t: initial_state_def;
end property;

-- Begin manual properties

property op_b_to_aw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_b;
	at t: b_out_sync;
	at t: not(b_in_free);
prove:
	at t_end: st_aw;
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end]: b_out_notify_local = false;
end property;

property op_aw_to_a is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_aw;
	at t: b_in_free;
prove:
	at t_end: st_a;
	during[t+1, t_end]: b_out_notify_local = false;
	during[t+1, t_end-1]: b_in_notify_local = false;
	at t_end: b_in_notify = true;
end property;

property op_aw_wait is
dependencies: no_reset; 
assume:
	at t: st_aw;
	at t: not(b_in_free);
prove:
	at t+1: st_aw;
	at t+1: b_in_notify_local = false;
	at t+1: b_out_notify_local = false;
end property;

property op_a_to_bw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_a;
	at t: b_in_sync;
	at t: not(b_out_free);
prove:
	at t_end: st_bw;
	at t_end: b_out_store = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end]: b_out_notify_local = false;
end property;

property op_bw_to_b is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_out_store_at_t = b_out_store@t;
assume:
	at t: st_bw;
	at t: b_out_free;
prove:
	at t_end: st_b;
	at t_end: b_out_sig = b_out_store_at_t;
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end-1]: b_out_notify_local = false;
	at t_end: b_out_notify = true;
end property;

property op_bw_wait is
dependencies: no_reset; 
freeze:
	b_out_store_at_t = b_out_store@t;
assume:
	at t: st_bw;
	at t: not(b_out_free);
prove:
	at t+1: st_bw;
	at t+1: b_out_store = b_out_store_at_t;
	at t+1: b_in_notify_local = false;
	at t+1: b_out_notify_local = false;
local_determination_requirements:
	at t+1: determined(b_out_store);
end property;

-- End manual properties

property op_a_to_b is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume:
	at t: st_a;
	at t: b_in_sync;
	at t: b_out_free;
prove:
	at t_end: st_b;
	at t_end: b_out_sig = (1 + b_in_sig_at_t)(31 downto 0);
	during[t+1, t_end]: b_in_notify_local = false;
	during[t+1, t_end-1]: b_out_notify_local = false;
	at t_end: b_out_notify = true;
end property;


property op_b_to_a is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
assume:
	at t: st_b;
	at t: b_out_sync;
	at t: b_in_free;
prove:
	at t_end: st_a;
	during[t+1, t_end-1]: b_in_notify_local = false;
	at t_end: b_in_notify = true;
	during[t+1, t_end]: b_out_notify_local = false;
end property;

property op_a_wait is
dependencies: no_reset;
assume:
	at t: st_a;
	at t: not(b_in_sync);
prove:
	at t+1: st_a;
	at t+1: b_in_notify = true;
	at t+1: b_out_notify_local= false;
end property;


property op_b_wait is
dependencies: no_reset;
freeze:
	b_out_sig_at_t = b_out_sig@t;
assume:
	at t: st_b;
	at t: not(b_out_sync);
prove:
	at t+1: st_b;
	at t+1: b_out_sig = b_out_sig_at_t;
	at t+1: b_in_notify_local = false;
	at t+1: b_out_notify = true;
end property;

