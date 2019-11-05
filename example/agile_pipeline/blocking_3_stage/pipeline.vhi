-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro b_in1_sync : boolean := end macro;
--macro b_in2_sync : boolean := end macro;
--macro b_out_sync : boolean := end macro;
--macro b_in1_notify : boolean := end macro;
--macro b_in2_notify : boolean := end macro;
--macro b_out_notify : boolean := end macro;


-- DP SIGNALS --
--macro b_in1_sig : signed := end macro;
--macro b_in2_sig : signed := end macro;
--macro b_out_sig : signed := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
--macro in1 : signed := b_in1_store1 end macro;
--macro in2 : signed := b_in2_store1 end macro;
--macro in1 : signed := if (b_in1_store1_turn) then b_in1_store1 else b_in1_store2 end if; end macro;
--macro in2 : signed := if (b_in2_store1_turn) then b_in2_store1 else b_in2_store2 end if; end macro;

macro in1_store1 : signed := b_in1_store1 end macro;
macro in1_store2 : signed := b_in1_store2 end macro;
macro in1_store_sel : boolean := b_in1_store1_turn end macro;
macro in1_store(in1_store_sel: boolean) : signed := 
	if (in1_store_sel) then in1_store1 else in1_store2 end if; 
end macro;

macro in2_store1 : signed := b_in2_store1 end macro;
macro in2_store2 : signed := b_in2_store2 end macro;
macro in2_store_sel : boolean := b_in2_store1_turn end macro;
macro in2_store(in2_store_sel: boolean) : signed := 
	if (in2_store_sel) then in2_store1 else in2_store2 end if; 
end macro;

macro out_retrieve_sel : boolean := b_out_store1_turn end macro;
macro out_retrieve_in1(out_retrieve_sel: boolean) : signed := 
	if (out_retrieve_sel) then in1_store1 else in1_store2 end if; 
end macro;
macro out_retrieve_in2(out_retrieve_sel: boolean) : signed := 
	if (out_retrieve_sel) then in2_store1 else in2_store2 end if; 
end macro;

-- STATES --
macro st_awwawa : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_stall_init) end macro;

macro st_abc : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_advance) end macro;
macro st_abaw : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_stall) end macro;
macro st_acwc : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_advance) end macro;
macro st_bwbc : boolean := (b_in1_state=st_stall and b_in2_state=st_advance and b_out_state=st_advance) end macro;
macro st_bwcwc : boolean := (b_in1_state=st_stall and b_in2_state=st_stall and b_out_state=st_advance) end macro;
macro st_bwbaw : boolean := (b_in1_state=st_stall and b_in2_state=st_advance and b_out_state=st_stall) end macro;
macro st_acwaw : boolean := (b_in1_state=st_advance and b_in2_state=st_stall and b_out_state=st_stall) end macro;

macro st_bca : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_advance) end macro;
macro st_awab : boolean := (b_in1_state=st_advance and b_in2_state=st_advance and b_out_state=st_stall) end macro;


-- OPERATIONS --
property reset is
assume:
	reset_sequence;
prove:
	at t: st_awwawa;
	at t: b_in1_notify = true;
	at t: b_in2_notify = false;
	at t: b_out_notify = false;
	at t: in1_store_sel = true;
	at t: in2_store_sel = true;
	at t: out_retrieve_sel = true;
	at t: in1_store1 = resize(0,32);
	at t: in1_store2 = resize(0,32);
	at t: in2_store1 = resize(0,32);
	at t: in2_store2 = resize(0,32);
end property;

-- wait operations
-- filling pipeline
property op_awwawa_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_awwawa;
	at t: not(b_in1_sync);
prove:
	at t+1: st_awwawa;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = false;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

--three stalled
property op_abc_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
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

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
	at t+1: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);	
end property;

--two stalled
property op_abaw_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_abaw;
	at t: not(b_in1_sync);
	at t: not(b_in2_sync);
