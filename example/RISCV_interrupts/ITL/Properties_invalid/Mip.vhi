-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro MEIP_port_notify :  boolean  := end macro; 
macro MEIP_port_sync   :  boolean  := end macro; 
macro MSIP_port_notify :  boolean  := end macro; 
macro MSIP_port_sync   :  boolean  := end macro; 
macro MTIP_port_notify :  boolean  := end macro; 
macro MTIP_port_sync   :  boolean  := end macro; 
macro mip_isa_Port_notify :  boolean  := end macro; 
macro mip_isa_Port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro MEIP_port_sig : bool := end macro; 
macro MSIP_port_sig : bool := end macro; 
macro MTIP_port_sig : bool := end macro; 
macro mip_isa_Port_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro mip : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;
macro run_2 : boolean := true end macro;
macro run_3 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: mip = resize(0,32);
	 at t: MEIP_port_notify = false;
	 at t: MSIP_port_notify = true;
	 at t: MTIP_port_notify = false;
	 at t: mip_isa_Port_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	mip_at_t = mip@t;
assume: 
	 at t: run_0;
	 at t: not(MSIP_port_sync);
prove:
	 at t_end: run_1;
	 at t_end: mip = mip_at_t;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MSIP_port_sig_at_t = MSIP_port_sig@t,
	mip_at_t = mip@t;
assume: 
	 at t: run_0;
	 at t: MSIP_port_sync;
	 at t: MSIP_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: mip = manageBit(MSIP_port_sig_at_t,mip_at_t,3);
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end-1]: MTIP_port_notify = false;
	 at t_end: MTIP_port_notify = true;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;

property run_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	mip_at_t = mip@t;
assume: 
	 at t: run_1;
	 at t: not(MTIP_port_sync);
prove:
	 at t_end: run_2;
	 at t_end: mip = mip_at_t;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;

property run_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MTIP_port_sig_at_t = MTIP_port_sig@t,
	mip_at_t = mip@t;
assume: 
	 at t: run_1;
	 at t: MTIP_port_sync;
	 at t: MTIP_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: mip = manageBit(MTIP_port_sig_at_t,mip_at_t,7);
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;

property run_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	mip_at_t = mip@t;
assume: 
	 at t: run_2;
	 at t: not(MEIP_port_sync);
prove:
	 at t_end: run_3;
	 at t_end: mip = mip_at_t;
	 at t_end: mip_isa_Port_sig = mip_at_t;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
end property;

property run_2_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEIP_port_sig_at_t = MEIP_port_sig@t,
	mip_at_t = mip@t;
assume: 
	 at t: run_2;
	 at t: MEIP_port_sync;
	 at t: MEIP_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: mip = manageBit(MEIP_port_sig_at_t,mip_at_t,11);
	 at t_end: mip_isa_Port_sig = manageBit(MEIP_port_sig_at_t,mip_at_t,11);
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MSIP_port_notify = false;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end-1]: mip_isa_Port_notify = false;
	 at t_end: mip_isa_Port_notify = true;
end property;

property run_3_write_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	mip_at_t = mip@t;
assume: 
	 at t: run_3;
	 at t: mip_isa_Port_sync;
prove:
	 at t_end: run_0;
	 at t_end: mip = mip_at_t;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;

property run_3_write_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	mip_at_t = mip@t;
assume: 
	 at t: run_3;
	 at t: not(mip_isa_Port_sync);
prove:
	 at t_end: run_0;
	 at t_end: mip = mip_at_t;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MSIP_port_notify = false;
	 at t_end: MSIP_port_notify = true;
	 during[t+1, t_end]: MTIP_port_notify = false;
	 during[t+1, t_end]: mip_isa_Port_notify = false;
end property;