-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
--macro TX_flags_in_sync : boolean := end macro;
--macro ctrl_from_rx_sync : boolean := end macro;
--macro req_from_mem_sync : boolean := end macro;
--macro interrupt_notify : boolean := end macro;


-- DP SIGNALS --
macro TX_flags_in_sig : unsigned := TX_flags_in end macro;
macro ctrl_from_rx_sig_DR_reg : unsigned := ctrl_from_rx.DR_reg end macro;
macro ctrl_from_rx_sig_SR_reg : unsigned := ctrl_from_rx.SR_reg end macro;
macro ctrl_to_tx_sig_r_act : reg_action := ctrl_to_tx.r_act end macro;
macro ctrl_to_tx_sig_tx_reg : unsigned := ctrl_to_tx.tx_reg end macro;
macro interrupt_sig : boolean := interrupt end macro;
macro req_from_mem_sig_addrIn : unsigned := req_from_mem.addrIn end macro;
macro req_from_mem_sig_dataIn : unsigned := req_from_mem.dataIn end macro;
macro req_from_mem_sig_mask : ME_MaskType := req_from_mem.mask end macro;
macro req_from_mem_sig_req : ME_AccessType := req_from_mem.req end macro;
macro resp_to_mem_sig_CR_reg : unsigned := resp_to_mem.CR_reg end macro;
macro resp_to_mem_sig_DR_reg : unsigned := resp_to_mem.DR_reg end macro;
macro resp_to_mem_sig_SR_reg : unsigned := resp_to_mem.SR_reg end macro;


-- CONSTRAINTS --
constraint no_reset := rst = '0'; end constraint;


-- VISIBLE REGISTERS --
macro regs_CR_reg : unsigned := regs_signal.CR_reg end macro;
macro regs_DR_reg : unsigned := regs_signal.DR_reg end macro;
macro regs_SR_reg : unsigned := regs_signal.SR_reg end macro;
macro tx_temp_r_act : reg_action := tx_temp_signal.r_act end macro;
macro tx_temp_tx_reg : unsigned := tx_temp_signal.tx_reg end macro;


-- STATES --
macro RUN_0 : boolean :=
section = RUN
end macro;


-- OPERATIONS --
property reset is
assume:
	 reset_sequence;
prove:
	 at t: RUN_0;
	 at t: regs_CR_reg = resize(0,32);
	 at t: regs_DR_reg = resize(0,32);
	 at t: regs_SR_reg = resize(32,32);
	 at t: tx_temp_r_act = NA;
	 at t: tx_temp_tx_reg = resize(0,32);
	 at t: interrupt_notify = false;
end property;


property RUN_0_read_0 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: TX_flags_in_sync;
	at t: (check_interrupt(regs_CR_reg,manage_TX_flags(regs_SR_reg,TX_flags_in_sig)) = resize(0,32));
	at t: not(req_from_mem_sync);
	at t: not(ctrl_from_rx_sync);
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = regs_DR_reg_at_t;
	at t+1: regs_SR_reg = manage_TX_flags(regs_SR_reg_at_t,TX_flags_in_sig_at_t);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = regs_DR_reg_at_t;
	at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(regs_SR_reg_at_t,TX_flags_in_sig_at_t);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_temp_r_act_at_t,tx_temp_tx_reg_at_t);
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_1 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: TX_flags_in_sync;
	at t: not((check_interrupt(regs_CR_reg,manage_TX_flags(regs_SR_reg,TX_flags_in_sig)) = resize(0,32)));
	at t: not(req_from_mem_sync);
	at t: not(ctrl_from_rx_sync);
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = regs_DR_reg_at_t;
	at t+1: regs_SR_reg = (manage_TX_flags(regs_SR_reg_at_t,TX_flags_in_sig_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = regs_DR_reg_at_t;
	at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(regs_SR_reg_at_t,TX_flags_in_sig_at_t) or 2);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_temp_r_act_at_t,tx_temp_tx_reg_at_t);
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_2 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: (check_interrupt(regs_CR_reg,regs_SR_reg) = resize(0,32));
	at t: not(req_from_mem_sync);
	at t: not(ctrl_from_rx_sync);
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = regs_DR_reg_at_t;
	at t+1: regs_SR_reg = regs_SR_reg_at_t;
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = regs_DR_reg_at_t;
	at t+1: resp_to_mem_sig_SR_reg = regs_SR_reg_at_t;
	at t+1: tx_temp_r_act = tx_temp_r_act_at_t;
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_3 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: not((check_interrupt(regs_CR_reg,regs_SR_reg) = resize(0,32)));
	at t: not(req_from_mem_sync);
	at t: not(ctrl_from_rx_sync);
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = regs_DR_reg_at_t;
	at t+1: regs_SR_reg = (regs_SR_reg_at_t or 2);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = regs_DR_reg_at_t;
	at t+1: resp_to_mem_sig_SR_reg = (regs_SR_reg_at_t or 2);
	at t+1: tx_temp_r_act = tx_temp_r_act_at_t;
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_4 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
	at t: (check_interrupt(regs_CR_reg,manage_TX_flags(manage_RX_flags(regs_SR_reg,ctrl_from_rx_sig_SR_reg),TX_flags_in_sig)) = resize(0,32));
	at t: not(req_from_mem_sync);
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_temp_r_act_at_t,tx_temp_tx_reg_at_t);
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_5 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
	at t: not((check_interrupt(regs_CR_reg,manage_TX_flags(manage_RX_flags(regs_SR_reg,ctrl_from_rx_sig_SR_reg),TX_flags_in_sig)) = resize(0,32)));
	at t: not(req_from_mem_sync);
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_temp_r_act_at_t,tx_temp_tx_reg_at_t);
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_6 is
dependencies: no_reset;
freeze:
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: ctrl_from_rx_sync;
	at t: (check_interrupt(regs_CR_reg,manage_RX_flags(regs_SR_reg,ctrl_from_rx_sig_SR_reg)) = resize(0,32));
	at t: not(req_from_mem_sync);
	at t: ctrl_from_rx_sync;
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: tx_temp_r_act = tx_temp_r_act_at_t;
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_7 is
dependencies: no_reset;
freeze:
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t,
	tx_temp_tx_reg_at_t = tx_temp_tx_reg@t;
