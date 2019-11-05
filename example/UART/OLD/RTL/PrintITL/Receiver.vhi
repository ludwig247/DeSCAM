-- DP SIGNALS -- 
macro RE_flag_rec_sig : unsigned := RE_flag_rec end macro; 
macro RX_pin_sig : boolean := RX_pin end macro; 
macro baudrate_in_sig : boolean := baudrate_in end macro; 
macro receive_data_sig_CR_reg : unsigned := receive_data.CR_reg end macro; 
macro receive_data_sig_RX_reg : unsigned := receive_data.RX_reg end macro; 
macro receive_data_sig_SR_reg : unsigned := receive_data.SR_reg end macro; 
macro receive_data_sig_TX_reg : unsigned := receive_data.TX_reg end macro; 
macro receive_data_sig_r_act : reg_action := receive_data.r_act end macro; 



--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro RX_shiftreg : unsigned := RX_shiftreg_signal end macro; 
macro bitcounter : unsigned := bitcounter_signal end macro; 
macro regs_CR_reg : unsigned := regs_signal.CR_reg end macro; 
macro regs_RX_reg : unsigned := regs_signal.RX_reg end macro; 
macro regs_SR_reg : unsigned := regs_signal.SR_reg end macro; 
macro regs_TX_reg : unsigned := regs_signal.TX_reg end macro; 
macro regs_r_act : reg_action := regs_signal.r_act end macro; 
macro shiftcounter : unsigned := shiftcounter_signal end macro; 

-- STATES -- 
macro IDLE_0 : boolean :=
section = IDLE and
receive_data_notify = false
end macro;
macro PARITY_1 : boolean := 
section = PARITY and
receive_data_notify = false
end macro;
macro RECEIVE_2 : boolean :=
section = RECEIVE and
receive_data_notify = false
end macro;
macro SCAN_3 : boolean :=
section = SCAN and
receive_data_notify = false
end macro;
macro STOP_4 : boolean :=
section = STOP and
receive_data_notify = false
end macro;
macro WRITE_DATA_5 : boolean :=
section = WRITE_DATA and
receive_data_notify = true
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_0;
	 at t: RX_shiftreg = resize(0,8);
	 at t: bitcounter = resize(0,4);
	 at t: regs_CR_reg = resize(0,32);
	 at t: regs_RX_reg = resize(0,8);
	 at t: regs_SR_reg = resize(0,32);
	 at t: regs_TX_reg = resize(0,8);
	 at t: regs_r_act = NA;
	 at t: shiftcounter = resize(0,4);
	 at t: receive_data_notify = false;
end property;


property IDLE_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t;
assume: 
	 at t: IDLE_0;
	 at t: (RE_flag_rec_sig = resize(0,1));
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = 0;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = NA;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property IDLE_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: IDLE_0;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
prove:
	 at t_end: SCAN_3;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property PARITY_1_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t;
assume: 
	 at t: PARITY_1;
	 at t: (RE_flag_rec_sig = resize(0,1));
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = 0;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = NA;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property PARITY_1_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_1;
	 at t: not(baudrate_in_sig);
	 at t: not((RE_flag_rec_sig = resize(0,1)));
prove:
	 at t_end: PARITY_1;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property PARITY_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_1;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: RX_pin_sig;
	 at t: not(((bitcounter mod resize(2,4))(3 downto 0) = resize(0,4)));
prove:
	 at t_end: STOP_4;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = (regs_SR_reg_at_t or 64);
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property PARITY_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_1;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: not((RX_pin_sig and not(((bitcounter mod resize(2,4))(3 downto 0) = resize(0,4)))));
	 at t: not((not(RX_pin_sig) and ((bitcounter mod resize(2,4))(3 downto 0) = resize(0,4))));
prove:
	 at t_end: STOP_4;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property PARITY_1_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_1;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: not(RX_pin_sig);
	 at t: ((bitcounter mod resize(2,4))(3 downto 0) = resize(0,4));
prove:
	 at t_end: STOP_4;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = (regs_SR_reg_at_t or 64);
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t;
assume: 
	 at t: RECEIVE_2;
	 at t: (RE_flag_rec_sig = resize(0,1));
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = 0;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = NA;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: RECEIVE_2;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: not(RX_pin_sig);
	 at t: (shiftcounter = resize(7,4));
