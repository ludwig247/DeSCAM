/* property reset is
assume:
	 reset_sequence;
         during [t,t+1]: reset_n;
prove:
	 at t: instr_req_sig = resize(0,16);
	 at t: instr_req_notify;
	 at t: dec_pc = resize(0,32);
	 at t: dmem_enable_o = 0;
	 at t: dmem_write_o = 0;
	 at t: ex_dest_reg = resize(0,32);
	 at t: dec_valid = 0;
	 --at t: ex_result = resize(0,32);
	 at t: ex_write_reg = false;
	 at t: regfile(0) = resize(0,32);
	 at t: regfile(1) = resize(0,32);
	 at t: regfile(2) = resize(0,32);
	 at t: regfile(3) = resize(0,32);
	 at t: regfile(4) = resize(0,32);
	 at t: regfile(5) = resize(0,32);
	 at t: regfile(6) = resize(0,32);
	 at t: regfile(7) = resize(0,32);
	 at t+1: dmem_enable_o = 0;
	 at t+1: dmem_write_o = 0;
	 at t+1: state_constraint;
	 at t+1: dec_pc = resize(0,32);
	 at t+1: ex_dest_reg = resize(0,32);
	 at t+1: ex_result = resize(0,32);
	 at t+1: ex_write_reg = false;
	 at t+1: instr = prev(instr_in_sig);
	 at t+1: instr_req_sig = resize(2,32);
	 at t+1: nextphase = run;
	 at t+1: regfile(0) = resize(0,32);
	 at t+1: regfile(1) = resize(0,32);
	 at t+1: regfile(2) = resize(0,32);
	 at t+1: regfile(3) = resize(0,32);
	 at t+1: regfile(4) = resize(0,32);
	 at t+1: regfile(5) = resize(0,32);
	 at t+1: regfile(6) = resize(0,32);
	 at t+1: regfile(7) = resize(0,32);
	 at t+1: instr_req_notify = true;
	 at t+1: reg_out_notify = false;
	 at t+1: dec_valid = 1;
	--at t+2: wb_valid;
right_hook: t;

local_determination_requirements: 
	at t+1: determined(instruction_word_reg);
end property;
*/


property reset2 is
freeze:
	instr_in_sig_at_t = instr_in_sig@t; -- manual
assume:
	 reset_sequence;
         during [t,t+1]: reset_n; -- manual
prove:
	 --at t: state_1;
	 at t: instr_req_sig = resize(0,16);
	 at t: instr_req_sig = resize(0,16);
	 at t: dec_pc = resize(0,32);
	 at t: mem_write_notify = false;
	 at t: mem_write_sig_write = false;
	 at t: ex_write_reg = false;
	 at t: regfile(0) = resize(0,32);
	 at t: regfile(1) = resize(0,32);
	 at t: regfile(2) = resize(0,32);
	 at t: regfile(3) = resize(0,32);
	 at t: regfile(4) = resize(0,32);
	 at t: regfile(5) = resize(0,32);
	 at t: regfile(6) = resize(0,32);
	 at t: regfile(7) = resize(0,32);
	 at t: dec_valid = 0;
	 --at t: reg_out_notify = false;
	 at t: instr_req_notify = true;
	 at t+1: branch = false;
	 at t+1: dec_pc = resize(0,32);
	 at t+1: ex_dest_reg = resize(0,32);
	 at t+1: ex_op_b = resize(0,32);
	 at t+1: ex_result = resize(0,32);
	 at t+1: ex_write_reg = false;
	-- at t: from_reset = false; --manual 
	 at t+1: instr = instr_in_sig_at_t; -- manual
	 at t+1: instr_req_sig = resize(2,32);
	 --at t+1: memRequest_addr = resize(0,32); -- manual
	 --at t+1: memRequest_data = resize(0,32); -- manual
	 at t+1: memRequest_write = false;
	 at t+1: regfile(0) = resize(0,32);
	 at t+1: regfile(1) = resize(0,32);
	 at t+1: regfile(2) = resize(0,32);
	 at t+1: regfile(3) = resize(0,32);
	 at t+1: regfile(4) = resize(0,32);
	 at t+1: regfile(5) = resize(0,32);
	 at t+1: regfile(6) = resize(0,32);
	 at t+1: regfile(7) = resize(0,32);
	 --at t: tmp = resize(0,32);
	 at t+1: mem_write_sig_write = false; --manual
	 at t+1: instr_req_notify = true;
	 at t+1: mem_write_notify = false;
	 at t+1: reg_out_notify = false;
	 at t+1: state_constraint;
right_hook: t;

local_determination_requirements: 
	at t+1: determined(instruction_word_reg);
end property;

