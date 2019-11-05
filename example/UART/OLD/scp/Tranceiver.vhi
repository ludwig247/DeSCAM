/--- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro from_mem_if_sync : boolean := end macro;
macro to_mem_if_sync : boolean := end macro;
macro data_out_notify : boolean := end macro;
macro from_mem_if_notify : boolean := end macro;
macro interrupt_out_notify : boolean := end macro;
macro to_mem_if_notify : boolean := end macro;


-- DP SIGNALS --
macro data_in_sig : unsigned := end macro;
macro data_out_sig : unsigned := end macro;
macro from_mem_if_sig_addrIn : unsigned := end macro;
macro from_mem_if_sig_dataIn : unsigned := end macro;
macro from_mem_if_sig_mask : ME_MaskType := end macro;
macro from_mem_if_sig_req : ME_AccessType := end macro;
macro interrupt_out_sig : boolean := end macro;
macro to_mem_if_sig_CR1 : unsigned := end macro;
macro to_mem_if_sig_CR2 : unsigned := end macro;
macro to_mem_if_sig_CR3 : unsigned := end macro;
macro to_mem_if_sig_RX : unsigned := end macro;
macro to_mem_if_sig_SR1 : unsigned := end macro;
macro to_mem_if_sig_SR2 : unsigned := end macro;
macro to_mem_if_sig_SR3 : unsigned := end macro;
macro to_mem_if_sig_TX : unsigned := end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro regs_CR1 : unsigned := end macro;
macro regs_CR2 : unsigned := end macro;
macro regs_CR3 : unsigned := end macro;
macro regs_RX : unsigned := end macro;
macro regs_SR1 : unsigned := end macro;
macro regs_SR2 : unsigned := end macro;
macro regs_SR3 : unsigned := end macro;
macro regs_TX : unsigned := end macro;
macro rx_buffer : unsigned := end macro;


-- STATES --
macro run_0 : boolean := true end macro;
macro run_4 : boolean := true end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: regs_CR1 = resize(0,32);
	 at t: regs_CR2 = resize(0,32);
	 at t: regs_CR3 = resize(0,32);
	 at t: regs_RX = resize(0,32);
	 at t: regs_SR1 = resize(0,32);
	 at t: regs_SR2 = resize(0,32);
	 at t: regs_SR3 = resize(0,32);
	 at t: regs_TX = resize(0,32);
	 at t: rx_buffer = resize(2047,32);
	 at t: data_out_notify = false;
	 at t: from_mem_if_notify = true;
	 at t: interrupt_out_notify = false;
	 at t: to_mem_if_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = regs_SR2_at_t;
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = regs_SR2_at_t;
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: ((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = (((shift_left(regs_TX_at_t,1)) or 512) or 1024);
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = regs_SR2_at_t;
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = regs_SR2_at_t;
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_8 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_9 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_10 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_11 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: ((regs_SR1 and resize(4,32)) /= resize(0,32));
	at t: not(((countones(regs_TX) mod resize(2,32))(31 downto 0) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = ((shift_left(regs_TX_at_t,1)) or 1024);
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1((regs_SR1_at_t and 4294967291),rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_12 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_SR2_at_t,from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_13 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: not((check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32)));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: regs_SR2 = regs_SR2_at_t;
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = regs_SR2_at_t;
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_14 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_15 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: not((regs_SR2 = resize(0,32)));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_16 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	from_mem_if_sig_addrIn_at_t = from_mem_if_sig_addrIn@t,
	from_mem_if_sig_dataIn_at_t = from_mem_if_sig_dataIn@t,
	from_mem_if_sig_mask_at_t = from_mem_if_sig_mask@t,
	from_mem_if_sig_req_at_t = from_mem_if_sig_req@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: from_mem_if_sync;
	at t: from_mem_if_sync;
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: regs_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: regs_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: regs_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: regs_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: regs_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: regs_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: regs_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR1_at_t,from_mem_if_sig_req_at_t,0);
	at t_end: to_mem_if_sig_CR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR2_at_t,from_mem_if_sig_req_at_t,1);
	at t_end: to_mem_if_sig_CR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_CR3_at_t,from_mem_if_sig_req_at_t,2);
	at t_end: to_mem_if_sig_RX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateRx(regs_RX_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,9);
	at t_end: to_mem_if_sig_SR1 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr1(regs_SR1_at_t,rx_buffer_at_t),from_mem_if_sig_req_at_t,4);
	at t_end: to_mem_if_sig_SR2 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,(regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t)),from_mem_if_sig_req_at_t,5);
	at t_end: to_mem_if_sig_SR3 = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,updateSr3(rx_buffer_at_t,regs_SR3_at_t),from_mem_if_sig_req_at_t,6);
	at t_end: to_mem_if_sig_TX = registerop(from_mem_if_sig_addrIn_at_t,from_mem_if_sig_dataIn_at_t,from_mem_if_sig_mask_at_t,regs_TX_at_t,from_mem_if_sig_req_at_t,8);
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_0_read_17 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	data_in_sig_at_t = data_in_sig@t,
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_0;
	at t: (check_interrupt(regs_CR2,regs_SR1,regs_SR2) /= resize(0,32));
	at t: (regs_SR2 = resize(0,32));
	at t: not(((regs_SR1 and resize(4,32)) /= resize(0,32)));
	at t: not(false);
	at t: not(from_mem_if_sync);
