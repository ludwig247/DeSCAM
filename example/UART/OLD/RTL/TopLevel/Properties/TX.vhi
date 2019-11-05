-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro TX_flags_out_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro Parity_control_in_sig : unsigned := Parity_control_in end macro; 
macro TE_flag_in_sig : unsigned := TE_flag_in end macro; 
macro TX_flags_out_sig_tc_flag : tx_flags := TX_flags_out.tc_flag end macro; 
macro TX_flags_out_sig_txe_flag : tx_flags := TX_flags_out.txe_flag end macro; 
macro TX_pin_sig : boolean := TX_pin end macro; 
macro TX_reg_to_shiftreg_sig_TX_temp_register : unsigned := TX_reg_to_shiftreg.TX_temp_register end macro; 
macro TX_reg_to_shiftreg_sig_r_act : reg_action := TX_reg_to_shiftreg.r_act end macro; 
macro baudrate_in_sig : boolean := baudrate_in end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro TX_shiftreg : unsigned := TX_shiftreg_signal end macro; 
macro bitcounter : unsigned := bitcounter_signal end macro; 
macro regs_TX_temp_register : unsigned := regs_signal.TX_temp_register end macro; 
macro regs_r_act : reg_action := regs_signal.r_act end macro; 
macro shiftcounter : unsigned := shiftcounter_signal end macro; 


-- STATES -- 
macro IDLE_0 : boolean :=
section = IDLE1
end macro;
macro IDLE_1 : boolean :=
section = IDLE2
end macro;
macro PARITY_2 : boolean :=
section = PARITY
end macro;
macro SEND_3 : boolean :=
section = SEND
end macro;
macro START_4 : boolean :=
section = START
end macro;
macro STOP_5 : boolean :=
section = STOP1
end macro;
macro STOP_6 : boolean :=
section = STOP2
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_0;
	 at t: TX_pin_sig = true;
	 at t: TX_shiftreg = resize(0,32);
	 at t: bitcounter = resize(0,32);
	 at t: regs_TX_temp_register = resize(0,32);
	 at t: regs_r_act = CR_RD;
	 at t: shiftcounter = resize(0,32);
	 at t: TX_flags_out_notify = false;
end property;


property IDLE_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_reg_to_shiftreg_sig_TX_temp_register_at_t = TX_reg_to_shiftreg_sig_TX_temp_register@t,
	TX_reg_to_shiftreg_sig_r_act_at_t = TX_reg_to_shiftreg_sig_r_act@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: IDLE_0;
	 at t: not((TX_reg_to_shiftreg_sig_r_act = TX_WR));
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = TX_reg_to_shiftreg_sig_TX_temp_register_at_t;
	 at t_end: regs_r_act = TX_reg_to_shiftreg_sig_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property IDLE_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_reg_to_shiftreg_sig_TX_temp_register_at_t = TX_reg_to_shiftreg_sig_TX_temp_register@t,
	TX_reg_to_shiftreg_sig_r_act_at_t = TX_reg_to_shiftreg_sig_r_act@t;
assume: 
	 at t: IDLE_0;
	 at t: (TE_flag_in_sig = resize(0,32));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = TX_reg_to_shiftreg_sig_TX_temp_register_at_t;
	 at t_end: regs_r_act = TX_reg_to_shiftreg_sig_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property IDLE_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_reg_to_shiftreg_sig_TX_temp_register_at_t = TX_reg_to_shiftreg_sig_TX_temp_register@t,
	TX_reg_to_shiftreg_sig_r_act_at_t = TX_reg_to_shiftreg_sig_r_act@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: IDLE_0;
	 at t: not((TE_flag_in_sig = resize(0,32)));
	 at t: (TX_reg_to_shiftreg_sig_r_act = TX_WR);
prove:
	 at t_end: IDLE_1;
	 at t_end: TX_flags_out_sig_tc_flag = RESET;
	 at t_end: TX_flags_out_sig_txe_flag = SET;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = TX_reg_to_shiftreg_sig_TX_temp_register_at_t;
	 at t_end: regs_r_act = TX_reg_to_shiftreg_sig_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end-1]: TX_flags_out_notify = false;
	 at t_end: TX_flags_out_notify = true;
end property;

