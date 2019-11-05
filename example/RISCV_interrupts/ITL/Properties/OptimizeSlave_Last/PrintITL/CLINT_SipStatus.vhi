-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
-- macro fromMemory_sip_sync   :  boolean  := end macro;


-- DP SIGNALS -- 
macro MSIP_port_sig : boolean := MSIP_port end macro;
macro fromMemory_sip_sig : unsigned := fromMemory_sip end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro msip_data : unsigned := msip_reg end macro;


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: msip_data = resize(0,32);
end property;


property run_0_read_0 is
dependencies: no_reset;
freeze:
	fromMemory_sip_sig_at_t = fromMemory_sip_sig@t;
assume: 
	 at t: run_0;
	 at t: not((fromMemory_sip_sig = resize(0,32)));
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
prove:
	 at t+1: run_0;
	 at t+1: MSIP_port_sig = true;
	 at t+1: msip_data = fromMemory_sip_sig_at_t;
end property;

property run_0_read_1 is
dependencies: no_reset;
freeze:
	msip_data_at_t = msip_data@t;
assume: 
	 at t: run_0;
	 at t: not((msip_data = resize(0,32)));
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
prove:
	 at t+1: run_0;
	 at t+1: MSIP_port_sig = true;
	 at t+1: msip_data = msip_data_at_t;
end property;

property run_0_read_2 is
dependencies: no_reset;
freeze:
	fromMemory_sip_sig_at_t = fromMemory_sip_sig@t;
assume: 
	 at t: run_0;
	 at t: (fromMemory_sip_sig = resize(0,32));
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
	 at t: fromMemory_sip_sync;
prove:
	 at t+1: run_0;
	 at t+1: MSIP_port_sig = false;
	 at t+1: msip_data = fromMemory_sip_sig_at_t;
end property;

property run_0_read_3 is
dependencies: no_reset;
freeze:
	msip_data_at_t = msip_data@t;
assume: 
	 at t: run_0;
	 at t: (msip_data = resize(0,32));
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
	 at t: not(fromMemory_sip_sync);
prove:
	 at t+1: run_0;
	 at t+1: MSIP_port_sig = false;
	 at t+1: msip_data = msip_data_at_t;
end property;