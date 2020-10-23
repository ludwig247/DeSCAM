constraint no_stall := mem_stall = 0; end constraint;
constraint no_branch := ex_mispredict = 0; end constraint;
constraint is_flushed := ex_mispredict = 0 and mem_stall = 0 ; end constraint;
--constraint flushed := ex_mispredict = 0 and mem_stall = 0 ; end constraint;


macro reg_in_sig : array of unsigned := regfile end macro;
macro reg_out_sig_dest : unsigned := wb_dest_reg end macro;
macro reg_out_sig_value : unsigned := wb_result end macro;
macro reg_out_notify : boolean := wb_write_reg end macro;

macro branch : boolean := ex_mispredict end macro;

macro mem_write_sync : boolean := dmem_valid_i end macro;
macro mem_write_sig_write : boolean := dmem_write_o end macro;
macro mem_write_sig_addr : unsigned := dmem_addr_o end macro;
macro mem_write_sig_data : unsigned := dmem_data_o end macro;

macro memRequest_write : boolean := dmem_write end macro;
macro memRequest_addr : unsigned := ex_result end macro;
macro memRequest_data : unsigned := dmem_data_o end macro;


macro mem_read_sig : unsigned := dmem_data_i end macro;


-- VISIBLE REGISTERS --
macro run : unsigned := resize(0,16) end macro;
macro rst : unsigned := resize(1,16) end macro;
--macro dec_pc : unsigned :=  dec_pc end macro;
macro nextphase : unsigned :=  resize(0,16)  end macro;
macro instr : unsigned := IR end macro;
--macro rf : unsigned_8 := register_file end macro;

-- STATES --
macro state_1 : boolean := fetch_0 end macro;
macro state_2 : boolean := decode_1 end macro;
macro state_3 : boolean := execute_2 end macro;
macro state_4 : boolean := wb_3 end macro;
-- OPERATIONS --
-- OPERATIONS --
-- OPERATIONS --
property reset is
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
	 at t+1: state_1;
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

macro state_constraint : boolean := 
	current_mem_state = 0 and
	dec_valid = 1 and
	ex_branch = 0 and 
	--ex_dest_reg = 0 and
	--ex_not = 0 and
	--ex_op_a = 0 and
	--ex_op_b = 0 and
	--ex_read_from_mem = 0 and
	--ex_sub = 0 and
	--ex_valid = 1 and
	ex_write_reg = 0 and 
	--(instruction_word_reg = resize(13,16) or instruction_word_reg(15 downto 11) = 7) and
	--instruction_word_reg(15 downto 11) > 8 and 
	--cpu1/register
	--wb_dest_reg = 0  and
	--wb_result = 0  and
	--wb_valid = 1 and
	wb_write_reg = 0 ;
	
end macro;

property neg is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_2 = t_state_7+1,
	t_state_3 = t_state_2+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7,
	ex_dest_reg_at_t_state_2 = ex_dest_reg@t_state_2,
	ex_result_at_t_state_2 = ex_result@t_state_2;
assume:
	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_7,t_state_2]: regfile = prev(regfile); --manual 
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(0,32));
	at t_state_3: not((nextphase = rst));
prove:

	during[t_state_1,t_state_7]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_2: branch = false;
	at t_state_2: ex_dest_reg = getDest(instr_at_t_state_7);
	at t_state_2: ex_result = not(regfile(getOpA(instr_at_t_state_7)));
	at t_state_2: ex_write_reg = true;
	at t_state_2: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_2: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_2: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_2: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_2: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_2: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_2: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_2: regfile(7) = reg_in_sig_7_at_t_state_7;
	at t_state_3: reg_out_sig_dest = ex_dest_reg_at_t_state_2;
	at t_state_3: reg_out_sig_value = ex_result_at_t_state_2;
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
end property;


property add is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_2 = t_state_7+1,
	t_state_3 = t_state_2+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7,
	ex_dest_reg_at_t_state_2 = ex_dest_reg@t_state_2,
	ex_result_at_t_state_2 = ex_result@t_state_2;
