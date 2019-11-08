
property branch_taken is
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
	dec_pc_at_t_decode = dec_pc@t_decode,
	dec_pc_at_t_state_4 = dec_pc@t_execute,
	ex_op_b_at_t_state_4 = ex_op_b@t_execute;
assume:

	at t: state_constraint;
	at t: only_nop; --manual
	at t_decode: (getOpCode(instr_in_sig_at_t_fetch) = resize(7,32));
	at t_decode: (reg_in_sig(getOpA(instr_in_sig_at_t_fetch)) = resize(0,32));
prove:
	during[t_fetch,t_execute]: dmem_enable_o = false; --manual
	during[t_fetch,t_execute]: dmem_write_o = false; --manual
	during[t_fetch,t_execute]: reg_out_notify = false; --manual
	during[t_fetch,t_execute]: ex_write_reg = false; --manual
	
	at t_decode: dec_pc = (2 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode: instr = instr_in_sig_at_t_fetch;
	at t_decode: instr_req_notify; -- manual
	at t_decode: instr_req_sig = (4 + dec_pc_at_t_fetch)(15 downto 0);
	at t_execute: branch = true;
	at t_execute: ex_op_b = getImm(instr_at_t_decode)(15 downto 0); -- manual 15 downto 0
	at t_execute: ex_write_reg = false;
	at t_wb: dec_pc = unsigned(((dec_pc_at_t_state_4-2) + ex_op_b_at_t_state_4))(15 downto 0);
right_hook: t_decode;

end property;


property branch_not_taken is
dependencies: no_reset;
for timepoints:
	t_fetch = t,
	t_decode = t_fetch+1,
	t_execute = t_decode+1;
freeze:
	dec_pc_at_t_fetch = dec_pc@t_fetch,
	instr_in_sig_at_t_fetch = instr_in_sig@t_fetch,
	instr_at_t_decode = instr@t_decode,
	dec_pc_at_t_decode = dec_pc@t_decode;
assume:
	at t: state_constraint;
	at t: only_nop; --manual
	at t_decode: not((reg_in_sig(getOpA(instr_in_sig_at_t_fetch)) = resize(0,32)));
	at t_decode: (getOpCode(instr_in_sig_at_t_fetch) = resize(7,32));
prove:
	during[t_fetch,t_execute]: dmem_enable_o = false; --manual
	during[t_fetch,t_execute]: dmem_write_o = false; --manual
	during[t_fetch,t_execute]: reg_out_notify = false; --manual
	during[t_fetch,t_execute]: ex_write_reg = false; --manual
	at t_decode: dec_pc = (2 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode: instr = instr_in_sig_at_t_fetch;
	at t_decode: instr_req_notify; -- manual	
	at t_decode: instr_req_sig = (4 + dec_pc_at_t_fetch)(15 downto 0);
	at t_execute: branch = false;
	at t_execute: dec_pc = (2 + dec_pc_at_t_decode)(15 downto 0);
	at t_execute: ex_write_reg = false;
right_hook: t_decode;

end property;

