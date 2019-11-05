
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


-- VISIBLE REGISTERS --
macro regs2_CR_reg : unsigned := regs2_signal.CR_reg end macro; 
macro regs2_RX_reg : unsigned := regs2_signal.RX_reg end macro; 
macro regs2_SR_reg : unsigned := regs2_signal.SR_reg end macro; 
macro regs2_TX_reg : unsigned := regs2_signal.TX_reg end macro; 
macro regs2_r_act : reg_action := regs2_signal.r_act end macro; 
macro regs3_CR_reg : unsigned := regs3_signal.CR_reg end macro; 
macro regs3_RX_reg : unsigned := regs3_signal.RX_reg end macro;  
macro regs3_SR_reg : unsigned := regs3_signal.SR_reg end macro; 
macro regs3_TX_reg : unsigned := regs3_signal.TX_reg end macro; 
macro regs3_r_act : reg_action := regs3_signal.r_act end macro;  
macro uart_in_addrIn : unsigned := uart_in_signal.addrIn end macro; 
macro uart_in_dataIn : unsigned := uart_in_signal.dataIn end macro; 
macro uart_in_mask : ME_MaskType := uart_in_signal.mask end macro; 
macro uart_in_req : ME_AccessType := uart_in_signal.req end macro; 
macro uart_out_loadedData : unsigned := uart_out_signal.loadedData end macro; 





-- STATES -- 
macro OUTPUT_1 : boolean := 
section = OUTPUT and 
tx_send_notify = false and
request_notify = false and
rx_receive_notify = false 
end macro;
macro READ_INPUT_2 : boolean :=
section = READ_INPUT 
end macro;
macro SEND_3 : boolean := 
section = SEND
end macro;
macro SERVICE_COMMS_4 : boolean :=
section = SERVICE_COMMS and
tx_send_notify = false and
request_notify = false and
response_notify = false 


end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: READ_INPUT_2;
	 at t: RE_flag_out_sig = resize(0,1);
	 at t: TE_flag_out_sig = resize(0,1);
	 at t: regs2_CR_reg = resize(0,32);
	 at t: regs2_RX_reg = resize(0,8);
	 at t: regs2_SR_reg = resize(32,32);
	 at t: regs2_TX_reg = resize(0,8);
	 at t: regs2_r_act = CR_RD;
	 at t: regs3_CR_reg = resize(0,32);
	 at t: regs3_RX_reg = resize(0,8);
	 at t: regs3_SR_reg = resize(0,32);
	 at t: regs3_TX_reg = resize(0,8);
	 at t: regs3_r_act = CR_RD;
	 at t: uart_in_addrIn = resize(0,32);
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


property OUTPUT_1_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: OUTPUT_1;
	 at t: response_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
	 at t_end: regs3_r_act = regs3_r_act_at_t;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
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

property READ_INPUT_2_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR);
	 at t: request_sync;
prove:
	 at t_end: SEND_3;
	 at t_end: RE_flag_out_sig = get_flag(2,regs2_CR_reg_at_t);
	 at t_end: TE_flag_out_sig = get_flag(1,regs2_CR_reg_at_t);
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
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

property READ_INPUT_2_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: (register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR);
	 at t: not(request_sync);
prove:
	 at t_end: SEND_3;
	 at t_end: RE_flag_out_sig = get_flag(2,regs2_CR_reg_at_t);
	 at t_end: TE_flag_out_sig = get_flag(1,regs2_CR_reg_at_t);
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
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

property READ_INPUT_2_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(uart_in_addrIn,uart_in_dataIn,uart_in_mask,uart_in_req) = TX_WR));
	 at t: not(request_sync);
prove:
	 at t_end: SERVICE_COMMS_4;
	 at t_end: RE_flag_out_sig = get_flag(2,regs2_CR_reg_at_t);
	 at t_end: TE_flag_out_sig = get_flag(1,regs2_CR_reg_at_t);
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs2_r_act = register_action(uart_in_addrIn_at_t,uart_in_dataIn_at_t,uart_in_mask_at_t,uart_in_req_at_t);
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
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

property READ_INPUT_2_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	request_sig_addrIn_at_t = request_sig_addrIn@t,
	request_sig_dataIn_at_t = request_sig_dataIn@t,
	request_sig_mask_at_t = request_sig_mask@t,
	request_sig_req_at_t = request_sig_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: READ_INPUT_2;
	 at t: not((register_action(request_sig_addrIn,request_sig_dataIn,request_sig_mask,request_sig_req) = TX_WR));
	 at t: request_sync;