prove:
	at t_end: run_4;
	at t_end: data_out_sig = 2047;
	at t_end: interrupt_out_sig = true;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: regs_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: regs_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: regs_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = data_in_sig_at_t;
	at t_end: to_mem_if_sig_CR1 = regs_CR1_at_t;
	at t_end: to_mem_if_sig_CR2 = regs_CR2_at_t;
	at t_end: to_mem_if_sig_CR3 = regs_CR3_at_t;
	at t_end: to_mem_if_sig_RX = updateRx(regs_RX_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR1 = updateSr1(regs_SR1_at_t,rx_buffer_at_t);
	at t_end: to_mem_if_sig_SR2 = (regs_SR2_at_t or (regs_SR1_at_t and regs_CR2_at_t));
	at t_end: to_mem_if_sig_SR3 = updateSr3(rx_buffer_at_t,regs_SR3_at_t);
	at t_end: to_mem_if_sig_TX = regs_TX_at_t;
	during[t+1, t_end-1]: data_out_notify = false;
	at t_end: data_out_notify = true;
	during[t+1, t_end]: from_mem_if_notify = false;
	during[t+1, t_end-1]: interrupt_out_notify = false;
	at t_end: interrupt_out_notify = true;
	during[t+1, t_end-1]: to_mem_if_notify = false;
	at t_end: to_mem_if_notify = true;
end property;


property run_4_write_18 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_4;
	at t: to_mem_if_sync;
prove:
	at t_end: run_0;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = regs_RX_at_t;
	at t_end: regs_SR1 = regs_SR1_at_t;
	at t_end: regs_SR2 = regs_SR2_at_t;
	at t_end: regs_SR3 = regs_SR3_at_t;
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = rx_buffer_at_t;
	during[t+1, t_end]: data_out_notify = false;
	during[t+1, t_end-1]: from_mem_if_notify = false;
	at t_end: from_mem_if_notify = true;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end]: to_mem_if_notify = false;
end property;


property run_4_write_19 is
dependencies: no_reset;
for timepoints:
	t_end = t+1;
freeze:
	regs_CR1_at_t = regs_CR1@t,
	regs_CR2_at_t = regs_CR2@t,
	regs_CR3_at_t = regs_CR3@t,
	regs_RX_at_t = regs_RX@t,
	regs_SR1_at_t = regs_SR1@t,
	regs_SR2_at_t = regs_SR2@t,
	regs_SR3_at_t = regs_SR3@t,
	regs_TX_at_t = regs_TX@t,
	rx_buffer_at_t = rx_buffer@t;
assume:
	at t: run_4;
	at t: not(to_mem_if_sync);
prove:
	at t_end: run_0;
	at t_end: regs_CR1 = regs_CR1_at_t;
	at t_end: regs_CR2 = regs_CR2_at_t;
	at t_end: regs_CR3 = regs_CR3_at_t;
	at t_end: regs_RX = regs_RX_at_t;
	at t_end: regs_SR1 = regs_SR1_at_t;
	at t_end: regs_SR2 = regs_SR2_at_t;
	at t_end: regs_SR3 = regs_SR3_at_t;
	at t_end: regs_TX = regs_TX_at_t;
	at t_end: rx_buffer = rx_buffer_at_t;
	during[t+1, t_end]: data_out_notify = false;
	during[t+1, t_end-1]: from_mem_if_notify = false;
	at t_end: from_mem_if_notify = true;
	during[t+1, t_end]: interrupt_out_notify = false;
	during[t+1, t_end]: to_mem_if_notify = false;
end property;