assume:
	at t: RUN_0;
	at t: ctrl_from_rx_sync;
	at t: not((check_interrupt(regs_CR_reg,manage_RX_flags(regs_SR_reg,ctrl_from_rx_sig_SR_reg)) = resize(0,32)));
	at t: not(req_from_mem_sync);
	at t: ctrl_from_rx_sync;
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_temp_r_act_at_t;
	at t+1: ctrl_to_tx_sig_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = regs_CR_reg_at_t;
	at t+1: regs_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = (manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = regs_CR_reg_at_t;
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(regs_DR_reg_at_t,ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (manage_RX_flags(regs_SR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t) or 2);
	at t+1: tx_temp_r_act = tx_temp_r_act_at_t;
	at t+1: tx_temp_tx_reg = tx_temp_tx_reg_at_t;
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_8 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: TX_flags_in_sync;
	at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),TX_flags_in_sig)) = resize(0,32));
	at t: req_from_mem_sync;
	at t: not(ctrl_from_rx_sync);
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_SR_reg = manage_TX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),TX_flags_in_sig_at_t);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),TX_flags_in_sig_at_t);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),set_tx(req_from_mem_sig_dataIn_at_t));
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_9 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: TX_flags_in_sync;
	at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),TX_flags_in_sig)) = resize(0,32)));
	at t: req_from_mem_sync;
	at t: not(ctrl_from_rx_sync);
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_SR_reg = (manage_TX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),set_tx(req_from_mem_sig_dataIn_at_t));
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_10 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req)) = resize(0,32));
	at t: req_from_mem_sync;
	at t: not(ctrl_from_rx_sync);
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_SR_reg = register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_SR_reg = register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: tx_temp_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_11 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req)) = resize(0,32)));
	at t: req_from_mem_sync;
	at t: not(ctrl_from_rx_sync);
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_SR_reg = (register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t) or 2);
	at t+1: tx_temp_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_12 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
	at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),ctrl_from_rx_sig_SR_reg),TX_flags_in_sig)) = resize(0,32));
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),set_tx(req_from_mem_sig_dataIn_at_t));
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_13 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_at_t = TX_flags_in_sig@t,
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
	at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),ctrl_from_rx_sig_SR_reg),TX_flags_in_sig)) = resize(0,32)));
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: TX_flags_in_sync;
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t),TX_flags_in_sig_at_t) or 2);
	at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_at_t,tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),set_tx(req_from_mem_sig_dataIn_at_t));
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = true;
end property;


property RUN_0_read_14 is
dependencies: no_reset;
freeze:
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),ctrl_from_rx_sig_SR_reg)) = resize(0,32));
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: tx_temp_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = false;
end property;


property RUN_0_read_15 is
dependencies: no_reset;
freeze:
	ctrl_from_rx_sig_DR_reg_at_t = ctrl_from_rx_sig_DR_reg@t,
	ctrl_from_rx_sig_SR_reg_at_t = ctrl_from_rx_sig_SR_reg@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume:
	at t: RUN_0;
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),ctrl_from_rx_sig_SR_reg)) = resize(0,32)));
	at t: req_from_mem_sync;
	at t: ctrl_from_rx_sync;
	at t: not(TX_flags_in_sync);
prove:
	at t+1: RUN_0;
	at t+1: ctrl_to_tx_sig_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: ctrl_to_tx_sig_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_sig = true;
	at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: regs_SR_reg = (manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t) or 2);
	at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_DR_reg_at_t,ctrl_from_rx_sig_SR_reg_at_t);
	at t+1: resp_to_mem_sig_SR_reg = (manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),ctrl_from_rx_sig_SR_reg_at_t) or 2);
	at t+1: tx_temp_r_act = tx_action(tx_temp_r_act_at_t,set_tx(req_from_mem_sig_dataIn_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	at t+1: tx_temp_tx_reg = set_tx(req_from_mem_sig_dataIn_at_t);
	at t+1: interrupt_notify = true;
end property;


