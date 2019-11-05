-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro TX_flags_out_notify : boolean := end macro;
--macro TX_pin_notify : boolean := end macro;


global trigger : rose(clk);

-- DP SIGNALS --
macro TX_flags_out_sig : unsigned := TX_flags_out end macro;

macro TX_pin_sig : unsigned := TX_pin & prev(TX_pin, 1) & prev(TX_pin, 2) & prev(TX_pin, 3) & prev(TX_pin, 4) & prev(TX_pin, 5)
 & prev(TX_pin, 6) & prev(TX_pin, 7) & prev(TX_pin, 8) & prev(TX_pin, 9) & prev(TX_pin, 10) end macro;



macro tx_from_ctrl_sig_r_act : reg_action := tx_from_ctrl.r_act end macro;
macro tx_from_ctrl_sig_tx_reg : unsigned := tx_from_ctrl.tx_reg end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro TX_shiftreg : unsigned := TX_shiftreg_signal end macro;


-- STATES --
macro IDLE_0 : boolean :=
section = IDLE1
end macro;
macro IDLE_1 : boolean :=
section = IDLE2
end macro;
macro SEND_2 : boolean :=
section = SEND
end macro;
macro START_3 : boolean :=
section = START
end macro;
macro STOP_4 : boolean :=
section = STOP
end macro;



-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_0;
	 at t: TX_shiftreg = resize(0,32);
	 at t: TX_flags_out_notify = false;
	 at t: TX_pin_notify = false;
end property;


property IDLE_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t;
assume:
	at t: IDLE_0;
	at t: not((tx_from_ctrl_sig_r_act = TX_WR));
prove:
	at t_end: IDLE_0;
	at t_end: TX_shiftreg = TX_shiftreg_at_t;
	during[t+1, t_end]: TX_flags_out_notify = false;
	during[t+1, t_end]: TX_pin_notify = false;
end property;


property IDLE_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	tx_from_ctrl_sig_tx_reg_at_t = tx_from_ctrl_sig_tx_reg@t;
assume:
	at t: IDLE_0;
	at t: (tx_from_ctrl_sig_r_act = TX_WR);
prove:
	at t_end: IDLE_1;
	at t_end: TX_flags_out_sig = 1;
	at t_end: TX_shiftreg = (tx_from_ctrl_sig_tx_reg_at_t and 2047);
	during[t+1, t_end-1]: TX_flags_out_notify = false;
	at t_end: TX_flags_out_notify = true;
	during[t+1, t_end]: TX_pin_notify = false;
end property;


property IDLE_1_write_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t;
assume:
	at t: IDLE_1;
prove:
	at t_end: START_3;
	at t_end: TX_shiftreg = TX_shiftreg_at_t;
	during[t+1, t_end]: TX_flags_out_notify = false;
	during[t+1, t_end]: TX_pin_notify = false;
end property;


property SEND_2_write_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t;
assume:
	at t: SEND_2;
prove:
	at t_end: STOP_4;
	at t_end: TX_flags_out_sig = 2;
	at t_end: TX_shiftreg = TX_shiftreg_at_t;
	during[t+1, t_end-1]: TX_flags_out_notify = false;
	at t_end: TX_flags_out_notify = true;
	during[t+1, t_end]: TX_pin_notify = false;
end property;


property START_3_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+11;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t;
assume:
	at t: START_3;
prove:
	at t_end: SEND_2;
	at t_end: TX_pin_sig = TX_shiftreg_at_t;
	at t_end: TX_shiftreg = TX_shiftreg_at_t;
	during[t+1, t_end]: TX_flags_out_notify = false;
	during[t+1, t_end-1]: TX_pin_notify = false;
	at t_end: TX_pin_notify = true;
end property;


property STOP_4_write_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	TX_shiftreg_at_t = TX_shiftreg@t;
assume:
	at t: STOP_4;
prove:
	at t_end: IDLE_0;
	at t_end: TX_shiftreg = TX_shiftreg_at_t;
	during[t+1, t_end]: TX_flags_out_notify = false;
	during[t+1, t_end]: TX_pin_notify = false;
end property;

