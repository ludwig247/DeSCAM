


property load is
dependencies: no_reset,bounded_wait; --CONSTRAINT MISSING
for timepoints:
	t_fetch = t,
	t_decode = t_fetch+1,
	t_execute = t_decode+1..max_wait_dmem waits_for complete (dmem_valid_i), -- manual added
	t_wb = t_execute+1;
freeze:
	dec_pc_at_t_fetch = dec_pc@t_fetch,
	instr_in_sig_at_t_fetch = instr_in_sig@t_fetch,
	instr_at_t_decode = instr@t_decode,
	memRequest_data_at_t_decode = memRequest_data@t_decode,
	ex_dest_reg_at_t_execute = ex_dest_reg@t_execute,
	mem_read_sig_at_t_execute = mem_read_sig@t_execute;
assume:
	at t: state_constraint;
	at t: only_nop; --manual
	at t_decode: (getOpCode(instr_in_sig_at_t_fetch) = resize(4,32));
prove:
	during[t_fetch,t_decode]: dmem_enable_o = false; --manual
	during[t_fetch,t_decode]: dmem_write_o = false; --manual
        during[t_fetch,t_execute]: reg_out_notify = false; -- manual
        during[t_fetch,t_decode]: ex_write_reg = false; -- manual
	at t_decode: dec_pc = (2 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode: instr = instr_in_sig_at_t_fetch;
	at t_decode: instr_req_notify; -- manual
	at t_decode: instr_req_sig = (4 + dec_pc_at_t_fetch)(15 downto 0);
	during[t_decode+1,t_execute]: ex_dest_reg = getDest(instr_at_t_decode);
	during[t_decode+1,t_execute]: ex_write_reg = true;
	during[t_decode+1,t_execute]: mem_write_sig_addr = (reg_in_sig(getOpB(instr_at_t_decode)) + getImm(instr_at_t_decode))(15 downto 0);
	during[t_decode+1,t_execute]: mem_write_sig_data = memRequest_data_at_t_decode;
	during[t_decode+1,t_execute]: mem_write_sig_write = false;
	during[t_decode+1,t_execute]: mem_write_notify = true; --manual 
	during[t_decode+1,t_execute]: mem_write_notify = true;
	at t_wb: reg_out_sig_dest = ex_dest_reg_at_t_execute;
	at t_wb: reg_out_sig_value = mem_read_sig_at_t_execute;
	at t_wb: reg_out_notify = true;

right_hook: t_decode;

end property;
