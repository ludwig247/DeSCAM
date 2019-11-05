property reset is
freeze: instr_in_sig_at_t = instr_in_sig@t;
assume:
	reset_sequence;
        during [t,t+3]: reset_n;
prove:

	at t: instr_req_sig = pc_next;
	at t: instr_req_notify;
	at t: dec_pc = 0;
	at t: dec_valid = 0;
	at t: current_mem_state = 0;
	at t: dmem_enable_o = 0;
	at t: dmem_write_o = 0;
	at t: imem_addr_o = 0;
	at t: ex_mispredict = 0;
	at t: ex_write_reg = 0;
	at t: foreach r in 0..7:
			regfile(r) = 0;
		end foreach;
	at t+1: foreach r in 0..7:
			regfile(r) = 0;
		end foreach;
	at t+1: dmem_enable_o = 0;
	at t+1: dmem_write_o = 0;
	at t+1: current_mem_state = 0;
	at t+1: IR = instr_in_sig_at_t;
	at t+1: dec_valid = 1;
	at t+1: wb_valid =  0;
	at t+1: ex_valid =  0;
	at t+1: ex_dest_reg = 0;
	at t+1: ex_op_b = 0;
	at t+1: ex_pc = 0;
	at t+1: ex_mispredict = 0;
	at t+1: ex_write_reg = 0;
	at t+1: wb_write_reg = 0;
	at t+2: wb_write_reg = 0;

right_hook: t;

determination_domains_end:
	when execute => t;
	when done => t;
	when write_back => t+1;

end property;
