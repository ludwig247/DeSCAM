
property branch_taken is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_4 = t_state_7+1,
	t_state_3 = t_state_4+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	dec_pc_at_t_state_7 = dec_pc@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7,
	dec_pc_at_t_state_4 = dec_pc@t_state_4,
	ex_op_b_at_t_state_4 = ex_op_b@t_state_4;
assume:

	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_7,t_state_4]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(6,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(7,32));
	at t_state_7: (regfile(getOpA(instr_in_sig_at_t_state_1)) = resize(0,32));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_1,t_state_3]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_4: branch = true;
	--at t_state_4: dec_pc = dec_pc_at_t_state_7+2;
	at t_state_4: ex_op_b = getImm(instr_at_t_state_7)(15 downto 0); -- manual 15 downto 0
	at t_state_4: ex_write_reg = false;
	at t_state_4: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_4: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_4: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_4: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_4: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_4: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_4: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_4: regfile(7) = reg_in_sig_7_at_t_state_7;
	--at t_state_4: tmp = regfile(getOpA(instr_at_t_state_7));
	at t_state_3: dec_pc = unsigned(((dec_pc_at_t_state_4-2) + ex_op_b_at_t_state_4))(15 downto 0);
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
end property;


property branch_not_taken is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_3 = t_state_7+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	dec_pc_at_t_state_7 = dec_pc@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7;
assume:
	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_7,t_state_7]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(6,32)));
	at t_state_7: not((regfile(getOpA(instr_in_sig_at_t_state_1)) = resize(0,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(7,32));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_1,t_state_3]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_3: branch = false;
	at t_state_3: dec_pc = (2 + dec_pc_at_t_state_7)(15 downto 0);
	at t_state_3: ex_write_reg = false;
	at t_state_3: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_3: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_3: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_3: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_3: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_3: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_3: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_3: regfile(7) = reg_in_sig_7_at_t_state_7;
	--at t_state_3: tmp = regfile(getOpA(instr_at_t_state_7));
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
end property;

