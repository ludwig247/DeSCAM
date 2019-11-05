-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in1_sync : boolean := end macro;
--macro b_in2_sync : boolean := end macro;
--macro b_out_sync : boolean := end macro;
--macro b_in1_notify : boolean := end macro;
--macro b_in2_notify : boolean := end macro;
--macro b_out_notify : boolean := end macro;

-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;

-- STATES --
--filling pipeline
macro st_awwawa : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_stall_init) end macro;
--main states
macro st_abc : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_advance) end macro;
macro st_abaw : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_stall) end macro;
macro st_acwc : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_advance) end macro;
macro st_bwbc : boolean := (b_in1_state=st_stall and b_in2_state=st_advance and b_out_state=st_advance) end macro;
macro st_bwcwc : boolean := (b_in1_state=st_stall and b_in2_state=st_stall and b_out_state=st_advance) end macro;
macro st_bwbaw : boolean := (b_in1_state=st_stall and b_in2_state=st_advance and b_out_state=st_stall) end macro;
macro st_acwaw : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_stall) end macro;
--complementary states
macro st_bca : boolean := st_abc end macro;
macro st_awab : boolean := st_abaw end macro;


-- OPERATIONS --
property reset is
assume:
	reset_sequence;
prove:
	at t: st_awwawa;
	at t: b_in1_notify = true;
	at t: b_in2_notify = false;
	at t: b_out_notify = false;
end property;

--wait operations
--filling pipeline
property op_awwawa_wait is
dependencies: no_reset; 
assume:
	at t: st_awwawa;
	at t: not(b_in1_sync);
prove:
	at t+1: st_awwawa;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = false;
end property;

--three stalled
property op_abc_wait is
dependencies: no_reset; 
assume:
	at t: st_abc;
	at t: not(b_in1_sync);
	at t: not(b_in2_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_abc;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = true;
end property;

--two stalled
property op_abaw_wait is
dependencies: no_reset; 
assume:
	at t: st_abaw;
	at t: not(b_in1_sync);
	at t: not(b_in2_sync);
prove:
	at t+1: st_abaw;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = false;
end property;

property op_acwc_wait is
dependencies: no_reset; 
assume:
	at t: st_acwc;
	at t: not(b_in1_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_acwc;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = true;
end property;

property op_bwbc_wait is
dependencies: no_reset; 
assume:
	at t: st_bwbc;
	at t: not(b_in2_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_bwbc;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = true;
end property;

--one stalled
property op_acwaw_wait is
dependencies: no_reset; 
assume:
	at t: st_acwaw;
	at t: not(b_in1_sync);
prove:
	at t+1: st_acwaw;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = false;
end property;

property op_bwcwc_wait is
dependencies: no_reset; 
assume:
	at t: st_bwcwc;
	at t: not(b_out_sync);
prove:
	at t+1: st_bwcwc;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = true;
end property;

property op_bwbaw_wait is
dependencies: no_reset; 
assume:
	at t: st_bwbaw;
	at t: not(b_in2_sync);
prove:
	at t+1: st_bwbaw;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = false;
end property;

--advance operations
--filling pipeline
property op_awwawa_to_awab is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_awwawa;
	at t: b_in1_sync;
prove:
	at t_end: st_awab;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_abc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: b_in1_sync;
	at t: b_in2_sync;
	at t: b_out_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abc_to_abaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: not(b_in1_sync);
	at t: not(b_in2_sync);
	at t: b_out_sync;
prove:
	at t_end: st_abaw;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_abc_to_acwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: not(b_in1_sync);
	at t: b_in2_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_acwc;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abc_to_bwbc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: b_in1_sync;
	at t: not(b_in2_sync);
	at t: not(b_out_sync);
prove:
	at t_end: st_bwbc;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abc_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: not(b_in1_sync);
	at t: b_in2_sync;
	at t: b_out_sync;
prove:
	at t_end: st_acwaw;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_abc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: b_in1_sync;
	at t: b_in2_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_bwcwc;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abc_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abc;
	at t: b_in1_sync;
	at t: not(b_in2_sync);
	at t: b_out_sync;
prove:
	at t_end: st_bwbaw;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_abaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abaw;
	at t: b_in1_sync;
	at t: b_in2_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_acwc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_acwc;
	at t: b_in1_sync;
	at t: b_out_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bwbc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_bwbc;
	at t: b_in2_sync;
	at t: b_out_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_acwaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_acwaw;
	at t: b_in1_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bwcwc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_bwcwc;
	at t: b_out_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bwbaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_bwbaw;
	at t: b_in2_sync;
prove:
	at t_end: st_bca;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abaw_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abaw;
	at t: not(b_in1_sync);
	at t: b_in2_sync;
prove:
	at t_end: st_acwaw;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_acwc_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_acwc;
	at t: not(b_in1_sync);
	at t: b_out_sync;
prove:
	at t_end: st_acwaw;
	during[t+1, t_end-1]: b_in1_notify = false;
	at t_end: b_in1_notify = true;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_acwc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_acwc;
	at t: b_in1_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_bwcwc;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_bwbc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_bwbc;
	at t: b_in2_sync;
	at t: not(b_out_sync);
prove:
	at t_end: st_bwcwc;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end]: b_in2_notify = false;
	during[t+1, t_end-1]: b_out_notify = false;
	at t_end: b_out_notify = true;
end property;

property op_abaw_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_abaw;
	at t: b_in1_sync;
	at t: not(b_in2_sync);
prove:
	at t_end: st_bwbaw;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

property op_bwbc_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
assume:
	at t: st_bwbc;
	at t: not(b_in2_sync);
	at t: b_out_sync;
prove:
	at t_end: st_bwbaw;
	during[t+1, t_end]: b_in1_notify = false;
	during[t+1, t_end-1]: b_in2_notify = false;
	at t_end: b_in2_notify = true;
	during[t+1, t_end]: b_out_notify = false;
end property;