prove:
	at t+1: st_abaw;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = false;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_acwc_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_acwc;
	at t: not(b_in1_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_acwc;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = true;
	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
	at t+1: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbc_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_bwbc;
	at t: not(b_in2_sync);
	at t: not(b_out_sync);
prove:
	at t+1: st_bwbc;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = true;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
	at t+1: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

--one stalled
property op_acwaw_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_acwaw;
	at t: not(b_in1_sync);
prove:
	at t+1: st_acwaw;
	at t+1: b_in1_notify = true;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = false;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwcwc_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_bwcwc;
	at t: not(b_out_sync);
prove:
	at t+1: st_bwcwc;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = false;
	at t+1: b_out_notify = true;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
	at t+1: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbaw_wait is
dependencies: no_reset;
freeze:
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(out_retrieve_sel)@t,
	out_retrieve_in2_at_t = out_retrieve_in2(out_retrieve_sel)@t;	
assume:
	at t: st_bwbaw;
	at t: not(b_in2_sync);
prove:
	at t+1: st_bwbaw;
	at t+1: b_in1_notify = false;
	at t+1: b_in2_notify = true;
	at t+1: b_out_notify = false;

	at t+1: in1_store_sel = in1_store_sel_at_t;
	at t+1: in1_store(in1_store_sel) = in1_store_at_t;
	at t+1: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t+1: in2_store_sel = in2_store_sel_at_t;
	at t+1: in2_store(in2_store_sel) = in2_store_at_t;
	at t+1: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t+1: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

-- advancing operations
-- filling pipeline
property op_awwawa_to_awab is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;	
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t, -- retrieve_sel varialble is updated only on the next clock cycle
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
	at t_end: b_out_sig = (out_retrieve_in1_at_t + b_in2_sig_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_abaw is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_acwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_bwbc is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abc_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + b_in2_sig_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_acwc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
	at t_end: b_out_sig = (out_retrieve_in1_at_t + b_in2_sig_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_acwaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwcwc_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbaw_to_bca is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + b_in2_sig_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abaw_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_acwc_to_acwaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_acwc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbc_to_bwcwc is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = not(in2_store_sel_at_t);
	at t_end: in2_store(in2_store_sel_at_t) = b_in2_sig_at_t;
	at t_end: in2_store(not(in2_store_sel_at_t)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
	at t_end: b_out_sig = (out_retrieve_in1_at_t + out_retrieve_in2_at_t)(31 downto 0);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_abaw_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = not(in1_store_sel_at_t);
	at t_end: in1_store(in1_store_sel_at_t) = b_in1_sig_at_t;
	at t_end: in1_store(not(in1_store_sel_at_t)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = out_retrieve_sel_at_t;
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

property op_bwbc_to_bwbaw is
dependencies: no_reset; 
for timepoints:
	t_end = t+1;
freeze:
	b_in1_sig_at_t = b_in1_sig@t,
	in1_store_sel_at_t = in1_store_sel@t,
	in1_store_at_t = in1_store(in1_store_sel)@t,
	in1_notstore_at_t = in1_store(not(in1_store_sel))@t,
	b_in2_sig_at_t = b_in2_sig@t,
	in2_store_sel_at_t = in2_store_sel@t,
	in2_store_at_t = in2_store(in2_store_sel)@t,
	in2_notstore_at_t = in2_store(not(in2_store_sel))@t,
	out_retrieve_sel_at_t = out_retrieve_sel@t,
	out_retrieve_in1_at_t = out_retrieve_in1(next(out_retrieve_sel))@t,
	out_retrieve_in2_at_t = out_retrieve_in2(next(out_retrieve_sel))@t;
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

	at t_end: in1_store_sel = in1_store_sel_at_t;
	at t_end: in1_store(in1_store_sel) = in1_store_at_t;
	at t_end: in1_store(not(in1_store_sel)) = in1_notstore_at_t;

	at t_end: in2_store_sel = in2_store_sel_at_t;
	at t_end: in2_store(in2_store_sel) = in2_store_at_t;
	at t_end: in2_store(not(in2_store_sel)) = in2_notstore_at_t;

	at t_end: out_retrieve_sel = not(out_retrieve_sel_at_t);
local_determination_requirements:
	at t+1: determined(b_in1_store1);
	at t+1: determined(b_in1_store2);
	at t+1: determined(b_in2_store1);
	at t+1: determined(b_in2_store2);
	at t+1: determined(b_in1_store1_turn);
	at t+1: determined(b_in2_store1_turn);
	at t+1: determined(b_out_store1_turn);
end property;

