property nop is
dependencies: no_reset;
for timepoints:
	t_fetch = t,
	t_decode = t_fetch+1,
	t_ex = t_decode+1,
	t_wb = t_ex+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_fetch,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_fetch;
assume:
	at t_fetch: state_constraint;
	at t_fetch: only_nop; --manual
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32))); --manually inserted instr_in_sig
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(6,32)));
	at t_decode: not((getOpCode(instr_in_sig_at_t_state_1) = resize(7,32)));

prove:
	during[t_decode,t_wb]: reg_out_notify = false; --manual
	during[t_decode,t_ex]: ex_write_reg = false; --manual
	during[t_decode,t_ex]: dmem_enable_o = false; --manual
	during[t_decode,t_ex]: dmem_write_o = false; --manual

	at t_decode: ex_branch=0;
	at t_decode: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_decode: instr = instr_in_sig_at_t_state_1;
	at t_decode: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_decode: instr_req_notify; -- manual

	at t_ex: branch = false;
	at t_ex: ex_write_reg = false;
right_hook: t_decode;


end property;
