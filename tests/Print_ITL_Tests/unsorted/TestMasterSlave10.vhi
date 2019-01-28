-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro s_in_sync   :  boolean  := end macro; 
macro s_in2_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro s_in_sig : int := end macro; 
macro s_in2_sig : int := end macro; 
macro s_out_sig : int := end macro; 
macro sharded_in_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro shared : int := end macro; 
macro succ : bool := end macro; 
macro val : int := end macro; 


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_B_2 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: s_out_sig = resize(0,32);
	 at t: shared = resize(0,32);
	 at t: succ = false;
	 at t: val = resize(0,32);
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
end property;

property SECTION_A_0_read_1 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = s_in_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in_sig_at_t;
end property;

property SECTION_A_0_read_2 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
end property;

property SECTION_A_0_read_3 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = s_in_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in_sig_at_t;
end property;

property SECTION_A_0_read_4 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
end property;

property SECTION_A_0_read_5 is
dependencies: no_reset;
freeze:
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: not(succ);
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = val_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = val_at_t;
end property;

property SECTION_A_0_read_6 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = s_in2_sig_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = s_in2_sig_at_t;
end property;

property SECTION_A_0_read_7 is
dependencies: no_reset;
freeze:
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_A_0;
	 at t: succ;
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_B_2;
	 at t+1: s_out_sig = val_at_t;
	 at t+1: shared = shared_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = val_at_t;
end property;

property SECTION_B_2_read_8 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	sharded_in_sig_at_t = sharded_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_2;
	 at t: s_in_sync;
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = ((2 * val_at_t)(31 downto 0) + shared_at_t)(31 downto 0);
	 at t+1: shared = sharded_in_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in2_sig_at_t)(31 downto 0);
end property;

property SECTION_B_2_read_9 is
dependencies: no_reset;
freeze:
	s_in_sig_at_t = s_in_sig@t,
	sharded_in_sig_at_t = sharded_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_2;
	 at t: s_in_sync;
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = ((2 * val_at_t)(31 downto 0) + shared_at_t)(31 downto 0);
	 at t+1: shared = sharded_in_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in_sig_at_t)(31 downto 0);
end property;

property SECTION_B_2_read_10 is
dependencies: no_reset;
freeze:
	s_in2_sig_at_t = s_in2_sig@t,
	sharded_in_sig_at_t = sharded_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_2;
	 at t: not(s_in_sync);
	 at t: s_in2_sync;
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = ((2 * val_at_t)(31 downto 0) + shared_at_t)(31 downto 0);
	 at t+1: shared = sharded_in_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * s_in2_sig_at_t)(31 downto 0);
end property;

property SECTION_B_2_read_11 is
dependencies: no_reset;
freeze:
	sharded_in_sig_at_t = sharded_in_sig@t,
	shared_at_t = shared@t,
	succ_at_t = succ@t,
	val_at_t = val@t;
assume: 
	 at t: SECTION_B_2;
	 at t: not(s_in_sync);
	 at t: not(s_in2_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: s_out_sig = ((2 * val_at_t)(31 downto 0) + shared_at_t)(31 downto 0);
	 at t+1: shared = sharded_in_sig_at_t;
	 at t+1: succ = succ_at_t;
	 at t+1: val = (2 * val_at_t)(31 downto 0);
end property;