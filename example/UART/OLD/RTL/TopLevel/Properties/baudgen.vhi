-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 


-- DP SIGNALS -- 
macro baudrate_control_sig : unsigned := baudrate_control end macro; 
macro rec_trigger_sig : boolean := rec_trigger end macro; 
macro trans_trigger_sig : boolean := trans_trigger end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro baudcounter : unsigned := baudcounter_signal end macro; 
macro trigg : boolean := trigg_signal end macro;  


-- STATES -- 
macro INIT_0 : boolean :=
section = INIT
end macro;
macro RUN_1 : boolean :=
section = RUN
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: INIT_0;
	 at t: baudcounter = resize(0,32);
	 at t: rec_trigger_sig = false;
	 at t: trans_trigger_sig = false;
	 at t: trigg = false;
end property;


property INIT_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	rec_trigger_sig_at_t = rec_trigger_sig@t,
	trans_trigger_sig_at_t = trans_trigger_sig@t;
assume: 
	 at t: INIT_0;
	 at t: (resize(0,32) = (baudrate_control_sig and resize(65535,32)));
prove:
	 at t_end: RUN_1;
	 at t_end: baudcounter = 0;
	 at t_end: rec_trigger_sig = rec_trigger_sig_at_t;
	 at t_end: trans_trigger_sig = trans_trigger_sig_at_t;
	 at t_end: trigg = true;
end property;

property INIT_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	rec_trigger_sig_at_t = rec_trigger_sig@t,
	trans_trigger_sig_at_t = trans_trigger_sig@t;
assume: 
	 at t: INIT_0;
	 at t: not((resize(0,32) = (baudrate_control_sig and resize(65535,32))));
prove:
	 at t_end: RUN_1;
	 at t_end: baudcounter = 1;
	 at t_end: rec_trigger_sig = rec_trigger_sig_at_t;
	 at t_end: trans_trigger_sig = trans_trigger_sig_at_t;
	 at t_end: trigg = false;
end property;

property RUN_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	trigg_at_t = trigg@t;
assume: 
	 at t: RUN_1;
	 at t: (baudcounter = (baudrate_control_sig and resize(65535,32)));
prove:
	 at t_end: RUN_1;
	 at t_end: baudcounter = 0;
	 at t_end: rec_trigger_sig = trigg_at_t;
	 at t_end: trans_trigger_sig = trigg_at_t;
	 at t_end: trigg = true;
end property;

property RUN_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	baudcounter_at_t = baudcounter@t,
	trigg_at_t = trigg@t;
assume: 
	 at t: RUN_1;
	 at t: not((baudcounter = (baudrate_control_sig and resize(65535,32))));
prove:
	 at t_end: RUN_1;
	 at t_end: baudcounter = (1 + baudcounter_at_t)(31 downto 0);
	 at t_end: rec_trigger_sig = trigg_at_t;
	 at t_end: trans_trigger_sig = trigg_at_t;
	 at t_end: trigg = false;
end property;
