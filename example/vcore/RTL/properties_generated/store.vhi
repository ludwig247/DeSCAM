property store is
dependencies: no_reset;
for timepoints:
	t_fetch = t,
	t_decode  = t_fetch+1,
	t_execute = t_decode +1..max_wait_dmem waits_for complete (dmem_valid_i),
	t_wb = t_execute+1;
freeze:
	dec_pc_at_t_fetch = dec_pc@t_fetch,
	instr_in_sig_at_t_fetch = instr_in_sig@t_fetch,
	instr_at_t_decode  = instr@t_decode;
assume:

	at t: state_constraint;
	at t: only_nop; --manual
	at t_decode : (getOpCode(instr_in_sig_at_t_fetch) = resize(6,32));
prove:	
	during[t_decode,t_wb]: reg_out_notify = false;
	during[t_fetch,t_decode]: dmem_enable_o = false; --manual
	during[t_fetch,t_decode]: dmem_write_o = false; --manual
	during[t_fetch,t_decode]: ex_write_reg = false;

	at t_decode : instr_req_notify; -- manual
	at t_decode : instr_req_sig = (4 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode : dmem_data_o = prev(dmem_data_o); -- manual
	at t_decode : dec_pc = (2 + dec_pc_at_t_fetch)(15 downto 0);
	at t_decode : instr = instr_in_sig_at_t_fetch;

	during[t_decode +1,t_execute]: branch = false;
	during[t_decode +1,t_execute]: ex_write_reg = false;
	during[t_decode +1,t_execute]: mem_write_sig_addr = (reg_in_sig(getOpB(instr_at_t_decode )) + getImm(instr_at_t_decode ))(15 downto 0);
	during[t_decode +1,t_execute]: mem_write_sig_data = reg_in_sig(getOpA(instr_at_t_decode ));
	during[t_decode +1,t_execute]: mem_write_sig_write = true;
right_hook: t_decode ;

end property;

