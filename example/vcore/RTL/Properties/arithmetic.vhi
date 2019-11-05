-- @lang=vhi @ts=8


property arithmetic is
dependencies: no_reset,bounded_wait;
for timepoints:
	t_if = t,
	t_de = t_if+1..max_wait_dmem waits_for complete fetch_0,
	t_ex = t_de+1,
	t_wb = t_ex+1;
freeze:
	from_reset = prev(reset_n = 0)@t,
	instr_in_at_t_if = instr_in_sig@t_if,
	pc_next_at_t_if = pc_next@t_if,

	IR_at_t_de = IR@t_de,
	opA_at_t_de = virtual_register2(IR_at_t_de(10 downto 8))@t_de,
	opB_at_t_de = virtual_register2(IR_at_t_de(7 downto 5))@t_de,

	ex_write_reg_at_t_ex = ex_write_reg@t_ex,
	ex_result_at_t_ex = ex_result@t_ex,
	ex_dest_reg_at_t_ex = ex_dest_reg@t_ex,

	regfile_at_t_wb = regfile@t_wb,
	wb_dest_reg_at_t_wb = wb_dest_reg@t_wb,
	wb_result_at_t_wb = wb_result@t_wb,
	wb_write_reg_at_t_wb = wb_write_reg@t_wb;

assume:
	at t: fetch_0;
	at t: getOpCode(imem_data_i)=neg or getOpCode(imem_data_i)=add or getOpCode(imem_data_i)=sub;
	at t+1: not(ex_mispredict);
prove:
	-- IF
	at t: fetch_0;
	at t: from_reset? not(dec_valid) : dec_valid; -- UGLY
	-- BETWEEN IF and DE
	during[t+1,t_de-1]: instr_req_notify = 0;
	during[t+1,t_de-1]: dec_valid = 1;
	during[t+1,t_de-1]: dec_pc = next(dec_pc);
	-- DECODE
	at t_de: decode_1;
	at t_de: dec_pc = pc_next_at_t_if;
	at t_de: instr_req_sig = pc_next;
	at t_de: instr_req_notify;
	at t_de: IR = instr_in_at_t_if;
	at t_de: fetch_0; -- what to do about this?
	--START EXECUTE
	at t_ex : execute_2;
	at t_ex : dmem_write_o = 0;
	at t_ex : dmem_enable_o = 0;
	at t_ex : ex_write_reg = 1;
	at t_ex : ex_mispredict = 0;
	at t_ex : ex_dest_reg = getDest(IR_at_t_de);
	at t_ex : ex_result = getALUresult(getOpCode(IR_at_t_de),opA_at_t_de,opB_at_t_de);
	at t_ex : ex_read_from_mem = 0;
	at t_ex : current_mem_state = 0;
	--START WB
	at t_wb: wb_3;
	at t_wb: wb_result = ex_result_at_t_ex;
	at t_wb: wb_write_reg = ex_write_reg_at_t_ex;
	at t_wb: wb_dest_reg = ex_dest_reg_at_t_ex;
	-- END OF OPERATION:
	at t_wb+1: regfile(wb_dest_reg_at_t_wb) = wb_result_at_t_wb  ;
	at t_wb+1: foreach r in 0..7: if(r /= wb_dest_reg_at_t_wb) then regfile(r) = regfile_at_t_wb(r);end if; end foreach;
	-- FROM RESET
	during[t,t_wb]: from_reset ? (foreach r in 0..7: regfile(r) = 0;end foreach ): true;
	-- WAIT 
        during[t_de+3,t_wb]:  regfile = prev(regfile);

right_hook: t_de;
determination_domains_end:
	when execute => t_ex;
	when write_back => t_wb;
	when done => t_wb+1;
	

end property;
