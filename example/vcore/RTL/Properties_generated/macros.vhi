-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --
macro instr_req_notify : boolean := imem_read_o end macro;
macro mem_write_notify : boolean := dmem_enable_o end macro;
macro reg_out_notify : boolean := wb_write_reg end macro;

-- DP SIGNALS --
macro instr_in_sig : unsigned := imem_data_i end macro;
macro instr_req_sig : unsigned := imem_addr_o end macro;

-- CONSTRAINTS --
constraint no_reset := reset_n = '1'; end constraint;

macro max_wait_dmem: unsigned  := 3 ; end macro;

constraint bounded_wait := disable iff: not(reset_n);
    if (dmem_enable_o) then
        exists i in 0..(max_wait_dmem-1):
            next(dmem_valid_i,i);
        end exists;
    end if;
end constraint;

macro reg_in_sig : array of unsigned := regfile end macro;
macro reg_out_sig_dest : unsigned := wb_dest_reg end macro;
macro reg_out_sig_value : unsigned := wb_result end macro;
macro from_reset : boolean := (reset_n) = 1 end macro;

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
macro instr : unsigned := instruction_word_reg end macro;
--macro rf : unsigned_8 := register_file end macro;


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

macro getDest(instr: unsigned) : unsigned :=
	if ((getOpCode(instr) = resize(4,32))) then unsigned(((shift_right(instr,resize(8,32))) and resize(7,32)))
	else unsigned(((shift_right(instr,resize(2,32))) and resize(7,32)))
end if;
end macro;

macro getOpA(instr: unsigned) : unsigned :=
	unsigned(((shift_right(instr,resize(8,32))) and resize(7,32)));
end macro;

macro getOpB(instr: unsigned) : unsigned :=
	unsigned(((shift_right(instr,resize(5,16))) and resize(7,16)));
end macro;

macro getOpCode(instr: unsigned) : unsigned :=
	unsigned((shift_right(instr,resize(11,32))));
end macro;

macro getImm(instr: unsigned) : unsigned :=
	if(getOpCode(instr) /= 7) then 
	unsigned(resize(signed(instr(4 downto 0)),16))
	else 
	unsigned(resize(signed(instr(7 downto 0)),16)*2)
	end if;
end macro;