assume:
	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_7,t_state_2]: regfile = prev(regfile);
	during[t_state_7,t_state_2]: getOpCode(instr_in_sig) > 7;
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32))); 
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(1,32));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_1,t_state_3]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual

	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_2: branch = false;
	at t_state_2: ex_dest_reg = getDest(instr_at_t_state_7);
	at t_state_2: ex_op_b = regfile(getOpB(instr_at_t_state_7));
	at t_state_2: ex_result = (regfile(getOpA(instr_at_t_state_7)) + regfile(getOpB(instr_at_t_state_7)))(15 downto 0);
	at t_state_2: ex_write_reg = true;
	at t_state_2: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_2: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_2: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_2: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_2: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_2: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_2: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_2: regfile(7) = reg_in_sig_7_at_t_state_7;
	at t_state_3: reg_out_sig_dest = ex_dest_reg_at_t_state_2;
	at t_state_3: reg_out_sig_value = ex_result_at_t_state_2;
right_hook: t_state_7;

local_determination_requirements: 
	at t_state_7: determined(instruction_word_reg);
end property;


property sub is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_2 = t_state_7+1,
	t_state_3 = t_state_2+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	ex_result_at_t_state_2 = ex_result@t_state_2,
	ex_dest_reg_at_t_state_2 = ex_dest_reg@t_state_2;
assume:
	at t: state_constraint;
	at t: prev(instr_in_sig)(15 downto 11) > 8; --manual
	during[t_state_7,t_state_2]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(2,32));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_1,t_state_7]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: imem_read_o; -- manual
	at t_state_7: dmem_data_o = prev(dmem_data_o); -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_2: branch = false;
	at t_state_2: ex_dest_reg = getDest(instr_at_t_state_7);
	at t_state_2: ex_op_b = regfile(getOpB(instr_at_t_state_7));
	at t_state_2: ex_result = (regfile(getOpA(instr_at_t_state_7)) + (4294967295 * regfile(getOpB(instr_at_t_state_7)))(15 downto 0))(15 downto 0);
	at t_state_2: ex_write_reg = true;
	at t_state_2: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_2: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_2: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_2: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_2: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_2: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_2: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_2: regfile(7) = reg_in_sig_7_at_t_state_7;
	at t_state_3: reg_out_sig_dest = ex_dest_reg_at_t_state_2;
	at t_state_3: reg_out_sig_value = ex_result_at_t_state_2;
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
end property;



property load is
dependencies: no_reset,bounded_wait; --CONSTRAINT MISSING
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1..max_wait_dmem waits_for complete fetch_0, -- why is this required? 
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
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(4,32));
	--at t_state_5: mem_write_sync;
	--at t_state_5: ex_write_reg;
	at t_state_5: (getOpCode(instr_in_sig_at_t_state_1) = resize(4,32));
	at t_state_3: not((nextphase = rst));
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
	--at t_state_5: mem_write_notify = true; --manual 
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


property store is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_6 = t_state_7+1,
	t_state_3 = t_state_6+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	instr_at_t_state_7 = instr@t_state_7,
	regfile_at_t_state_7 = regfile@t_state_7;
assume:

	at t: state_constraint;
	at t: instruction_word_reg(15 downto 11) > 8; --manual
	during[t_state_7,t_state_6]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: (getOpCode(instr_in_sig_at_t_state_1) = resize(6,32));
	--at t_state_6: mem_write_sync; //should not be here 
	--at t_state_6: not(ex_write_reg); //manually removed for compl.
	--at t_state_6: not(branch); //manually removed for compl.
	at t_state_3: not((nextphase = rst));
prove:
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
	at t_state_6: mem_write_sig_addr = (regfile(getOpB(instr_at_t_state_7)) + getImm(instr_at_t_state_7))(15 downto 0);
	at t_state_6: mem_write_sig_data = regfile(getOpA(instr_at_t_state_7));
	at t_state_6: mem_write_sig_write = true;
right_hook: t_state_7;
local_determination_requirements:
	at t_state_7: determined(instruction_word_reg);
	at t_state_6: determined(ex_write_reg);
