property nop is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_3 = t_state_7+1,
	t_done = t_state_3+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1;
assume:
	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	--during[t_state_7,t_state_3]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32))); --manually inserted instr_in_sig
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(6,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(7,32)));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_7,t_done]: regfile = prev(regfile);
	during[t_state_7,t_done]: wb_write_reg = false;
	during[t_state_1,t_state_3]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_valid;
	at t_state_7: ex_branch=0;
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_3: branch = false;
	at t_state_3: ex_write_reg = false;
	at t_done: wb_write_reg = false;
right_hook: t_state_7;

determination_domains_end:
when done => t_state_3+1;

local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
	at t_state_7: determined(dmem_data_o);
	at t_state_1: determined(regfile);
	at t_state_7: determined(regfile);
	at t_state_3: determined(regfile);
end property;
