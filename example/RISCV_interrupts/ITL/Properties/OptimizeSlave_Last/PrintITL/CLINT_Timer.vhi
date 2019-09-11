-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 


-- DP SIGNALS -- 
macro toMemory_H_sig : unsigned := end macro; 
macro toMemory_L_sig : unsigned := end macro; 
macro toTimerStatus_H_sig : unsigned := end macro; 
macro toTimerStatus_L_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro mtimeH : unsigned := end macro; 
macro mtimeL : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: mtimeH = resize(0,32);
	 at t: mtimeL = resize(0,32);
	 at t: toMemory_L_sig = resize(0,32);
end property;


property run_0_write_0 is
dependencies: no_reset;
freeze:
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t;
assume: 
	 at t: run_0;
	 at t: not((mtimeL = resize(4294967295,32)));
	 at t: not((mtimeL = resize(4294967294,32)));
prove:
	 at t+1: run_0;
	 at t+1: mtimeH = mtimeH_at_t;
	 at t+1: mtimeL = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toMemory_H_sig = mtimeH_at_t;
	 at t+1: toMemory_L_sig = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toTimerStatus_H_sig = mtimeH_at_t;
	 at t+1: toTimerStatus_L_sig = (1 + mtimeL_at_t)(31 downto 0);
end property;

property run_0_write_1 is
dependencies: no_reset;
freeze:
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t;
assume: 
	 at t: run_0;
	 at t: (mtimeL = resize(4294967294,32));
prove:
	 at t+1: run_0;
	 at t+1: mtimeH = (1 + mtimeH_at_t)(31 downto 0);
	 at t+1: mtimeL = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toMemory_H_sig = mtimeH_at_t;
	 at t+1: toMemory_L_sig = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toTimerStatus_H_sig = mtimeH_at_t;
	 at t+1: toTimerStatus_L_sig = (1 + mtimeL_at_t)(31 downto 0);
end property;

property run_0_write_2 is
dependencies: no_reset;
freeze:
	mtimeH_at_t = mtimeH@t,
	mtimeL_at_t = mtimeL@t;
assume: 
	 at t: run_0;
	 at t: (mtimeL = resize(4294967295,32));
prove:
	 at t+1: run_0;
	 at t+1: mtimeH = (1 + mtimeH_at_t)(31 downto 0);
	 at t+1: mtimeL = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toMemory_H_sig = (1 + mtimeH_at_t)(31 downto 0);
	 at t+1: toMemory_L_sig = (2 + mtimeL_at_t)(31 downto 0);
	 at t+1: toTimerStatus_H_sig = (1 + mtimeH_at_t)(31 downto 0);
	 at t+1: toTimerStatus_L_sig = (1 + mtimeL_at_t)(31 downto 0);
end property;