end property;


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
	during[t_state_7,t_state_3]: regfile = prev(regfile);
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(0,32))); --manually inserted instr_in_sig
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(1,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(2,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(4,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(6,32)));
	at t_state_7: not((getOpCode(instr_in_sig_at_t_state_1) = resize(7,32)));
	at t_state_3: not((nextphase = rst));
prove:
	during[t_state_7,t_done]: regfile = prev(regfile);
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


property cycle1 is
dependencies: no_reset;
for timepoints:
	t_state_1 = t,
	t_state_7 = t_state_1+1,
	t_state_2 = t_state_7+1,
	t_state_3 = t_state_2+1;
freeze:
	dec_pc_at_t_state_1 = dec_pc@t_state_1,
	instr_in_sig_at_t_state_1 = instr_in_sig@t_state_1,
	regfile_at_t_state_7 = regfile@t_state_7,
	instr_at_t_state_7 = instr@t_state_7,
	reg_in_sig_2_at_t_state_7 = reg_in_sig(2)@t_state_7,
	reg_in_sig_3_at_t_state_7 = reg_in_sig(3)@t_state_7,
	reg_in_sig_4_at_t_state_7 = reg_in_sig(4)@t_state_7,
	reg_in_sig_5_at_t_state_7 = reg_in_sig(5)@t_state_7,
	reg_in_sig_6_at_t_state_7 = reg_in_sig(6)@t_state_7,
	reg_in_sig_0_at_t_state_7 = reg_in_sig(0)@t_state_7,
	reg_in_sig_1_at_t_state_7 = reg_in_sig(1)@t_state_7,
	reg_in_sig_7_at_t_state_7 = reg_in_sig(7)@t_state_7,
	ex_result_at_t_state_2 = ex_result@t_state_2,
	ex_dest_reg_at_t_state_2 = ex_dest_reg@t_state_2;
assume:
	at t: state_constraint;
	at t: getOpCode(prev(instr_in_sig))>8;
	during[t_state_7,t_state_2]: regfile = prev(regfile);
	at t_state_7: ((shift_right(instr_in_sig_at_t_state_1,resize(11,32))) = resize(0,32));
	at t_state_7: true;
	at t_state_7: ((shift_right(instr_in_sig_at_t_state_1,resize(11,32))) /= resize(4,32));
	at t_state_3: not((nextphase = rst));
prove:	
	--during[t_state_1,t_state_7]: dmem_enable_o = false; --manual
	at t_state_7: state_constraint; -- manual
	at t_state_7: dec_pc = (2 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: instr = instr_in_sig_at_t_state_1;
	at t_state_7: instr_req_sig = (4 + dec_pc_at_t_state_1)(15 downto 0);
	at t_state_7: imem_read_o = true; --manual 
	at t_state_7: dmem_enable_o = false; -- manual 
	at t_state_7: dmem_data_o = prev(dmem_data_o); --manual 
	at t_state_2: branch = false;
	at t_state_2: ex_dest_reg = getDest(instr_at_t_state_7);
	at t_state_2: ex_result = not(regfile(getOpA(instr_at_t_state_7)))(15 downto 0);
	at t_state_2: ex_write_reg = true;
	at t_state_2: regfile(0) = reg_in_sig_0_at_t_state_7;
	at t_state_2: regfile(1) = reg_in_sig_1_at_t_state_7;
	at t_state_2: regfile(2) = reg_in_sig_2_at_t_state_7;
	at t_state_2: regfile(3) = reg_in_sig_3_at_t_state_7;
	at t_state_2: regfile(4) = reg_in_sig_4_at_t_state_7;
	at t_state_2: regfile(5) = reg_in_sig_5_at_t_state_7;
	at t_state_2: regfile(6) = reg_in_sig_6_at_t_state_7;
	at t_state_2: regfile(7) = reg_in_sig_7_at_t_state_7;
	at t_state_3: reg_out_sig_dest = ex_dest_reg_at_t_state_2;
	at t_state_3: reg_out_sig_value = ex_result_at_t_state_2;
right_hook: t_state_7;


end property;

