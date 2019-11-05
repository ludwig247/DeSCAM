-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro rx_to_ctrl_notify : boolean := rx_to_ctrl_notify end macro;

global trigger : rose(clk);

-- DP SIGNALS --
macro RX_pin_sig : unsigned :=next(RX_pin, 10) & next(RX_pin, 9) & next(RX_pin, 8) & next(RX_pin, 7) & next(RX_pin, 6)
 & next(RX_pin, 5) & next(RX_pin, 4) & next(RX_pin, 3) & next(RX_pin, 2) & next(RX_pin, 1) & RX_pin end macro;


macro rx_to_ctrl_sig_DR_reg : unsigned := rx_to_ctrl.DR_reg end macro;
macro rx_to_ctrl_sig_SR_reg : unsigned := rx_to_ctrl.SR_reg end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro RX_shiftreg : unsigned := RX_shiftreg_signal end macro;


-- STATES --
macro IDLE_0 : boolean :=
section = IDLE
end macro;
macro RECEIVE_1 : boolean :=
section = RECEIVE 
end macro;
macro SCAN_2 : boolean :=
section = SCAN
end macro;
macro STOP_3 : boolean :=
section = STOP1 
end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: IDLE_0;
	 at t: RX_shiftreg = resize(0,32);
	 at t: rx_to_ctrl_notify = false;
end property;


property IDLE_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t;
assume:
	at t: IDLE_0;
prove:
	at t_end: SCAN_2;
	at t_end: RX_shiftreg = RX_shiftreg_at_t;
	during[t+1, t_end]: rx_to_ctrl_notify = false;
end property;


property RECEIVE_1_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t;
assume:
	at t: RECEIVE_1;
	at t: (parity_check(countones(((shift_right(RX_shiftreg,resize(1,32))) and resize(255,32))),(RX_shiftreg and resize(512,32))) = resize(0,32));
	at t: (frame_check((RX_shiftreg and resize(1024,32))) = resize(0,32));
prove:
	at t_end: STOP_3;
	at t_end: RX_shiftreg = RX_shiftreg_at_t;
	at t_end: rx_to_ctrl_sig_DR_reg = ((shift_left(RX_shiftreg_at_t,7)) and 65280);
	at t_end: rx_to_ctrl_sig_SR_reg = 8;
	during[t+1, t_end-1]: rx_to_ctrl_notify = false;
	at t_end: rx_to_ctrl_notify = true;
end property;


property RECEIVE_1_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t;
assume:
	at t: RECEIVE_1;
	at t: not(((parity_check(countones(((shift_right(RX_shiftreg,resize(1,32))) and resize(255,32))),(RX_shiftreg and resize(512,32))) = resize(0,32)) and (frame_check((RX_shiftreg and resize(1024,32))) = resize(0,32))));
prove:
	at t_end: STOP_3;
	at t_end: RX_shiftreg = RX_shiftreg_at_t;
	at t_end: rx_to_ctrl_sig_DR_reg = ((shift_left(RX_shiftreg_at_t,15)) and 16711680);
	at t_end: rx_to_ctrl_sig_SR_reg = (parity_check(countones(((shift_right(RX_shiftreg_at_t,1)) and 255)),(RX_shiftreg_at_t and 512)) or frame_check((RX_shiftreg_at_t and 1024)));
	during[t+1, t_end-1]: rx_to_ctrl_notify = false;
	at t_end: rx_to_ctrl_notify = true;
end property;


property SCAN_2_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+12;
freeze:
	RX_pin_sig_at_t = RX_pin_sig@t;
assume:
	at t: SCAN_2;
	at t: ((RX_pin_sig and resize(1,32)) = resize(0,32));
prove:
	at t_end: RECEIVE_1;
	at t_end: RX_shiftreg = RX_pin_sig_at_t;
	during[t+1, t_end]: rx_to_ctrl_notify = false;
end property;


property SCAN_2_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t;
assume:
	at t: SCAN_2;
	at t: not(((RX_pin_sig and resize(1,32)) = resize(0,32)));
prove:
	at t_end: SCAN_2;
	at t_end: RX_shiftreg = RX_shiftreg_at_t;
	during[t+1, t_end]: rx_to_ctrl_notify = false;
end property;


property STOP_3_write_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	RX_shiftreg_at_t = RX_shiftreg@t;
assume:
	at t: STOP_3;
prove:
	at t_end: SCAN_2;
	at t_end: RX_shiftreg = RX_shiftreg_at_t;
	during[t+1, t_end]: rx_to_ctrl_notify = false;
end property;



