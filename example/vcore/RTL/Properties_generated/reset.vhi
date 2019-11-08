
property reset is
for timepoints:
	t_fetch = t,
	t_decode = t_fetch+1;
freeze:
	instr_in_sig_at_t = instr_in_sig@t; -- manual
assume:
	 reset_sequence;
         during [t,t_decode ]: reset_n; -- manual
prove:
	 at t_fetch: instr_req_notify = true; 
	 at t_fetch: instr_req_sig = resize(0,16);
	 at t_fetch: dec_pc = resize(0,32);
	 at t_fetch: mem_write_notify = false;
	 at t_fetch: mem_write_sig_write = false;
	 at t_fetch: ex_write_reg = false;

	 at t_decode : branch = false;
	 at t_decode : dec_pc = resize(0,32);
	 at t_decode : ex_dest_reg = resize(0,32);
	 at t_decode : ex_op_b = resize(0,32);
	 at t_decode : ex_result = resize(0,32);
	 at t_decode : ex_write_reg = false;
	 at t_decode : instr = instr_in_sig_at_t; -- manual
	 at t_decode : instr_req_notify = true;
	 at t_decode : instr_req_sig = resize(2,32);
	 at t_decode : mem_write_notify = false;
	 at t_decode : mem_write_sig_write = false; --manual
	 at t_decode : reg_out_notify = false;
	 at t_decode : dmem_data_o = prev(dmem_data_o); -- manual
	 at t_decode : state_constraint; -- manual 

right_hook: t_decode ;

end property;

