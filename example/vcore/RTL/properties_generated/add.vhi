
property add is
dependencies: no_reset;
for timepoints:
	t_fetch = t,
	t_decode = t_fetch+1,
	t_execute = t_decode+1,
	t_wb = t_execute+1;
freeze:
	dec_pc_at_t_fetch = dec_pc@t_fetch,
	instr_in_sig_at_t_fetch = instr_in_sig@t_fetch,
	instr_at_t_decode = instr@t_decode,
	regfile_at_t_decode = regfile@t_decode,
	ex_result_at_t_execute = ex_result@t_execute,
	ex_dest_reg_at_t_execute = ex_dest_reg@t_execute;
assume:
	at t_fetch: state_constraint;
	at t_fetch: only_nop; --manual
	at t_decode: ((shift_right(instr_in_sig_at_t_fetch,resize(11,32))) = resize(1,32));
prove:
	during[t_fetch,t_execute]: reg_out_notify = false; --manual
	during[t_fetch,t_decode]: ex_write_reg = false; --manual
	during[t_fetch,t_execute]: dmem_enable_o = false; -- manual = false; --manual
	during[t_fetch,t_execute]: dmem_write_o = false; -- manual = false; --manual
	at t_decode: dec_pc = (2 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode: instr = instr_in_sig_at_t_fetch;
	at t_decode: instr_req_notify; -- manual
	at t_decode: instr_req_sig = (4 + dec_pc_at_t_fetch)(15 downto 0);
	at t_execute: branch = false;
	at t_execute: ex_dest_reg = getDest(instr_at_t_decode);
	at t_execute: ex_op_b = regfile(getOpB(instr_at_t_decode));
	at t_execute: ex_result = (reg_in_sig(getOpA(instr_at_t_decode)) + reg_in_sig(getOpB(instr_at_t_decode)))(15 downto 0);
	at t_execute: ex_write_reg = true;
	at t_wb: reg_out_sig_dest = ex_dest_reg_at_t_execute;
	at t_wb: reg_out_sig_value = ex_result_at_t_execute;
right_hook: t_decode;
end property;



