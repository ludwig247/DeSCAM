-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro interrupt_enabled_notify :  boolean  := end macro; 
--macro request_notify :  boolean  := end macro; 
--macro request_sync   :  boolean  := end macro; 
--macro response_notify :  boolean  := end macro; 
--macro response_sync   :  boolean  := end macro; 
--macro rx_receive_notify :  boolean  := end macro; 
--macro rx_receive_sync   :  boolean  := end macro; 
--macro tx_send_notify :  boolean  := tx_send_notify_tmp end macro; 
--macro tx_send_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro RE_flag_out_sig : unsigned := RE_flag_out end macro; 
macro TE_flag_out_sig : unsigned := TE_flag_out end macro; 
macro interrupt_enabled_sig : boolean := interrupt_enabled end macro; 
macro request_sig_addrIn : unsigned := request.addrIn end macro; 
macro request_sig_dataIn : unsigned := request.dataIn end macro; 
macro request_sig_mask : ME_MaskType := request.mask end macro; 
macro request_sig_req : ME_AccessType := request.req end macro; 
macro response_sig_loadedData : unsigned := response.loadedData end macro; 
macro rx_receive_sig_CR_reg : unsigned := rx_receive.CR_reg end macro; 
macro rx_receive_sig_RX_reg : unsigned := rx_receive.RX_reg end macro; 
macro rx_receive_sig_SR_reg : unsigned := rx_receive.SR_reg end macro; 
macro rx_receive_sig_TX_reg : unsigned := rx_receive.TX_reg end macro; 
macro rx_receive_sig_r_act : reg_action := rx_receive.r_act end macro; 
macro trans_flags_in_sig : boolean := trans_flags_in end macro; 
macro tx_send_sig_CR_reg : unsigned := tx_send.CR_reg end macro; 
macro tx_send_sig_RX_reg : unsigned := tx_send.RX_reg end macro; 
macro tx_send_sig_SR_reg : unsigned := tx_send.SR_reg end macro; 
macro tx_send_sig_TX_reg : unsigned := tx_send.TX_reg end macro; 
macro tx_send_sig_r_act : reg_action := tx_send.r_act end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 
constraint send_notify := regs2_r_act = TX_WR; end constraint;


-- VISIBLE REGISTERS --
macro init : boolean := init_signal end macro; 
macro regs2_CR_reg : unsigned := regs2_signal.CR_reg end macro; 
macro regs2_RX_reg : unsigned := regs2_signal.RX_reg end macro; 
macro regs2_SR_reg : unsigned := regs2_signal.SR_reg end macro; 
macro regs2_TX_reg : unsigned := regs2_signal.TX_reg end macro; 
macro regs2_r_act : reg_action := regs2_signal.r_act end macro; 
macro regs3_RX_reg : unsigned := regs3_signal.RX_reg end macro; 
macro regs3_r_act : reg_action := regs3_signal.r_act end macro; 
macro uart_in_addrIn : unsigned := uart_in_signal.addrIn end macro; 
macro uart_in_dataIn : unsigned := uart_in_signal.dataIn end macro; 
macro uart_in_mask : ME_MaskType := uart_in_signal.mask end macro; 
macro uart_in_req : ME_AccessType := uart_in_signal.req end macro; 
macro uart_out_loadedData : unsigned := uart_out_signal.loadedData end macro; 


-- STATES -- 
macro OUTPUT_0 : boolean := 
section = OUTPUT and 
tx_send_notify = false and
request_notify = false and
rx_receive_notify = false and
interrupt_enabled_notify = false and
response_notify = true
end macro;
macro PROCESS_INPUT_1 : boolean := 
section = PROCESS_INPUT and 
response_notify = false and
request_notify = false and
rx_receive_notify = false and
interrupt_enabled_notify = false and

if(tx_send_notify = false) then
tx_send_sync = false
end if;


