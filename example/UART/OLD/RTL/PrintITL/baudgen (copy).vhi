-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 


-- DP SIGNALS -- 
macro baudrate_control_sig : unsigned := baudrate_control end macro; 
macro rec_trigger_sig : unsigned := rec_trigger end macro; 
macro trans_trigger_sig : unsigned := trans_trigger end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro baudcounter : unsigned := baudcounter_signal end macro; 
macro prescaler : unsigned := prescaler_signal end macro; 


-- STATES -- 
macro RUN_0 : boolean :=
section = RUN
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: RUN_0;
	 at t: baudcounter = resize(0,32);
	 at t: prescaler = calc_prescaler(resize(10000000,32),baudrate_control_sig);
	 at t: trans_trigger_sig = trigging(resize(0,32),calc_prescaler(resize(10000000,32),baudrate_control_sig));
end property;


property RUN_0_write_0 is
dependencies: no_reset;
freeze:
	baudcounter_at_t = baudcounter@t,
	baudrate_control_sig_at_t = baudrate_control_sig@t,
	prescaler_at_t = prescaler@t;
assume: 
	 at t: RUN_0;
prove:
	 at t+1: RUN_0;
	 at t+1: baudcounter = count(baudcounter_at_t,prescaler_at_t);
	 at t+1: prescaler = calc_prescaler(resize(10000000,32),baudrate_control_sig_at_t);
	 at t+1: rec_trigger_sig = trigging(baudcounter_at_t,prescaler_at_t);
	 at t+1: trans_trigger_sig = trigging(count(baudcounter_at_t,prescaler_at_t),calc_prescaler(resize(10000000,32),baudrate_control_sig_at_t));
end property;