property IDLE_1_write_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: IDLE_1;
prove:
	 at t_end: START_4;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = regs_TX_temp_register_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property PARITY_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: PARITY_2;
	 at t: (TE_flag_in_sig = resize(0,32));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property PARITY_2_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_2;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: PARITY_2;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property PARITY_2_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_2;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_in_sig = resize(0,32)));
	 at t: not((parity_bit(Parity_control_in_sig,bitcounter) = resize(0,32)));
prove:
	 at t_end: STOP_5;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property PARITY_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: PARITY_2;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_in_sig = resize(0,32)));
	 at t: (parity_bit(Parity_control_in_sig,bitcounter) = resize(0,32));
prove:
	 at t_end: STOP_5;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: SEND_3;
	 at t: (TE_flag_in_sig = resize(0,32));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: not(((TX_shiftreg and resize(1,32)) /= resize(0,32)));
	 at t: ((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32));
	 at t: (Parity_control_in_sig /= resize(0,32));
prove:
	 at t_end: PARITY_2;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: ((TX_shiftreg and resize(1,32)) /= resize(0,32));
	 at t: ((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32));
	 at t: (Parity_control_in_sig /= resize(0,32));
prove:
	 at t_end: PARITY_2;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = (bitcounter_at_t + 1)(31 downto 0);
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: SEND_3;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: SEND_3;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: not(((TX_shiftreg and resize(1,32)) /= resize(0,32)));
	 at t: not(((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32)));
prove:
	 at t_end: SEND_3;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(31 downto 0);
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: ((TX_shiftreg and resize(1,32)) /= resize(0,32));
	 at t: not(((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32)));
prove:
	 at t_end: SEND_3;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = (bitcounter_at_t + 1)(31 downto 0);
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = (shiftcounter_at_t + 1)(31 downto 0);
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: not(((TX_shiftreg and resize(1,32)) /= resize(0,32)));
	 at t: ((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32));
	 at t: not((Parity_control_in_sig /= resize(0,32)));
prove:
	 at t_end: STOP_5;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property SEND_3_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: SEND_3;
	 at t: (baudrate_in_sig and (TE_flag_in_sig /= resize(0,32)));
	 at t: ((TX_shiftreg and resize(1,32)) /= resize(0,32));
	 at t: ((shiftcounter + resize(1,32))(31 downto 0) = resize(8,32));
	 at t: not((Parity_control_in_sig /= resize(0,32)));
prove:
	 at t_end: STOP_5;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = (shift_right(TX_shiftreg_at_t,1));
	 at t_end: bitcounter = (bitcounter_at_t + 1)(31 downto 0);
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property START_4_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: START_4;
	 at t: (TE_flag_in_sig = resize(0,32));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property START_4_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: START_4;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: SEND_3;
	 at t_end: TX_pin_sig = false;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property START_4_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: START_4;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: START_4;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property STOP_5_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t;
assume: 
	 at t: STOP_5;
	 at t: (TE_flag_in_sig = resize(0,32));
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = 0;
	 at t_end: bitcounter = 0;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = 0;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property STOP_5_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_5;
	 at t: not(baudrate_in_sig);
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: STOP_5;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;

property STOP_5_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_5;
	 at t: baudrate_in_sig;
	 at t: not((TE_flag_in_sig = resize(0,32)));
prove:
	 at t_end: STOP_6;
	 at t_end: TX_flags_out_sig_tc_flag = SET;
	 at t_end: TX_flags_out_sig_txe_flag = NF;
	 at t_end: TX_pin_sig = true;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end-1]: TX_flags_out_notify = false;
	 at t_end: TX_flags_out_notify = true;
end property;

property STOP_6_write_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	TX_pin_sig_at_t = TX_pin_sig@t,
	TX_shiftreg_at_t = TX_shiftreg@t,
	bitcounter_at_t = bitcounter@t,
	regs_TX_temp_register_at_t = regs_TX_temp_register@t,
	regs_r_act_at_t = regs_r_act@t,
	shiftcounter_at_t = shiftcounter@t;
assume: 
	 at t: STOP_6;
prove:
	 at t_end: IDLE_0;
	 at t_end: TX_pin_sig = TX_pin_sig_at_t;
	 at t_end: TX_shiftreg = TX_shiftreg_at_t;
	 at t_end: bitcounter = bitcounter_at_t;
	 at t_end: regs_TX_temp_register = regs_TX_temp_register_at_t;
	 at t_end: regs_r_act = regs_r_act_at_t;
	 at t_end: shiftcounter = shiftcounter_at_t;
	 during[t+1, t_end]: TX_flags_out_notify = false;
end property;