prove:
	 at t_end: SERVICE_COMMS_4;
	 at t_end: RE_flag_out_sig = get_flag(2,regs2_CR_reg_at_t);
	 at t_end: TE_flag_out_sig = get_flag(1,regs2_CR_reg_at_t);
	 at t_end: regs2_CR_reg = register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_TX_reg = register_TX_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,register_SR_command(register_CR_command(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t,request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs2_r_act = register_action(request_sig_addrIn_at_t,request_sig_dataIn_at_t,request_sig_mask_at_t,request_sig_req_at_t);
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
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

property SEND_3_write_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SEND_3;
	 at t: tx_send_sync;
prove:
	 at t_end: SERVICE_COMMS_4;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t_end: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = NA;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
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

property SERVICE_COMMS_4_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_CR_reg_at_t = rx_receive_sig_CR_reg@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_SR_reg_at_t = rx_receive_sig_SR_reg@t,
	rx_receive_sig_TX_reg_at_t = rx_receive_sig_TX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: (uart_in_req = ME_RD);
	 at t: (check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32));
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = rx_receive_sig_CR_reg_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_SR_reg = rx_receive_sig_SR_reg_at_t;
	 at t_end: regs3_TX_reg = rx_receive_sig_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: (uart_in_req = ME_RD);
	 at t: (check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32));
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_CR_reg_at_t = rx_receive_sig_CR_reg@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_SR_reg_at_t = rx_receive_sig_SR_reg@t,
	rx_receive_sig_TX_reg_at_t = rx_receive_sig_TX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((uart_in_req = ME_RD));
	 at t: (check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32));
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = rx_receive_sig_CR_reg_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_SR_reg = rx_receive_sig_SR_reg_at_t;
	 at t_end: regs3_TX_reg = rx_receive_sig_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+2;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((uart_in_req = ME_RD));
	 at t: (check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32));
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end]: interrupt_enabled_notify = false;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_CR_reg_at_t = rx_receive_sig_CR_reg@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_SR_reg_at_t = rx_receive_sig_SR_reg@t,
	rx_receive_sig_TX_reg_at_t = rx_receive_sig_TX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32)));
	 at t: (uart_in_req = ME_RD);
	 at t: rx_receive_sync;
prove:
	 at t_end: OUTPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: interrupt_enabled_sig = true;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = rx_receive_sig_CR_reg_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_SR_reg = rx_receive_sig_SR_reg_at_t;
	 at t_end: regs3_TX_reg = rx_receive_sig_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end-1]: interrupt_enabled_notify = false;
	 at t_end: interrupt_enabled_notify = true;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	rx_receive_sig_CR_reg_at_t = rx_receive_sig_CR_reg@t,
	rx_receive_sig_RX_reg_at_t = rx_receive_sig_RX_reg@t,
	rx_receive_sig_SR_reg_at_t = rx_receive_sig_SR_reg@t,
	rx_receive_sig_TX_reg_at_t = rx_receive_sig_TX_reg@t,
	rx_receive_sig_r_act_at_t = rx_receive_sig_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,rx_receive_sig_CR_reg,rx_receive_sig_RX_reg,rx_receive_sig_SR_reg,rx_receive_sig_TX_reg,rx_receive_sig_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32)));
	 at t: not((uart_in_req = ME_RD));
	 at t: rx_receive_sync;
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: interrupt_enabled_sig = true;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = rx_receive_sig_CR_reg_at_t;
	 at t_end: regs3_RX_reg = rx_receive_sig_RX_reg_at_t;
	 at t_end: regs3_SR_reg = rx_receive_sig_SR_reg_at_t;
	 at t_end: regs3_TX_reg = rx_receive_sig_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,rx_receive_sig_CR_reg_at_t,rx_receive_sig_RX_reg_at_t,rx_receive_sig_SR_reg_at_t,rx_receive_sig_TX_reg_at_t,rx_receive_sig_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end-1]: interrupt_enabled_notify = false;
	 at t_end: interrupt_enabled_notify = true;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32)));
	 at t: (uart_in_req = ME_RD);
	 at t: not(rx_receive_sync);
prove:
	 at t_end: OUTPUT_1;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: interrupt_enabled_sig = true;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: response_sig_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = uart_in_mask_at_t;
	 at t_end: uart_in_req = uart_in_req_at_t;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end-1]: interrupt_enabled_notify = false;
	 at t_end: interrupt_enabled_notify = true;
	 during[t+1, t_end]: request_notify = false;
	 during[t+1, t_end-1]: response_notify = false;
	 at t_end: response_notify = true;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property SERVICE_COMMS_4_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	trans_flags_in_sig_at_t = trans_flags_in_sig@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t;