prove:
	 at t_end: PARITY_1;
	 at t_end: RX_shiftreg = (shift_right(RX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: RECEIVE_2;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: RX_pin_sig;
	 at t: (shiftcounter = resize(7,4));
prove:
	 at t_end: PARITY_1;
	 at t_end: RX_shiftreg = ((shift_right(RX_shiftreg_at_t,1)) or 128);
	 at t_end: bitcounter = (bitcounter_at_t + 1)(3 downto 0);
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: RECEIVE_2;
	 at t: not(baudrate_in_sig);
	 at t: not((RE_flag_rec_sig = resize(0,1)));
prove:
	 at t_end: RECEIVE_2;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: RECEIVE_2;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: not(RX_pin_sig);
	 at t: not((shiftcounter = resize(7,4)));
prove:
	 at t_end: RECEIVE_2;
	 at t_end: RX_shiftreg = (shift_right(RX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(3 downto 0);
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property RECEIVE_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: RECEIVE_2;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: RX_pin_sig;
	 at t: not((shiftcounter = resize(7,4)));
prove:
	 at t_end: RECEIVE_2;
	 at t_end: RX_shiftreg = ((shift_right(RX_shiftreg_at_t,1)) or 128);
	 at t_end: bitcounter = (bitcounter_at_t + 1)(3 downto 0);
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(3 downto 0);
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property SCAN_3_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: SCAN_3;
	 at t: not((baudrate_in_sig and not(RX_pin_sig)));
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property SCAN_3_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: SCAN_3;
	 at t: baudrate_in_sig;
	 at t: not(RX_pin_sig);
prove:
	 at t_end: RECEIVE_2;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property STOP_4_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t;
assume: 
	 at t: STOP_4;
	 at t: (RE_flag_rec_sig = resize(0,1));
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = 0;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = NA;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property STOP_4_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_4;
	 at t: not(baudrate_in_sig);
	 at t: not((RE_flag_rec_sig = resize(0,1)));
prove:
	 at t_end: STOP_4;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = regs_SR_reg_at_t;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property STOP_4_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_4;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: RX_pin_sig;
prove:
	 at t_end: WRITE_DATA_5;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: receive_data_sig_CR_reg = regs_CR_reg_at_t;
	 at t_end: receive_data_sig_RX_reg = RX_shiftreg_at_t;
	 at t_end: receive_data_sig_SR_reg = (regs_SR_reg_at_t or 8);
	 at t_end: receive_data_sig_TX_reg = regs_TX_reg_at_t;
	 at t_end: receive_data_sig_r_act = RX_WR;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = RX_shiftreg_at_t;
	 at t_end: regs_SR_reg = (regs_SR_reg_at_t or 8);
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = RX_WR;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end-1]: receive_data_notify = false;
	 at t_end: receive_data_notify = true;
end property;

property STOP_4_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_4;
	 at t: baudrate_in_sig;
	 at t: not((RE_flag_rec_sig = resize(0,1)));
	 at t: not(RX_pin_sig);
prove:
	 at t_end: WRITE_DATA_5;
	 at t_end: RX_shiftreg = RX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: receive_data_sig_CR_reg = regs_CR_reg_at_t;
	 at t_end: receive_data_sig_RX_reg = RX_shiftreg_at_t;
	 at t_end: receive_data_sig_SR_reg = ((regs_SR_reg_at_t or 128) or 8);
	 at t_end: receive_data_sig_TX_reg = regs_TX_reg_at_t;
	 at t_end: receive_data_sig_r_act = RX_WR;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = RX_shiftreg_at_t;
	 at t_end: regs_SR_reg = ((regs_SR_reg_at_t or 128) or 8);
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = RX_WR;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end-1]: receive_data_notify = false;
	 at t_end: receive_data_notify = true;
end property;

property WRITE_DATA_5_write_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: WRITE_DATA_5;
	 at t: receive_data_sync;
prove:
	 at t_end: IDLE_0;
	 at t_end: RX_shiftreg = 0;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_CR_reg = regs_CR_reg_at_t;
	 at t_end: regs_RX_reg = regs_RX_reg_at_t;
	 at t_end: regs_SR_reg = 0;
	 at t_end: regs_TX_reg = regs_TX_reg_at_t;
	 at t_end: regs_r_act = NA;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: receive_data_notify = false;
end property;

property wait_WRITE_DATA_5 is
dependencies: no_reset;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_RX_reg_at_t = regs_RX_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_TX_reg_at_t = regs_TX_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: WRITE_DATA_5;
	 at t: not(receive_data_sync);
prove:
	 at t+1: WRITE_DATA_5;
	 at t+1: RX_shiftreg = RX_shiftreg_at_t;
	 at t+1: bitcounter = bitcounter_at_t;
	 at t+1: receive_data_sig_CR_reg = regs_CR_reg_at_t;
	 at t+1: receive_data_sig_RX_reg = regs_RX_reg_at_t;
	 at t+1: receive_data_sig_SR_reg = regs_SR_reg_at_t;
	 at t+1: receive_data_sig_TX_reg = regs_TX_reg_at_t;
	 at t+1: receive_data_sig_r_act = regs_r_act_at_t;
	 at t+1: regs_CR_reg = regs_CR_reg_at_t;
	 at t+1: regs_RX_reg = regs_RX_reg_at_t;
	 at t+1: regs_SR_reg = regs_SR_reg_at_t;
	 at t+1: regs_TX_reg = regs_TX_reg_at_t;
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: shiftcounter = shiftcounter_at_t;
	 at t+1: receive_data_notify = true;
end property;