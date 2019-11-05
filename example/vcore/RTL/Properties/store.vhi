-- @lang=vhi @ts=8

-- @lang=vhi @ts=8
property store is
dependencies: no_reset,bounded_wait;
for timepoints:
	t_if = t,
	t_de = t_if+1..max_wait_dmem waits_for complete fetch_0,
	t_ex = t_de+1..max_wait_dmem waits_for complete (dmem_valid_i),
	t_wb = t_ex+1;
freeze:
	from_reset = prev(reset_n = 0)@t,
	instr_in_at_t_if = instr_in_sig@t_if,
	pc_next_at_t_if = pc_next@t_if,
	IR_at_t_de = IR@t_de,
	ex_dest_reg_t_de = ex_dest_reg@t_de,
	ex_write_reg_at_de = ex_write_reg@t_de,
	ex_valid_t_de = ex_valid@t_de,
	imm = unsigned(resize(signed(IR(4 downto 0)),16))@t_de,
	opB = virtual_register2(IR_at_t_de(7 downto 5))@t_de,
	opA = virtual_register2(IR_at_t_de(10 downto 8))@t_de,

	ex_write_reg_at_t_ex = ex_write_reg@t_ex,
	ex_result_at_t_ex = ex_result@t_ex,
	ex_dest_reg_at_t_ex = ex_dest_reg@t_ex,

	regfile_at_t_wb = regfile@t_wb,	
	wb_dest_reg_at_t_wb = wb_dest_reg@t_wb,
	wb_result_at_t_wb = wb_result@t_wb,
	wb_write_reg_at_t_wb = wb_write_reg@t_wb;
	
assume:
	at t: fetch_0;
	at t: getOpCode(imem_data_i)= st;
	at t+1: not(ex_mispredict);
prove:
	-- IF
	at t: fetch_0;
	at t: from_reset? not(dec_valid) : dec_valid;
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
	at t_de: fetch_0; 

	-- BETWEEN DE AND EX
	during[t_de+1,t_ex-1]: dmem_enable_o = 1;
	during[t_de+1,t_ex-1]: dmem_write_o = 1;
	during[t_de+1,t_ex-1]: dmem_addr_o = (opB + imm)(15 downto 0);
	during[t_de+1,t_ex-1]: dmem_data_o = opA;
	during[t_de+1,t_ex-1]: ex_mispredict=0;
	during[t_de+1,t_ex-1]: ex_valid=1;
	during[t_de+1,t_ex-1]: ex_write_reg = 0;
	--EXECUTE 
	at t_ex: execute_2;
	at t_ex: dmem_enable_o = 1;
	at t_ex: dmem_write_o = 1;
	at t_ex: dmem_addr_o = (opB + imm)(15 downto 0);	
	at t_ex: dmem_data_o = opA;
	at t_ex: ex_write_reg = 0;
	at t_ex: ex_mispredict = 0;
	--WB
	at t_wb: wb_3;
	at t_wb: wb_write_reg = 0;
	-- END OF OPERATION: 
	at t_wb+1: regfile = regfile_at_t_wb;
	-- COMING FROM RESET
	during[t,t_wb]: from_reset ? (foreach r in 0..7: regfile(r) = 0; end foreach ): true;
	-- WAIT 
        during[t_de+3,t_wb]:  regfile = prev(regfile);
        during[t_de+2,t_wb]:  wb_write_reg = 0;
right_hook: t_de;
determination_domains_end:
	when execute => t_ex;
	when done => t_wb+1;
	when write_back => t_wb;

end property;