assume: 
	 at t: SERVICE_COMMS_4;
	 at t: not((check_interrupt(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),register_SR_event(regs2_CR_reg,register_RX_event(regs2_CR_reg,regs2_RX_reg,regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act),regs2_SR_reg,regs2_TX_reg,regs2_r_act,regs3_CR_reg,regs3_RX_reg,regs3_SR_reg,regs3_TX_reg,regs3_r_act,trans_flags_in_sig),regs2_TX_reg,regs2_r_act) = resize(0,32)));
	 at t: not((uart_in_req = ME_RD));
	 at t: not(rx_receive_sync);
prove:
	 at t_end: READ_INPUT_2;
	 at t_end: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t_end: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t_end: interrupt_enabled_sig = true;
	 at t_end: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t_end: regs2_RX_reg = register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t);
	 at t_end: regs2_SR_reg = clear_SR_flags(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 at t_end: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t_end: regs2_r_act = regs2_r_act_at_t;
	 at t_end: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t_end: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t_end: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t_end: regs3_TX_reg = regs3_TX_reg_at_t;
	 at t_end: regs3_r_act = NA;
	 at t_end: uart_in_addrIn = uart_in_addrIn_at_t;
	 at t_end: uart_in_dataIn = uart_in_dataIn_at_t;
	 at t_end: uart_in_mask = MT_X;
	 at t_end: uart_in_req = ME_X;
	 at t_end: uart_out_loadedData = response_data(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),(register_SR_event(regs2_CR_reg_at_t,register_RX_event(regs2_CR_reg_at_t,regs2_RX_reg_at_t,regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t),regs2_SR_reg_at_t,regs2_TX_reg_at_t,regs2_r_act_at_t,regs3_CR_reg_at_t,regs3_RX_reg_at_t,regs3_SR_reg_at_t,regs3_TX_reg_at_t,regs3_r_act_at_t,trans_flags_in_sig_at_t) or 2),regs2_TX_reg_at_t,regs2_r_act_at_t);
	 during[t+1, t_end-1]: interrupt_enabled_notify = false;
	 at t_end: interrupt_enabled_notify = true;
	 during[t+1, t_end-1]: request_notify = false;
	 at t_end: request_notify = true;
	 during[t+1, t_end]: response_notify = false;
	 during[t+1, t_end]: rx_receive_notify = false;
	 during[t+1, t_end]: tx_send_notify = false;
end property;

property wait_OUTPUT_1 is
dependencies: no_reset;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: OUTPUT_1;
	 at t: not(response_sync);
prove:
	 at t+1: OUTPUT_1;
	 at t+1: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t+1: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t+1: regs2_r_act = regs2_r_act_at_t;
	 at t+1: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t+1: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t+1: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t+1: regs3_TX_reg = regs3_TX_reg_at_t;
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

property wait_SEND_3 is
dependencies: no_reset;
freeze:
	RE_flag_out_sig_at_t = RE_flag_out_sig@t,
	TE_flag_out_sig_at_t = TE_flag_out_sig@t,
	regs2_CR_reg_at_t = regs2_CR_reg@t,
	regs2_RX_reg_at_t = regs2_RX_reg@t,
	regs2_SR_reg_at_t = regs2_SR_reg@t,
	regs2_TX_reg_at_t = regs2_TX_reg@t,
	regs2_r_act_at_t = regs2_r_act@t,
	regs3_CR_reg_at_t = regs3_CR_reg@t,
	regs3_RX_reg_at_t = regs3_RX_reg@t,
	regs3_SR_reg_at_t = regs3_SR_reg@t,
	regs3_TX_reg_at_t = regs3_TX_reg@t,
	regs3_r_act_at_t = regs3_r_act@t,
	uart_in_addrIn_at_t = uart_in_addrIn@t,
	uart_in_dataIn_at_t = uart_in_dataIn@t,
	uart_in_mask_at_t = uart_in_mask@t,
	uart_in_req_at_t = uart_in_req@t,
	uart_out_loadedData_at_t = uart_out_loadedData@t;
assume: 
	 at t: SEND_3;
	 at t: not(tx_send_sync);
prove:
	 at t+1: SEND_3;
	 at t+1: RE_flag_out_sig = RE_flag_out_sig_at_t;
	 at t+1: TE_flag_out_sig = TE_flag_out_sig_at_t;
	 at t+1: regs2_CR_reg = regs2_CR_reg_at_t;
	 at t+1: regs2_RX_reg = regs2_RX_reg_at_t;
	 at t+1: regs2_SR_reg = regs2_SR_reg_at_t;
	 at t+1: regs2_TX_reg = regs2_TX_reg_at_t;
	 at t+1: regs2_r_act = regs2_r_act_at_t;
	 at t+1: regs3_CR_reg = regs3_CR_reg_at_t;
	 at t+1: regs3_RX_reg = regs3_RX_reg_at_t;
	 at t+1: regs3_SR_reg = regs3_SR_reg_at_t;
	 at t+1: regs3_TX_reg = regs3_TX_reg_at_t;
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