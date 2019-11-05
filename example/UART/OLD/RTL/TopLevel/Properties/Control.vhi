-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro TX_flags_in_sync   :  boolean  := end macro; 
--macro interrupt_notify :  boolean  := end macro; 
--macro req_from_mem_sync   :  boolean  := end macro; 
--macro shiftreg_to_RX_reg_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro Baudrate_control_sig : unsigned := Baudrate_control end macro; 
macro Parity_control_RX_sig : unsigned := Parity_control_RX end macro; 
macro Parity_control_TX_sig : unsigned := Parity_control_TX end macro; 
macro RE_flag_out_sig : unsigned := RE_flag_out end macro; 
macro TE_flag_out_sig : unsigned := TE_flag_out end macro; 
macro TX_flags_in_sig_tc_flag : tx_flags := TX_flags_in.tc_flag end macro; 
macro TX_flags_in_sig_txe_flag : tx_flags := TX_flags_in.txe_flag end macro; 
macro TX_reg_to_shiftreg_sig_TX_temp_register : unsigned := TX_reg_to_shiftreg.TX_temp_register end macro; 
macro TX_reg_to_shiftreg_sig_r_act : reg_action := TX_reg_to_shiftreg.r_act end macro; 
macro interrupt_sig : boolean := interrupt end macro; 
macro req_from_mem_sig_addrIn : unsigned := req_from_mem.addrIn end macro; 
macro req_from_mem_sig_dataIn : unsigned := req_from_mem.dataIn end macro; 
macro req_from_mem_sig_mask : ME_MaskType := req_from_mem.mask end macro; 
macro req_from_mem_sig_req : ME_AccessType := req_from_mem.req end macro; 
macro resp_to_mem_sig_CR_reg : unsigned := resp_to_mem.CR_reg end macro; 
macro resp_to_mem_sig_DR_reg : unsigned := resp_to_mem.DR_reg end macro; 
macro resp_to_mem_sig_SR_reg : unsigned := resp_to_mem.SR_reg end macro; 
macro resp_to_mem_sig_r_act : reg_action := resp_to_mem.r_act end macro; 
macro shiftreg_to_RX_reg_sig_CR_reg : unsigned := shiftreg_to_RX_reg.CR_reg end macro; 
macro shiftreg_to_RX_reg_sig_DR_reg : unsigned := shiftreg_to_RX_reg.DR_reg end macro; 
macro shiftreg_to_RX_reg_sig_SR_reg : unsigned := shiftreg_to_RX_reg.SR_reg end macro; 
macro shiftreg_to_RX_reg_sig_r_act : reg_action := shiftreg_to_RX_reg.r_act end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro regs_CR_reg : unsigned := regs_signal.CR_reg end macro; 
macro regs_DR_reg : unsigned := regs_signal.DR_reg end macro; 
macro regs_SR_reg : unsigned := regs_signal.SR_reg end macro; 
macro regs_r_act : reg_action := regs_signal.r_act end macro; 
macro regs2_CR_reg : unsigned := regs2_signal.CR_reg end macro; 
macro regs2_DR_reg : unsigned := regs2_signal.DR_reg end macro; 
macro regs2_SR_reg : unsigned := regs2_signal.SR_reg end macro; 
macro regs2_r_act : reg_action := regs2_signal.r_act end macro; 
macro req_addrIn : unsigned := req_signal.addrIn end macro; 
macro req_dataIn : unsigned := req_signal.dataIn end macro; 
macro req_mask : ME_MaskType := req_signal.mask end macro; 
macro req_req : ME_AccessType := req_signal.req end macro; 
macro tx_flag_tc_flag : tx_flags := tx_flag_signal.tc_flag end macro; 
macro tx_flag_txe_flag : tx_flags := tx_flag_signal.txe_flag end macro; 
macro tx_temp_r_act : reg_action := tx_temp_signal.r_act end macro; 