end macro;
macro READ_INPUT_2 : boolean := 
section = READ_INPUT and 
tx_send_notify = false and
response_notify = false and
rx_receive_notify = false and
interrupt_enabled_notify = false
end macro;
macro SERVICE_COMMS_3 : boolean := 
section = SERVICE_COMMS and
tx_send_notify = false and
response_notify = false and
request_notify = false
end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: READ_INPUT_2;
	 at t: RE_flag_out_sig = resize(0,2);
	 at t: TE_flag_out_sig = resize(0,1);
	 at t: init = false;
	 at t: regs2_CR_reg = resize(0,32);
	 at t: regs2_RX_reg = resize(0,8);
	 at t: regs2_SR_reg = resize(32,32);
	 at t: regs2_TX_reg = resize(0,8);
	 at t: regs2_r_act = CR_RD;
	 at t: regs3_RX_reg = resize(0,8);
	 at t: regs3_r_act = CR_RD;
	 at t: uart_in_addrIn = resize(99,32);
	 at t: uart_in_dataIn = resize(0,32);
	 at t: uart_in_mask = MT_X;
	 at t: uart_in_req = ME_X;
	 at t: uart_out_loadedData = resize(0,32);
	 at t: interrupt_enabled_notify = false;
	 at t: request_notify = true;
	 at t: response_notify = false;
	 at t: rx_receive_notify = false;
	 at t: tx_send_notify = false;
end property;


property OUTPUT_0_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: OUTPUT_0;
	 at t: not(init);
	 at t: response_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property OUTPUT_0_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: OUTPUT_0;
	 at t: init;
	 at t: response_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = false;
	 at t_end: regs2_CR_reg = 0;
	 at t_end: regs2_RX_reg = 0;
	 at t_end: regs2_SR_reg = 32;
	 at t_end: regs2_TX_reg = 0;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property PROCESS_INPUT_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: PROCESS_INPUT_1;
	 at t: tx_send_sync;

prove:
	 at t_end: SERVICE_COMMS_3;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = NA;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end-1]: rx_receive_notify = false;
	 at t_end: rx_receive_notify = true;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property READ_INPUT_2_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = CR_WR));
	 at t: (register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR);
	 at t: not(request_sync);
prove:
	 at t_end: PROCESS_INPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: tx_send_sig_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_RX_reg = regs2_RX_reg_at_t;
	 at t_end: tx_send_sig_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end-1]: tx_send_notify = false;
	 at t_end: tx_send_notify = true;
end property;

property READ_INPUT_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = CR_WR));
	 at t: (register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR);
	 at t: request_sync;
prove:
	 at t_end: PROCESS_INPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: tx_send_sig_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_RX_reg = regs2_RX_reg_at_t;
	 at t_end: tx_send_sig_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: uart_in_addrIn = request_sig_addrIn_at_t;
	 at t_end: uart_in_dataIn = request_sig_dataIn_at_t;
	 at t_end: uart_in_mask = request_sig_mask_at_t;
	 at t_end: uart_in_req = request_sig_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end-1]: tx_send_notify = false;
	 at t_end: tx_send_notify = true;
end property;

property READ_INPUT_2_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = CR_WR);
	 at t: (register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR);
	 at t: request_sync;
prove:
	 at t_end: PROCESS_INPUT_1;
	 at t_end: RE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t) and 2);
	 at t_end: TE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t) and 1);
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: tx_send_sig_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_RX_reg = regs2_RX_reg_at_t;
	 at t_end: tx_send_sig_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: tx_send_sig_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: uart_in_addrIn = request_sig_addrIn_at_t;
	 at t_end: uart_in_dataIn = request_sig_dataIn_at_t;
	 at t_end: uart_in_mask = request_sig_mask_at_t;
	 at t_end: uart_in_req = request_sig_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end-1]: tx_send_notify = false;
	 at t_end: tx_send_notify = true;
end property;

property READ_INPUT_2_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = CR_WR);
	 at t: (register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR);
	 at t: not(request_sync);
prove:
	 at t_end: PROCESS_INPUT_1;
	 at t_end: RE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t) and 2);
	 at t_end: TE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t) and 1);
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: tx_send_sig_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_RX_reg = regs2_RX_reg_at_t;
	 at t_end: tx_send_sig_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: tx_send_sig_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end-1]: tx_send_notify = false;
	 at t_end: tx_send_notify = true;
end property;

