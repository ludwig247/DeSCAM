-- DP SIGNALS -- 
macro TE_flag_trans_sig : unsigned := TE_flag_trans end macro; 
macro TX_pin_sig : boolean := TX_pin end macro; 
macro baudrate_in_sig : boolean := baudrate_in end macro;
macro trans_flags_out_sig : boolean := trans_flags_out end macro; 
macro transfer_data_sig_CR_reg : unsigned := transfer_data.CR_reg end macro; 
macro transfer_data_sig_RX_reg : unsigned := transfer_data.RX_reg end macro; 
macro transfer_data_sig_SR_reg : unsigned := transfer_data.SR_reg end macro; 
macro transfer_data_sig_TX_reg : unsigned := transfer_data.TX_reg end macro; 
macro transfer_data_sig_r_act : reg_action := transfer_data.r_act end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro TX_shiftreg : unsigned := TX_shiftreg_signal end macro; 
macro bitcounter : unsigned := bitcounter_signal end macro; 
macro shiftcounter : unsigned := shiftcounter_signal end macro; 


-- STATES -- 
macro PARITY_0 : boolean := 
      section=PARITY and
      transfer_data_notify = false 
end macro;
macro READ_DATA_1 : boolean := 
      section=READ_DATA 
end macro;
macro SEND_2 : boolean :=  
      section=SEND and
      transfer_data_notify = false
end macro;
macro START_3 : boolean :=  
      section=START and
      transfer_data_notify = false
end macro;
macro STOP_4 : boolean := 
      section=STOP and
      transfer_data_notify = false
end macro;

--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: READ_DATA_1;
	 at t: TX_pin_sig = true;
	 at t: TX_shiftreg = resize(0,8);
	 at t: bitcounter = resize(0,4);
	 at t: shiftcounter = resize(0,4);
	 at t: trans_flags_out_sig = false;
	 at t: transfer_data_notify = true;
end property;


property PARITY_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: PARITY_0;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: PARITY_0;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property PARITY_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: PARITY_0;
	 at t: (TE_flag_trans_sig = resize(0,1));
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property PARITY_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: PARITY_0;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: ((bitcounter mod resize(2,4))(3 downto 0) /= resize(0,4));
prove:
	 at t_end: STOP_4;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property PARITY_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: PARITY_0;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: not(((bitcounter mod resize(2,4))(3 downto 0) /= resize(0,4)));
prove:
	 at t_end: STOP_4;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property READ_DATA_1_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: READ_DATA_1;
	 at t: not((transfer_data_sig_r_act = TX_WR));
	 at t: not((TE_flag_trans_sig = resize(0,1)));
	 at t: transfer_data_sync;
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property READ_DATA_1_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: READ_DATA_1;
	 at t: (TE_flag_trans_sig = resize(0,1));
	 at t: transfer_data_sync;
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property READ_DATA_1_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	transfer_data_sig_TX_reg_at_t = transfer_data_sig_TX_reg@t;
assume: 
	 at t: READ_DATA_1;
	 at t: not((TE_flag_trans_sig = resize(0,1)));
	 at t: (transfer_data_sig_r_act = TX_WR);
	 at t: transfer_data_sync;
prove:
	 at t_end: START_3;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = transfer_data_sig_TX_reg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property SEND_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: SEND_2;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: not(((TX_shiftreg and resize(1,8)) /= resize(0,8)));
	 at t: ((shiftcounter + resize(1,4))(3 downto 0) = resize(8,4));
prove:
	 at t_end: PARITY_0;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property SEND_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: SEND_2;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: ((TX_shiftreg and resize(1,8)) /= resize(0,8));
	 at t: ((shiftcounter + resize(1,4))(3 downto 0) = resize(8,4));
prove:
	 at t_end: PARITY_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = (bitcounter_at_t + 1)(3 downto 0);
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property SEND_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: SEND_2;
	 at t: (TE_flag_trans_sig = resize(0,1));
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property SEND_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: SEND_2;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: SEND_2;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property SEND_2_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: SEND_2;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: not(((TX_shiftreg and resize(1,8)) /= resize(0,8)));
	 at t: not(((shiftcounter + resize(1,4))(3 downto 0) = resize(8,4)));
prove:
	 at t_end: SEND_2;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(3 downto 0);
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property SEND_2_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: SEND_2;
	 at t: (baudrate_in_sig and (TE_flag_trans_sig /= resize(0,1)));
	 at t: ((TX_shiftreg and resize(1,8)) /= resize(0,8));
	 at t: not(((shiftcounter + resize(1,4))(3 downto 0) = resize(8,4)));
prove:
	 at t_end: SEND_2;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = (bitcounter_at_t + 1)(3 downto 0);
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(3 downto 0);
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property START_3_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: START_3;
	 at t: (TE_flag_trans_sig = resize(0,1));
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property START_3_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: START_3;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: SEND_2;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property START_3_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: START_3;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: START_3;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property STOP_4_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_4;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = true;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property STOP_4_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: STOP_4;
	 at t: (TE_flag_trans_sig = resize(0,1));
prove:
	 at t_end: READ_DATA_1;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: shiftcounter = 0;
	 at t_end: trans_flags_out_sig = false;
	 during[t+1, t_end-1]: transfer_data_notify = false;
	 at t_end: transfer_data_notify = true;
end property;

property STOP_4_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: STOP_4;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_trans_sig = resize(0,1)));
prove:
	 at t_end: STOP_4;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 at t_end: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 during[t+1, t_end]: transfer_data_notify = false;
end property;

property wait_READ_DATA_1 is
dependencies: no_reset;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t,
	trans_flags_out_sig_at_t = trans_flags_out_sig@t;
assume: 
	 at t: READ_DATA_1;
	 at t: not(transfer_data_sync);
prove:
	 at t+1: READ_DATA_1;
	 at t+1: TX_pin_sig = TX_pin_sig_at_t;
	 at t+1: TX_shiftreg = TX_shiftreg_at_t;
	 at t+1: bitcounter = bitcounter_at_t;
	 at t+1: shiftcounter = shiftcounter_at_t;
	 at t+1: trans_flags_out_sig = trans_flags_out_sig_at_t;
	 at t+1: transfer_data_notify = true;
end property;