-- STATES -- 
macro RUN_0 : boolean :=
section = RUN
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: RUN_0;
	 at t: Baudrate_control_sig = resize(0,32);
	 at t: Parity_control_RX_sig = resize(0,32);
	 at t: Parity_control_TX_sig = resize(0,32);
	 at t: RE_flag_out_sig = resize(0,32);
	 at t: TE_flag_out_sig = resize(0,32);
	 at t: regs_CR_reg = resize(0,32);
	 at t: regs_DR_reg = resize(0,32);
	 at t: regs_SR_reg = resize(32,32);
	 at t: regs_r_act = NA;
	 at t: regs2_CR_reg = resize(0,32);
	 at t: regs2_DR_reg = resize(0,32);
	 at t: regs2_SR_reg = resize(0,32);
	 at t: regs2_r_act = NA;
	 at t: req_addrIn = resize(0,32);
	 at t: req_dataIn = resize(0,32);
	 at t: req_mask = MT_B;
	 at t: req_req = ME_X;
	 at t: tx_flag_tc_flag = NF;
	 at t: tx_flag_txe_flag = NF;
	 at t: tx_temp_r_act = CR_RD;
	 at t: interrupt_notify = false;
end property;


property RUN_0_read_0 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32));
	 at t: req_from_mem_sync;
	 at t: TX_flags_in_sync;
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_1 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32));
	 at t: req_from_mem_sync;
	 at t: TX_flags_in_sync;
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_2 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32)));
	 at t: req_from_mem_sync;
	 at t: TX_flags_in_sync;
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_3 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32)));
	 at t: req_from_mem_sync;
	 at t: TX_flags_in_sync;
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_4 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32));
	 at t: req_from_mem_sync;
	 at t: not(TX_flags_in_sync);
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_5 is
dependencies: no_reset;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32));
	 at t: req_from_mem_sync;
	 at t: not(TX_flags_in_sync);
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_6 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32)));
	 at t: req_from_mem_sync;
	 at t: not(TX_flags_in_sync);
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_7 is
dependencies: no_reset;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_from_mem_sig_addrIn_at_t = req_from_mem_sig_addrIn@t,
	req_from_mem_sig_dataIn_at_t = req_from_mem_sig_dataIn@t,
	req_from_mem_sig_mask_at_t = req_from_mem_sig_mask@t,
	req_from_mem_sig_req_at_t = req_from_mem_sig_req@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_from_mem_sig_addrIn,req_from_mem_sig_dataIn,req_from_mem_sig_mask,req_from_mem_sig_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32)));
	 at t: req_from_mem_sync;
	 at t: not(TX_flags_in_sync);
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_from_mem_sig_addrIn_at_t;
	 at t+1: req_dataIn = req_from_mem_sig_dataIn_at_t;
	 at t+1: req_mask = req_from_mem_sig_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t),tx_temp_r_act_at_t,req_from_mem_sig_addrIn_at_t,req_from_mem_sig_dataIn_at_t,req_from_mem_sig_mask_at_t,req_from_mem_sig_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_8 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32));
	 at t: not(req_from_mem_sync);
	 at t: TX_flags_in_sync;
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_9 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32));
	 at t: not(req_from_mem_sync);
	 at t: TX_flags_in_sync;
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_10 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32)));
	 at t: not(req_from_mem_sync);
	 at t: TX_flags_in_sync;
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_11 is
dependencies: no_reset;
freeze:
	TX_flags_in_sig_tc_flag_at_t = TX_flags_in_sig_tc_flag@t,
	TX_flags_in_sig_txe_flag_at_t = TX_flags_in_sig_txe_flag@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),TX_flags_in_sig_tc_flag,TX_flags_in_sig_txe_flag)) = resize(0,32)));
	 at t: not(req_from_mem_sync);
	 at t: TX_flags_in_sync;
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(TX_flags_in_sig_tc_flag_at_t,TX_flags_in_sig_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_12 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32));
	 at t: not(req_from_mem_sync);
	 at t: not(TX_flags_in_sync);
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_13 is
dependencies: no_reset;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: (check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32));
	 at t: not(req_from_mem_sync);
	 at t: not(TX_flags_in_sync);
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = false;
end property;

