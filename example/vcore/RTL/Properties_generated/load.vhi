


property load is
dependencies: no_reset,bounded_wait; --CONSTRAINT MISSING
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1..max_wait_dmem waits_for complete (dmem_enable_o=0 or dmem_valid_i), -- why is this required? 
	t_state_5 = t_state_7+1..max_wait_dmem waits_for complete (dmem_valid_i), -- manual added
	t_state_3 = t_state_5+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	memRequest_data_at_t_state_7 = memRequest_data@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	ex_dest_reg_at_t_state_5 = ex_dest_reg@t_state_5,
	mem_read_sig_at_t_state_5 = mem_read_sig@t_state_5;
assume:
	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_1,t_state_7]: regfile = prev(regfile);
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32))); --manual
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32))); --manual
	--at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32))); --manual
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(4,32));
	--at t_state_5: mem_write_sync; --manual
	--at t_state_5: ex_write_reg; --manual
	--at t_state_5: (getOpCode(instr_in_sig_at_t_state_1) = resize(4,32));--manual
	--at t_state_3: not((nextphase = rst)); --manual
prove:
	during[t_state_1,t_state_7]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	during[t_state_1,t_state_7]: dmem_enable_o = false;-- manual
	during[t_state_1,t_state_5]: regfile = prev(regfile); --manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_5: branch = false;
	at t_state_5: ex_dest_reg = getDest(instr_at_t_state_7);
	at t_state_5: ex_write_reg = true;

	at t_state_5: memRequest_addr = (regfile(getOpB(instr_at_t_state_7)) + getImm(instr_at_t_state_7))(15 downto 0);
	at t_state_5: memRequest_write = false;
	at t_state_5: mem_write_sig_addr = (regfile(getOpB(instr_at_t_state_7)) + getImm(instr_at_t_state_7))(15 downto 0);
	at t_state_5: mem_write_sig_data = memRequest_data_at_t_state_7;
	at t_state_5: mem_write_sig_write = false;
	at t_state_5: mem_write_notify = true; --manual 
	at t_state_3: reg_out_sig_dest = ex_dest_reg_at_t_state_5;
	at t_state_3: reg_out_sig_value = mem_read_sig_at_t_state_5;
	at t_state_3: wb_write_reg = true;
--	at t_state_3: tmp = mem_read_sig_at_t_state_5; -- should be removed
right_hook: t_state_7;

determination_domains_end:
when done => t_state_5;

local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
	--at t_state_1: determined(regfile);
	--at t_state_7: determined(regfile);
	--at t_state_5: determined(regfile);
end property;