property READ_INPUT_2_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = CR_WR));
	 at t: not((register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR));
	 at t: not(request_sync);
prove:
	 at t_end: SERVICE_COMMS_3;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end-1]: rx_receive_notify = false;
	 at t_end: rx_receive_notify = true;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property READ_INPUT_2_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = CR_WR));
	 at t: not((register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR));
	 at t: request_sync;
prove:
	 at t_end: SERVICE_COMMS_3;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = request_sig_addrIn_at_t;
	 at t_end: uart_in_dataIn = request_sig_dataIn_at_t;
	 at t_end: uart_in_mask = request_sig_mask_at_t;
	 at t_end: uart_in_req = request_sig_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end-1]: rx_receive_notify = false;
	 at t_end: rx_receive_notify = true;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property READ_INPUT_2_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = CR_WR);
	 at t: not((register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR));
	 at t: not(request_sync);
prove:
	 at t_end: SERVICE_COMMS_3;
	 at t_end: RE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t) and 2);
	 at t_end: TE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t) and 1);
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end-1]: rx_receive_notify = false;
	 at t_end: rx_receive_notify = true;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property READ_INPUT_2_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = CR_WR);
	 at t: not((register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR));
	 at t: request_sync;
prove:
	 at t_end: SERVICE_COMMS_3;
	 at t_end: RE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t) and 2);
	 at t_end: TE_flag_out_sig = (register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t) and 1);
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = request_sig_addrIn_at_t;
	 at t_end: uart_in_dataIn = request_sig_dataIn_at_t;
	 at t_end: uart_in_mask = request_sig_mask_at_t;
	 at t_end: uart_in_req = request_sig_req_at_t;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end-1]: rx_receive_notify = false;
	 at t_end: rx_receive_notify = true;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = CR_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_CR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_CR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = CR_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_CR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_CR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: not((regs2_r_act = CR_RD));
	 at t: not((regs2_r_act = SR_RD));
	 at t: not((regs2_r_act = RX_RD));
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: response_sig_loadedData = 0;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = 0;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: not((regs2_r_act = CR_RD));
	 at t: not((regs2_r_act = SR_RD));
	 at t: not((regs2_r_act = RX_RD));
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: response_sig_loadedData = 0;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = 0;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = CR_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = regs2_CR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_CR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = RX_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_RX_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_RX_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = CR_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = regs2_CR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_CR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = RX_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_RX_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_RX_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: not((regs2_r_act = CR_RD));
	 at t: not((regs2_r_act = SR_RD));
	 at t: not((regs2_r_act = RX_RD));
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = 0;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = 0;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: not((regs2_r_act = CR_RD));
	 at t: not((regs2_r_act = SR_RD));
	 at t: not((regs2_r_act = RX_RD));
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = 0;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = 0;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = SR_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = (((regs2_SR_reg_at_t and (17 * 4294967295)(31 downto 0)) and (65 * 4294967295)(31 downto 0)) and (129 * 4294967295)(31 downto 0));
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_SR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_SR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_22 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = RX_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = regs3_RX_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs3_RX_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_23 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = SR_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = (((regs2_SR_reg_at_t and (17 * 4294967295)(31 downto 0)) and (65 * 4294967295)(31 downto 0)) and (129 * 4294967295)(31 downto 0));
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: response_sig_loadedData = regs2_SR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_SR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_24 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = RX_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = rx_receive_sig_RX_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = rx_receive_sig_RX_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_25 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = SR_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs2_SR_reg = (((regs2_SR_reg_at_t and (17 * 4294967295)(31 downto 0)) and (65 * 4294967295)(31 downto 0)) and (129 * 4294967295)(31 downto 0));
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = regs2_SR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_SR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_26 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: (uart_in_req = ME_RD);
	 at t: (regs2_r_act = SR_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_0;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs2_SR_reg = (((regs2_SR_reg_at_t and (17 * 4294967295)(31 downto 0)) and (65 * 4294967295)(31 downto 0)) and (129 * 4294967295)(31 downto 0));
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = regs2_SR_reg_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = regs2_SR_reg_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_27 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: not((uart_in_req = ME_RD));
	 at t: not(init);
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_28 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: not((uart_in_req = ME_RD));
	 at t: not(init);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_29 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: not((uart_in_req = ME_RD));
	 at t: not(init);
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_30 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: not((uart_in_req = ME_RD));
	 at t: not(init);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = init_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_31 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((rx_receive_sig_r_act = RX_WR));
	 at t: not((uart_in_req = ME_RD));
	 at t: init;
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = false;
	 at t_end: regs2_CR_reg = 0;
	 at t_end: regs2_RX_reg = 0;
	 at t_end: regs2_SR_reg = 32;
	 at t_end: regs2_TX_reg = 0;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = rx_receive_sig_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_32 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: not((regs3_r_act = RX_WR));
	 at t: not((uart_in_req = ME_RD));
	 at t: init;
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = false;
	 at t_end: regs2_CR_reg = 0;
	 at t_end: regs2_RX_reg = 0;
	 at t_end: regs2_SR_reg = 32;
	 at t_end: regs2_TX_reg = 0;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_33 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (rx_receive_sig_r_act = RX_WR);
	 at t: not((uart_in_req = ME_RD));
	 at t: init;
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = false;
	 at t_end: regs2_CR_reg = 0;
	 at t_end: regs2_RX_reg = 0;
	 at t_end: regs2_SR_reg = 32;
	 at t_end: regs2_TX_reg = 0;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_3_read_34 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SERVICE_COMMS_3;
	 at t: (regs3_r_act = RX_WR);
	 at t: not((uart_in_req = ME_RD));
	 at t: init;
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: init = false;
	 at t_end: regs2_CR_reg = 0;
	 at t_end: regs2_RX_reg = 0;
	 at t_end: regs2_SR_reg = 32;
	 at t_end: regs2_TX_reg = 0;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = 99;
	 at t_end: uart_in_dataIn = 0;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = uart_out_loadedData_at_t;
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property wait_OUTPUT_0 is
dependencies: no_reset;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: OUTPUT_0;
	 at t: not(response_sync);
prove:
	 at t+1: OUTPUT_0;
	 at t+1: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t+1: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t+1: init = init_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t+1: regs2_r_act = regs2_r_act_at_t;
	 at t+1: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t+1: regs3_r_act = regs3_r_act_at_t;
	 at t+1: response_sig_loadedData = uart_out_loadedData_at_t;
	 at t+1: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t+1: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t+1: uart_in_mask = uart_in_mask_at_t;
	 at t+1: uart_in_req = uart_in_req_at_t;
	 at t+1: uart_out_loadedData = uart_out_loadedData_at_t;
	 at t+1: interrupt_enabled_notify = false;
	 at t+1: request_notify = false;
	 at t+1: response_notify = true;
	 at t+1: rx_receive_notify = false;
	 at t+1: tx_send_notify = false;
end property;

property wait_PROCESS_INPUT_1 is
dependencies: no_reset;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	init_at_t = init@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: PROCESS_INPUT_1;
	 at t: not(tx_send_sync);
prove:
	 at t+1: PROCESS_INPUT_1;
	 at t+1: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t+1: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t+1: init = init_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t+1: regs2_r_act = regs2_r_act_at_t;
	 at t+1: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t+1: regs3_r_act = regs3_r_act_at_t;
	 at t+1: tx_send_sig_CR_reg = regs2_CR_reg_at_t;
	 at t+1: tx_send_sig_RX_reg = regs2_RX_reg_at_t;
	 at t+1: tx_send_sig_SR_reg = regs2_SR_reg_at_t;
	 at t+1: tx_send_sig_TX_reg = regs2_TX_reg_at_t;
	 at t+1: tx_send_sig_r_act = regs2_r_act_at_t;
	 at t+1: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t+1: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t+1: uart_in_mask = uart_in_mask_at_t;
	 at t+1: uart_in_req = uart_in_req_at_t;
	 at t+1: uart_out_loadedData = uart_out_loadedData_at_t;
	 at t+1: interrupt_enabled_notify = false;
	 at t+1: request_notify = false;
	 at t+1: response_notify = false;
	 at t+1: rx_receive_notify = false;
	 at t+1: tx_send_notify = true;
end property;