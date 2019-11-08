property composed_nop is
dependencies: no_reset, no_branch, no_stall;
for timepoints:
	t_fetch = t+1,
	t_decode = t_fetch+1,
	t_exec = t_decode+1;
freeze:
	dec_pc_at_t = dec_pc@t,
	instr_in_sig_at_t = instr_in_sig@t,
	nextphase_at_t = nextphase@t,

  regfile_0_at_t_ex = regfile(0)@t_exec,
  regfile_1_at_t_ex = regfile(1)@t_exec,
  regfile_2_at_t_ex = regfile(2)@t_exec,
  regfile_3_at_t_ex = regfile(3)@t_exec,
  regfile_4_at_t_ex = regfile(4)@t_exec,
  regfile_5_at_t_ex = regfile(5)@t_exec,
  regfile_6_at_t_ex = regfile(6)@t_exec,
  regfile_7_at_t_ex = regfile(7)@t_exec;


assume:
	at t: state_1;
	at t: prev(reset_n);
	at t_fetch: state_2;
	at t_fetch: (getOpCode(instr) >= resize(8,32));
prove:
	at t_fetch: state_2;
	at t_fetch: dec_pc = (2 + dec_pc_at_t)(15 downto 0);
	at t_fetch: instr = instr_in_sig_at_t;
	at t_fetch: instr_req_sig = (dec_pc + 2)(15 downto 0);
	at t_fetch: nextphase = nextphase_at_t;
	during[t+1, t_fetch-1]: instr_req_notify = false;
	at t_fetch: instr_req_notify = true;

	at t_decode: state_3;
	--at t_decode: dec_pc = dec_pc_at_t;
	at t_decode: ex_write_reg = 0;
	--at t_decode: instr = instr_at_t;
	at t_decode: nextphase = nextphase_at_t;
	--during[t+1, t_decode]: instr_req_notify = false;

        at t_exec: regfile(0) = regfile_0_at_t_ex;
	at t_exec: regfile(1) = regfile_1_at_t_ex;
	at t_exec: regfile(2) = regfile_2_at_t_ex;
	at t_exec: regfile(3) = regfile_3_at_t_ex;
	at t_exec: regfile(4) = regfile_4_at_t_ex;
	at t_exec: regfile(5) = regfile_5_at_t_ex;
	at t_exec: regfile(6) = regfile_6_at_t_ex;
	at t_exec: regfile(7) = regfile_7_at_t_ex;
end property;



property composed_add is
dependencies: no_reset,no_branch, no_stall;
for timepoints:
	t_if = t,
	t_de = t+1,
	t_ex = t+2,
	t_wb = t+3;
freeze:
	dec_pc_at_t_if = dec_pc@t_if,
	instr_in_sig_at_t_if = instr_in_sig@t_if,
	nextphase_at_t_if = nextphase@t_if,
	instr_at_t_de = IR@t_de,
	regfile_at_t_de = regfile@t_de;


assume:
	at t_if: state_1;
	at t_if: prev(getOpCode(instr_in_sig))>7;
	at t_if: prev(getOpCode(instr_in_sig),2)>7;
	at t_if: prev(reset_n);

	at t_de: (getOpCode(instr_in_sig_at_t_if) = resize(1,32));

prove:

	at t_de: state_2;
	at t_de: dec_pc = (2 + dec_pc_at_t_if)(15 downto 0);
	at t_de: instr = instr_in_sig_at_t_if;
	at t_de: instr_req_sig = (dec_pc + 2)(15 downto 0);
	at t_de: nextphase = nextphase_at_t_if;
	at t_de: instr_req_notify = true;
	at t_de: reg_out_notify = false;

	
	at t_ex: state_3;
	at t_ex: ex_write_reg = true;
	at t_ex: ex_dest_reg = getDest(instr_at_t_de);
	at t_ex: ex_op_a = regfile(getOpA(instr_at_t_de));
	at t_ex: ex_op_b = regfile(getOpB(instr_at_t_de));
	at t_ex: ex_result = (regfile(getOpA(instr_at_t_de)) + regfile(getOpB(instr_at_t_de)))(15 downto 0);
	at t_ex: reg_out_notify = false;

	at t_wb: state_4; 
	at t_wb: wb_result = prev(ex_result);
	at t_wb: wb_dest_reg = prev(ex_dest_reg);
	at t_wb: reg_out_notify = true;
right_hook: t_de;
end property;

