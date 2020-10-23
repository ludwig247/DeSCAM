-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro COtoME_port_notify :  boolean  := end macro; 
macro COtoME_port_sync   :  boolean  := end macro; 
macro MEIP_port_notify :  boolean  := end macro; 
macro MEIP_port_sync   :  boolean  := end macro; 
macro MEtoCO_port_notify :  boolean  := end macro; 
macro MEtoCO_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro COtoME_port_sig_addrIn : unsigned := end macro; 
macro COtoME_port_sig_dataIn : unsigned := end macro; 
macro COtoME_port_sig_mask : ME_MaskType := end macro; 
macro COtoME_port_sig_req : ME_AccessType := end macro; 
macro MEIP_port_sig : bool := end macro; 
macro MEtoCO_port_sig_loadedData : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro ClaimComplete : unsigned := end macro; 
macro Interrupt_enables : unsigned := end macro; 
macro MEtoCP_data_loadedData : unsigned := end macro; 
macro Pending_reg : unsigned := end macro; 
macro Priority_reg : unsigned := end macro; 
macro Threshold : unsigned := end macro; 


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
	 at t: run_3;
	 at t: ClaimComplete = resize(0,32);
	 at t: Interrupt_enables = resize(0,32);
	 at t: MEIP_port_sig = false;
	 at t: MEtoCP_data_loadedData = resize(0,32);
	 at t: Pending_reg = resize(0,32);
	 at t: Priority_reg = resize(0,32);
	 at t: Threshold = resize(0,32);
	 at t: COtoME_port_notify = false;
	 at t: MEIP_port_notify = true;
	 at t: MEtoCO_port_notify = false;
end property;


property run_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_0;
	 at t: MEIP_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_0;
	 at t: not(MEIP_port_sync);
prove:
	 at t_end: run_1;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: not((Priority_reg <= Threshold));
	 at t: not(COtoME_port_sync);
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: not((Priority_reg <= Threshold));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_dataIn <= Threshold));
	 at t: (COtoME_port_sig_addrIn = resize(1073741824,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = COtoME_port_sig_dataIn_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((Priority_reg <= Threshold));
	 at t: (COtoME_port_sig_addrIn = resize(1073742080,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = COtoME_port_sig_dataIn_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((Priority_reg <= Threshold));
	 at t: (COtoME_port_sig_addrIn = resize(1073742336,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = COtoME_port_sig_dataIn_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(1073741824,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742080,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742336,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073741828,32)));
	 at t: not((Priority_reg <= Threshold));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((Priority_reg <= Threshold));
	 at t: (COtoME_port_sig_addrIn = resize(1073741828,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = COtoME_port_sig_dataIn_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(1073741824,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = Priority_reg_at_t;
	 at t_end: MEtoCP_data_loadedData = Priority_reg_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
end property;

property run_1_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(1073742080,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = Pending_reg_at_t;
	 at t_end: MEtoCP_data_loadedData = Pending_reg_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
end property;

property run_1_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(1073742336,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = Interrupt_enables_at_t;
	 at t_end: MEtoCP_data_loadedData = Interrupt_enables_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
end property;

property run_1_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: not((COtoME_port_sig_addrIn = resize(1073741824,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742080,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742336,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073741828,32)));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
end property;

property run_1_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_RD);
	 at t: (COtoME_port_sig_addrIn = resize(1073741828,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_2;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCO_port_sig_loadedData = ClaimComplete_at_t;
	 at t_end: MEtoCP_data_loadedData = ClaimComplete_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end-1]: MEtoCO_port_notify = false;
	 at t_end: MEtoCO_port_notify = true;
end property;

property run_1_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: (Priority_reg <= Threshold);
	 at t: not(COtoME_port_sync);
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: not((COtoME_port_sig_req = ME_RD));
	 at t: not((COtoME_port_sig_req = ME_WR));
	 at t: (Priority_reg <= Threshold);
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (COtoME_port_sig_dataIn <= Threshold);
	 at t: (COtoME_port_sig_addrIn = resize(1073741824,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = COtoME_port_sig_dataIn_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (Priority_reg <= Threshold);
	 at t: (COtoME_port_sig_addrIn = resize(1073742080,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = COtoME_port_sig_dataIn_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	ClaimComplete_at_t = ClaimComplete@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (Priority_reg <= Threshold);
	 at t: (COtoME_port_sig_addrIn = resize(1073742336,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = COtoME_port_sig_dataIn_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: not((COtoME_port_sig_addrIn = resize(1073741824,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742080,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073742336,32)));
	 at t: not((COtoME_port_sig_addrIn = resize(1073741828,32)));
	 at t: (Priority_reg <= Threshold);
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_1_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	COtoME_port_sig_dataIn_at_t = COtoME_port_sig_dataIn@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_1;
	 at t: COtoME_port_sync;
	 at t: (COtoME_port_sig_req = ME_WR);
	 at t: (Priority_reg <= Threshold);
	 at t: (COtoME_port_sig_addrIn = resize(1073741828,32));
	 at t: COtoME_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = COtoME_port_sig_dataIn_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_2_write_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_2;
	 at t: not((Priority_reg <= Threshold));
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_0;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = true;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_2_write_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_2;
	 at t: (Priority_reg <= Threshold);
	 at t: MEtoCO_port_sync;
prove:
	 at t_end: run_3;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEIP_port_sig = false;
	 at t_end: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end]: COtoME_port_notify = false;
	 during[t+1, t_end-1]: MEIP_port_notify = false;
	 at t_end: MEIP_port_notify = true;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_3_write_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_3;
	 at t: MEIP_port_sync;
prove:
	 at t_end: run_1;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property run_3_write_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_3;
	 at t: not(MEIP_port_sync);
prove:
	 at t_end: run_1;
	 at t_end: ClaimComplete = ClaimComplete_at_t;
	 at t_end: Interrupt_enables = Interrupt_enables_at_t;
	 at t_end: MEtoCP_data_loadedData = 0;
	 at t_end: Pending_reg = Pending_reg_at_t;
	 at t_end: Priority_reg = Priority_reg_at_t;
	 at t_end: Threshold = Threshold_at_t;
	 during[t+1, t_end-1]: COtoME_port_notify = false;
	 at t_end: COtoME_port_notify = true;
	 during[t+1, t_end]: MEIP_port_notify = false;
	 during[t+1, t_end]: MEtoCO_port_notify = false;
end property;

property wait_run_2 is
dependencies: no_reset;
freeze:
	ClaimComplete_at_t = ClaimComplete@t,
	Interrupt_enables_at_t = Interrupt_enables@t,
	MEtoCP_data_loadedData_at_t = MEtoCP_data_loadedData@t,
	Pending_reg_at_t = Pending_reg@t,
	Priority_reg_at_t = Priority_reg@t,
	Threshold_at_t = Threshold@t;
assume: 
	 at t: run_2;
	 at t: not(MEtoCO_port_sync);
prove:
	 at t+1: run_2;
	 at t+1: ClaimComplete = ClaimComplete_at_t;
	 at t+1: Interrupt_enables = Interrupt_enables_at_t;
	 at t+1: MEtoCO_port_sig_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: MEtoCP_data_loadedData = MEtoCP_data_loadedData_at_t;
	 at t+1: Pending_reg = Pending_reg_at_t;
	 at t+1: Priority_reg = Priority_reg_at_t;
	 at t+1: Threshold = Threshold_at_t;
	 at t+1: COtoME_port_notify = false;
	 at t+1: MEIP_port_notify = false;
	 at t+1: MEtoCO_port_notify = true;
end property;