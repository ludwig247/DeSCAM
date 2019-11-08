

property store is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_6 = t_state_7+1..max_wait_dmem waits_for complete (dmem_valid_i),
	t_state_3 = t_state_6+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7;
assume:

	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	--during[t_state_7,t_state_6]: regfile = prev(regfile);
	during[t_state_1,t_state_7]: wb_write_reg = false;
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(6,32));
	--at t_state_6: mem_write_sync; //should not be here 
	--at t_state_6: not(ex_write_reg); //manually removed for compl.
	--at t_state_6: not(branch); //manually removed for compl.
	at t_state_3: not((nextphase = rst));
prove:	
	during[t_state_7+1,t_state_3]: reg_out_notify = false;
	during[t_state_1,t_state_7]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_6: branch = false;
	at t_state_6: ex_write_reg = false;
	at t_state_6: memRequest_addr = (regfile(getOpB(instr_at_t_state_7)) + getImm(instr_at_t_state_7))(15 downto 0);
	at t_state_6: memRequest_data = regfile(getOpA(instr_at_t_state_7));
	at t_state_6: memRequest_write = true;
	during[t_state_7+1,t_state_6]: mem_write_sig_addr = (regfile(getOpB(instr_at_t_state_7)) + getImm(instr_at_t_state_7))(15 downto 0);
	during[t_state_7+1,t_state_6]: mem_write_sig_data = regfile(getOpA(instr_at_t_state_7));
	during[t_state_7+1,t_state_6]: mem_write_sig_write = true;
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
	at t_state_6: determined(ex_write_reg);
end property;
