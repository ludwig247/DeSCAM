-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro fromMemory_timecmp_H_sync   :  boolean  := end macro; 
macro fromMemory_timecmp_L_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro MTIP_port_sig : boolean := end macro; 
macro fromMemory_timecmp_H_sig : unsigned := end macro; 
macro fromMemory_timecmp_L_sig : unsigned := end macro; 
macro fromTimer_H_sig : unsigned := end macro; 
macro fromTimer_L_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro mtimeH_data : unsigned := end macro; 
macro mtimeL_data : unsigned := end macro; 
macro mtimecmpH_data : unsigned := end macro; 
macro mtimecmpL_data : unsigned := end macro; 


-- STATES -- 
macro run_2 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_2;
	 at t: mtimeH_data = fromTimer_H_sig;
	 at t: mtimeL_data = fromTimer_L_sig;
	 at t: mtimecmpH_data = resize(2147483647,32);
	 at t: mtimecmpL_data = resize(2147483647,32);
end property;


property run_2_read_0 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t;
assume: 
	 at t: run_2;
	 at t: (fromMemory_timecmp_L_sig <= mtimeL_data);
	 at t: (fromMemory_timecmp_H_sig <= mtimeH_data);
	 at t: (fromMemory_timecmp_L_sig <= fromTimer_L_sig);
	 at t: (fromMemory_timecmp_H_sig <= fromTimer_H_sig);
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_1 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t;
assume: 
	 at t: run_2;
	 at t: (fromMemory_timecmp_L_sig <= mtimeL_data);
	 at t: (fromMemory_timecmp_H_sig <= mtimeH_data);
	 at t: not(((fromMemory_timecmp_L_sig <= fromTimer_L_sig) and (fromMemory_timecmp_H_sig <= fromTimer_H_sig)));
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_2 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t;
assume: 
	 at t: run_2;
	 at t: (fromMemory_timecmp_L_sig <= mtimeL_data);
	 at t: (mtimecmpH_data <= mtimeH_data);
	 at t: (fromMemory_timecmp_L_sig <= fromTimer_L_sig);
	 at t: (mtimecmpH_data <= fromTimer_H_sig);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_3 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t;
assume: 
	 at t: run_2;
	 at t: (fromMemory_timecmp_L_sig <= mtimeL_data);
	 at t: (mtimecmpH_data <= mtimeH_data);
	 at t: not(((fromMemory_timecmp_L_sig <= fromTimer_L_sig) and (mtimecmpH_data <= fromTimer_H_sig)));
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_4 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t;
assume: 
	 at t: run_2;
	 at t: not(((fromMemory_timecmp_L_sig <= mtimeL_data) and (fromMemory_timecmp_H_sig <= mtimeH_data)));
	 at t: (fromMemory_timecmp_L_sig <= fromTimer_L_sig);
	 at t: (fromMemory_timecmp_H_sig <= fromTimer_H_sig);
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_5 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t;
assume: 
	 at t: run_2;
	 at t: not(((fromMemory_timecmp_L_sig <= mtimeL_data) and (fromMemory_timecmp_H_sig <= mtimeH_data)));
	 at t: not(((fromMemory_timecmp_L_sig <= fromTimer_L_sig) and (fromMemory_timecmp_H_sig <= fromTimer_H_sig)));
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
	 at t: fromMemory_timecmp_L_sync;
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_6 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t;
assume: 
	 at t: run_2;
	 at t: not(((fromMemory_timecmp_L_sig <= mtimeL_data) and (mtimecmpH_data <= mtimeH_data)));
	 at t: (fromMemory_timecmp_L_sig <= fromTimer_L_sig);
	 at t: (mtimecmpH_data <= fromTimer_H_sig);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_7 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_L_sig_at_t = fromMemory_timecmp_L_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t;