property RUN_0_read_14 is
dependencies: no_reset;
freeze:
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	shiftreg_to_RX_reg_sig_CR_reg_at_t = shiftreg_to_RX_reg_sig_CR_reg@t,
	shiftreg_to_RX_reg_sig_DR_reg_at_t = shiftreg_to_RX_reg_sig_DR_reg@t,
	shiftreg_to_RX_reg_sig_SR_reg_at_t = shiftreg_to_RX_reg_sig_SR_reg@t,
	shiftreg_to_RX_reg_sig_r_act_at_t = shiftreg_to_RX_reg_sig_r_act@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),shiftreg_to_RX_reg_sig_CR_reg,shiftreg_to_RX_reg_sig_DR_reg,shiftreg_to_RX_reg_sig_SR_reg,shiftreg_to_RX_reg_sig_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32)));
	 at t: not(req_from_mem_sync);
	 at t: not(TX_flags_in_sync);
	 at t: shiftreg_to_RX_reg_sync;
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = shiftreg_to_RX_reg_sig_CR_reg_at_t;
	 at t+1: regs2_DR_reg = shiftreg_to_RX_reg_sig_DR_reg_at_t;
	 at t+1: regs2_SR_reg = shiftreg_to_RX_reg_sig_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),shiftreg_to_RX_reg_sig_CR_reg_at_t,shiftreg_to_RX_reg_sig_DR_reg_at_t,shiftreg_to_RX_reg_sig_SR_reg_at_t,shiftreg_to_RX_reg_sig_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = true;
end property;

property RUN_0_read_15 is
dependencies: no_reset;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_DR_reg_at_t = regs2_DR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs_CR_reg_at_t = regs_CR_reg@t,
	regs_DR_reg_at_t = regs_DR_reg@t,
	regs_SR_reg_at_t = regs_SR_reg@t,
	regs_r_act_at_t = regs_r_act@t,
	req_addrIn_at_t = req_addrIn@t,
	req_dataIn_at_t = req_dataIn@t,
	req_mask_at_t = req_mask@t,
	req_req_at_t = req_req@t,
	tx_flag_tc_flag_at_t = tx_flag_tc_flag@t,
	tx_flag_txe_flag_at_t = tx_flag_txe_flag@t,
	tx_temp_r_act_at_t = tx_temp_r_act@t;
assume: 
	 at t: RUN_0;
	 at t: not((check_interrupt(register_CR_command(regs_CR_reg,req_addrIn,req_dataIn,req_mask,req_req),manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg,req_addrIn,req_dataIn,req_mask,req_req),regs2_CR_reg,regs2_DR_reg,regs2_SR_reg,regs2_r_act),tx_flag_tc_flag,tx_flag_txe_flag)) = resize(0,32)));
	 at t: not(req_from_mem_sync);
	 at t: not(TX_flags_in_sync);
	 at t: not(shiftreg_to_RX_reg_sync);
prove:
	 at t+1: RUN_0;
	 at t+1: Baudrate_control_sig = align_control(65536,regs_CR_reg_at_t);
	 at t+1: Parity_control_RX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: Parity_control_TX_sig = align_control(256,regs_CR_reg_at_t);
	 at t+1: RE_flag_out_sig = align_flag(2,regs_CR_reg_at_t);
	 at t+1: TE_flag_out_sig = align_flag(1,regs_CR_reg_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_TX_temp_register = register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: TX_reg_to_shiftreg_sig_r_act = tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: interrupt_sig = true;
	 at t+1: regs_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: regs_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: regs_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: regs_r_act = regs_r_act_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_DR_reg = regs2_DR_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_r_act = NA;
	 at t+1: req_addrIn = req_addrIn_at_t;
	 at t+1: req_dataIn = req_dataIn_at_t;
	 at t+1: req_mask = req_mask_at_t;
	 at t+1: req_req = ME_X;
	 at t+1: resp_to_mem_sig_CR_reg = register_CR_command(regs_CR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t);
	 at t+1: resp_to_mem_sig_DR_reg = register_RX_event(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t);
	 at t+1: resp_to_mem_sig_SR_reg = (manage_TX_flags(manage_RX_flags(register_SR_command(regs_SR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),regs2_CR_reg_at_t,regs2_DR_reg_at_t,regs2_SR_reg_at_t,regs2_r_act_at_t),tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t) or 2);
	 at t+1: resp_to_mem_sig_r_act = regs_r_act_at_t;
	 at t+1: tx_flag_tc_flag = NF;
	 at t+1: tx_flag_txe_flag = NF;
	 at t+1: tx_temp_r_act = tx_no_action(tx_flag_tc_flag_at_t,tx_flag_txe_flag_at_t,register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_action(register_TX_command(register_TX_command(regs_DR_reg_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t),tx_temp_r_act_at_t,req_addrIn_at_t,req_dataIn_at_t,req_mask_at_t,req_req_at_t));
	 at t+1: interrupt_notify = true;
end property;