assume: 
	 at t: run_2;
	 at t: not(((fromMemory_timecmp_L_sig <= mtimeL_data) and (mtimecmpH_data <= mtimeH_data)));
	 at t: not(((fromMemory_timecmp_L_sig <= fromTimer_L_sig) and (mtimecmpH_data <= fromTimer_H_sig)));
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: fromMemory_timecmp_L_sync;
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = fromMemory_timecmp_L_sig_at_t;
end property;

property run_2_read_8 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: (mtimecmpL_data <= mtimeL_data);
	 at t: (fromMemory_timecmp_H_sig <= mtimeH_data);
	 at t: (mtimecmpL_data <= fromTimer_L_sig);
	 at t: (fromMemory_timecmp_H_sig <= fromTimer_H_sig);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_9 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: (mtimecmpL_data <= mtimeL_data);
	 at t: (fromMemory_timecmp_H_sig <= mtimeH_data);
	 at t: not(((mtimecmpL_data <= fromTimer_L_sig) and (fromMemory_timecmp_H_sig <= fromTimer_H_sig)));
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_10 is
dependencies: no_reset;
freeze:
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: (mtimecmpL_data <= mtimeL_data);
	 at t: (mtimecmpH_data <= mtimeH_data);
	 at t: (mtimecmpL_data <= fromTimer_L_sig);
	 at t: (mtimecmpH_data <= fromTimer_H_sig);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_11 is
dependencies: no_reset;
freeze:
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: (mtimecmpL_data <= mtimeL_data);
	 at t: (mtimecmpH_data <= mtimeH_data);
	 at t: not(((mtimecmpL_data <= fromTimer_L_sig) and (mtimecmpH_data <= fromTimer_H_sig)));
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_12 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: not(((mtimecmpL_data <= mtimeL_data) and (fromMemory_timecmp_H_sig <= mtimeH_data)));
	 at t: (mtimecmpL_data <= fromTimer_L_sig);
	 at t: (fromMemory_timecmp_H_sig <= fromTimer_H_sig);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_13 is
dependencies: no_reset;
freeze:
	fromMemory_timecmp_H_sig_at_t = fromMemory_timecmp_H_sig@t,
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: not(((mtimecmpL_data <= mtimeL_data) and (fromMemory_timecmp_H_sig <= mtimeH_data)));
	 at t: not(((mtimecmpL_data <= fromTimer_L_sig) and (fromMemory_timecmp_H_sig <= fromTimer_H_sig)));
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: fromMemory_timecmp_H_sync;
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = fromMemory_timecmp_H_sig_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_14 is
dependencies: no_reset;
freeze:
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: not(((mtimecmpL_data <= mtimeL_data) and (mtimecmpH_data <= mtimeH_data)));
	 at t: (mtimecmpL_data <= fromTimer_L_sig);
	 at t: (mtimecmpH_data <= fromTimer_H_sig);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = true;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;

property run_2_read_15 is
dependencies: no_reset;
freeze:
	fromTimer_H_sig_at_t = fromTimer_H_sig@t,
	fromTimer_L_sig_at_t = fromTimer_L_sig@t,
	mtimecmpH_data_at_t = mtimecmpH_data@t,
	mtimecmpL_data_at_t = mtimecmpL_data@t;
assume: 
	 at t: run_2;
	 at t: not(((mtimecmpL_data <= mtimeL_data) and (mtimecmpH_data <= mtimeH_data)));
	 at t: not(((mtimecmpL_data <= fromTimer_L_sig) and (mtimecmpH_data <= fromTimer_H_sig)));
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
	 at t: not(fromMemory_timecmp_L_sync);
	 at t: not(fromMemory_timecmp_H_sync);
prove:
	 at t+1: run_2;
	 at t+1: MTIP_port_sig = false;
	 at t+1: mtimeH_data = fromTimer_H_sig_at_t;
	 at t+1: mtimeL_data = fromTimer_L_sig_at_t;
	 at t+1: mtimecmpH_data = mtimecmpH_data_at_t;
	 at t+1: mtimecmpL_data = mtimecmpL_data_at_t;
end property;