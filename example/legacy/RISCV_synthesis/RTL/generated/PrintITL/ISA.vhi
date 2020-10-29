-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro ISAtoMEM_port_notify :  boolean  := end macro; 
--macro ISAtoMEM_port_sync   :  boolean  := end macro; 
--macro ISAtoRF_port_notify :  boolean  := end macro; 
--macro MEMtoISA_port_notify :  boolean  := end macro; 
--macro MEMtoISA_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro ISAtoMEM_port_sig_addrIn : unsigned := ISAtoMEM_port_sig.addrIn end macro; 
macro ISAtoMEM_port_sig_dataIn : unsigned := ISAtoMEM_port_sig.dataIn end macro; 
macro ISAtoMEM_port_sig_mask : ME_MaskType := ISAtoMEM_port_sig.mask end macro; 
macro ISAtoMEM_port_sig_req : ME_AccessType := ISAtoMEM_port_sig.req end macro; 
macro ISAtoRF_port_sig_dst : unsigned := ISAtoRF_port_sig.dst end macro; 
macro ISAtoRF_port_sig_dstData : unsigned := ISAtoRF_port_sig.dstData end macro; 
macro MEMtoISA_port_sig_loadedData : unsigned := MEMtoISA_port_sig.loadedData end macro; 
macro RFtoISA_port_sig_reg_file_01 : unsigned := RFtoISA_port_sig.reg_file_01 end macro; 
macro RFtoISA_port_sig_reg_file_02 : unsigned := RFtoISA_port_sig.reg_file_02 end macro; 
macro RFtoISA_port_sig_reg_file_03 : unsigned := RFtoISA_port_sig.reg_file_03 end macro; 
macro RFtoISA_port_sig_reg_file_04 : unsigned := RFtoISA_port_sig.reg_file_04 end macro; 
macro RFtoISA_port_sig_reg_file_05 : unsigned := RFtoISA_port_sig.reg_file_05 end macro; 
macro RFtoISA_port_sig_reg_file_06 : unsigned := RFtoISA_port_sig.reg_file_06 end macro; 
macro RFtoISA_port_sig_reg_file_07 : unsigned := RFtoISA_port_sig.reg_file_07 end macro; 
macro RFtoISA_port_sig_reg_file_08 : unsigned := RFtoISA_port_sig.reg_file_08 end macro; 
macro RFtoISA_port_sig_reg_file_09 : unsigned := RFtoISA_port_sig.reg_file_09 end macro; 
macro RFtoISA_port_sig_reg_file_10 : unsigned := RFtoISA_port_sig.reg_file_10 end macro; 
macro RFtoISA_port_sig_reg_file_11 : unsigned := RFtoISA_port_sig.reg_file_11 end macro; 
macro RFtoISA_port_sig_reg_file_12 : unsigned := RFtoISA_port_sig.reg_file_12 end macro; 
macro RFtoISA_port_sig_reg_file_13 : unsigned := RFtoISA_port_sig.reg_file_13 end macro; 
macro RFtoISA_port_sig_reg_file_14 : unsigned := RFtoISA_port_sig.reg_file_14 end macro; 
macro RFtoISA_port_sig_reg_file_15 : unsigned := RFtoISA_port_sig.reg_file_15 end macro; 
macro RFtoISA_port_sig_reg_file_16 : unsigned := RFtoISA_port_sig.reg_file_16 end macro; 
macro RFtoISA_port_sig_reg_file_17 : unsigned := RFtoISA_port_sig.reg_file_17 end macro; 
macro RFtoISA_port_sig_reg_file_18 : unsigned := RFtoISA_port_sig.reg_file_18 end macro; 
macro RFtoISA_port_sig_reg_file_19 : unsigned := RFtoISA_port_sig.reg_file_19 end macro; 
macro RFtoISA_port_sig_reg_file_20 : unsigned := RFtoISA_port_sig.reg_file_20 end macro; 
macro RFtoISA_port_sig_reg_file_21 : unsigned := RFtoISA_port_sig.reg_file_21 end macro; 
macro RFtoISA_port_sig_reg_file_22 : unsigned := RFtoISA_port_sig.reg_file_22 end macro; 
macro RFtoISA_port_sig_reg_file_23 : unsigned := RFtoISA_port_sig.reg_file_23 end macro; 
macro RFtoISA_port_sig_reg_file_24 : unsigned := RFtoISA_port_sig.reg_file_24 end macro; 
macro RFtoISA_port_sig_reg_file_25 : unsigned := RFtoISA_port_sig.reg_file_25 end macro; 
macro RFtoISA_port_sig_reg_file_26 : unsigned := RFtoISA_port_sig.reg_file_26 end macro; 
macro RFtoISA_port_sig_reg_file_27 : unsigned := RFtoISA_port_sig.reg_file_27 end macro; 
macro RFtoISA_port_sig_reg_file_28 : unsigned := RFtoISA_port_sig.reg_file_28 end macro; 
macro RFtoISA_port_sig_reg_file_29 : unsigned := RFtoISA_port_sig.reg_file_29 end macro; 
macro RFtoISA_port_sig_reg_file_30 : unsigned := RFtoISA_port_sig.reg_file_30 end macro; 
macro RFtoISA_port_sig_reg_file_31 : unsigned := RFtoISA_port_sig.reg_file_31 end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- FUNCTIONS --
macro getALUfunc(instr: InstrType) : ALUfuncType := 
	if (((instr = INSTR_ADD) or (instr = INSTR_ADDI))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and (instr = INSTR_SUB)) then (ALU_SUB)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and ((instr = INSTR_SLL) or (instr = INSTR_SLLI))) then (ALU_SLL)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and ((instr = INSTR_SLT) or (instr = INSTR_SLTI))) then (ALU_SLT)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and ((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) then (ALU_SLTU)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and ((instr = INSTR_XOR) or (instr = INSTR_XORI))) then (ALU_XOR)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and ((instr = INSTR_SRL) or (instr = INSTR_SRLI))) then (ALU_SRL)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and ((instr = INSTR_SRA) or (instr = INSTR_SRAI))) then (ALU_SRA)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and ((instr = INSTR_OR) or (instr = INSTR_ORI))) then (ALU_OR)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and ((instr = INSTR_AND) or (instr = INSTR_ANDI))) then (ALU_AND)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and (((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and ((instr = INSTR_JALR) or (instr = INSTR_JAL))) then (ALU_X)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and ((instr = INSTR_BEQ) or (instr = INSTR_BNE))) then (ALU_SUB)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and ((instr = INSTR_BLT) or (instr = INSTR_BGE))) then (ALU_SLT)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and ((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) then (ALU_SLTU)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and (((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and not((((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) and (instr = INSTR_AUIPC)) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTIU))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and not((((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) and not((instr = INSTR_AUIPC)) and (instr = INSTR_LUI)) then (ALU_COPY1)
	else (ALU_X)
end if;
end macro; 

macro getALUresult(aluFunction: ALUfuncType;operand1: unsigned;operand2: unsigned) : unsigned := 
	if ((aluFunction = ALU_ADD)) then unsigned((operand1 + operand2)(31 downto 0))
	elsif (not((aluFunction = ALU_ADD)) and (aluFunction = ALU_SUB)) then unsigned((operand1 - operand2)(31 downto 0))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and (aluFunction = ALU_AND)) then unsigned((operand1 and operand2))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and (aluFunction = ALU_OR)) then unsigned((operand1 or operand2))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and (aluFunction = ALU_XOR)) then unsigned((operand1 xor operand2))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and (aluFunction = ALU_SLT) and (signed(operand1) < signed(operand2))) then unsigned(resize(1,32))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and (aluFunction = ALU_SLT) and not((signed(operand1) < signed(operand2)))) then unsigned(resize(0,32))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and (aluFunction = ALU_SLTU) and (operand1 < operand2)) then unsigned(resize(1,32))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and (aluFunction = ALU_SLTU) and not((operand1 < operand2))) then unsigned(resize(0,32))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and not((aluFunction = ALU_SLTU)) and (aluFunction = ALU_SLL)) then unsigned((shift_left(operand1,(operand2 and resize(31,32)))))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and not((aluFunction = ALU_SLTU)) and not((aluFunction = ALU_SLL)) and (aluFunction = ALU_SRA)) then unsigned(unsigned((shift_right(signed(operand1),signed((operand2 and resize(31,32)))))))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and not((aluFunction = ALU_SLTU)) and not((aluFunction = ALU_SLL)) and not((aluFunction = ALU_SRA)) and (aluFunction = ALU_SRL)) then unsigned((shift_right(operand1,(operand2 and resize(31,32)))))
	elsif (not((aluFunction = ALU_ADD)) and not((aluFunction = ALU_SUB)) and not((aluFunction = ALU_AND)) and not((aluFunction = ALU_OR)) and not((aluFunction = ALU_XOR)) and not((aluFunction = ALU_SLT)) and not((aluFunction = ALU_SLTU)) and not((aluFunction = ALU_SLL)) and not((aluFunction = ALU_SRA)) and not((aluFunction = ALU_SRL)) and (aluFunction = ALU_COPY1)) then unsigned(operand1)
	else unsigned(resize(0,32))
end if;
end macro; 

macro getEncType(encodedInstr: unsigned) : EncType := 
	if (((encodedInstr and resize(127,32)) = resize(51,32))) then (ENC_R)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32))) then (ENC_I_I)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32))) then (ENC_I_L)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(103,32))) then (ENC_I_J)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32))) then (ENC_S)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32))) then (ENC_B)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and (((encodedInstr and resize(127,32)) = resize(55,32)) or ((encodedInstr and resize(127,32)) = resize(23,32)))) then (ENC_U)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not((((encodedInstr and resize(127,32)) = resize(55,32)) or ((encodedInstr and resize(127,32)) = resize(23,32)))) and ((encodedInstr and resize(127,32)) = resize(111,32))) then (ENC_J)
	else (ENC_ERR)
end if;
end macro; 

macro getImmediate(encodedInstr: unsigned) : unsigned := 
	if (((encodedInstr and resize(127,32)) = resize(19,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned((shift_right(encodedInstr,resize(20,32))))
	elsif (((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-4096,32)) or (shift_right(encodedInstr,resize(20,32)))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned((shift_right(encodedInstr,resize(20,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-4096,32)) or (shift_right(encodedInstr,resize(20,32)))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned(((((shift_left(encodedInstr,resize(4,32))) and resize(2048,32)) or ((shift_right(encodedInstr,resize(20,32))) and resize(2016,32))) or ((shift_right(encodedInstr,resize(7,32))) and resize(30,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-4096,32)) or ((((shift_left(encodedInstr,resize(4,32))) and resize(2048,32)) or ((shift_right(encodedInstr,resize(20,32))) and resize(2016,32))) or ((shift_right(encodedInstr,resize(7,32))) and resize(30,32)))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and ((encodedInstr and resize(127,32)) = resize(103,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned((shift_right(encodedInstr,resize(20,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and ((encodedInstr and resize(127,32)) = resize(103,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-4096,32)) or (shift_right(encodedInstr,resize(20,32)))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned((((shift_right(encodedInstr,resize(20,32))) and resize(4064,32)) or ((shift_right(encodedInstr,resize(7,32))) and resize(31,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-4096,32)) or (((shift_right(encodedInstr,resize(20,32))) and resize(4064,32)) or ((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(55,32))) then unsigned((encodedInstr and unsigned(resize(-4096,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and ((encodedInstr and resize(127,32)) = resize(23,32))) then unsigned((encodedInstr and unsigned(resize(-4096,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and not(((encodedInstr and resize(127,32)) = resize(23,32))) and ((encodedInstr and resize(127,32)) = resize(111,32)) and (((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32))) then unsigned((((encodedInstr and resize(1044480,32)) or ((shift_right(encodedInstr,resize(9,32))) and resize(2048,32))) or ((shift_right(encodedInstr,resize(20,32))) and resize(2046,32))))
	elsif (not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and not(((encodedInstr and resize(127,32)) = resize(23,32))) and ((encodedInstr and resize(127,32)) = resize(111,32)) and not((((shift_right(encodedInstr,resize(31,32))) and resize(1,32)) = resize(0,32)))) then unsigned((unsigned(resize(-1048576,32)) or (((encodedInstr and resize(1044480,32)) or ((shift_right(encodedInstr,resize(9,32))) and resize(2048,32))) or ((shift_right(encodedInstr,resize(20,32))) and resize(2046,32)))))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getInstrType(encodedInstr: unsigned) : InstrType := 
	if (((encodedInstr and resize(127,32)) = resize(51,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32)) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) then (INSTR_ADD)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32))) then (INSTR_SUB)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) then (INSTR_SLL)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) then (INSTR_SLT)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) then (INSTR_SLTU)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) then (INSTR_XOR)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) then (INSTR_SRL)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32))) then (INSTR_SRA)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) then (INSTR_OR)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32))) then (INSTR_AND)
	elsif (((encodedInstr and resize(127,32)) = resize(51,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) then (INSTR_ADDI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) then (INSTR_SLLI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) then (INSTR_SLTI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) then (INSTR_SLTIU)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) then (INSTR_XORI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) then (INSTR_SRLI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32))) then (INSTR_SRAI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(25,32))) and resize(127,32)) = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) then (INSTR_ORI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32))) then (INSTR_ANDI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(3,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) then (INSTR_LB)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) then (INSTR_LH)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) then (INSTR_LW)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) then (INSTR_LBU)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) then (INSTR_LHU)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(103,32))) then (INSTR_JALR)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) then (INSTR_SB)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) then (INSTR_SH)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32))) then (INSTR_SW)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(2,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) then (INSTR_BEQ)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) then (INSTR_BNE)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) then (INSTR_BLT)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) then (INSTR_BGE)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) then (INSTR_BLTU)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and (((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32))) then (INSTR_BGEU)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32)) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(0,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(1,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(4,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(5,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(6,32))) and not((((shift_right(encodedInstr,resize(12,32))) and resize(7,32)) = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and ((encodedInstr and resize(127,32)) = resize(55,32))) then (INSTR_LUI)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and ((encodedInstr and resize(127,32)) = resize(23,32))) then (INSTR_AUIPC)
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and not(((encodedInstr and resize(127,32)) = resize(99,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and not(((encodedInstr and resize(127,32)) = resize(23,32))) and ((encodedInstr and resize(127,32)) = resize(111,32))) then (INSTR_JAL)
	else (INSTR_UNKNOWN)
end if;
end macro; 

macro getMemoryMask(instr: InstrType) : ME_MaskType := 
	if (((instr = INSTR_LW) or (instr = INSTR_SW))) then (MT_W)
	elsif (not(((instr = INSTR_LW) or (instr = INSTR_SW))) and ((instr = INSTR_LH) or (instr = INSTR_SH))) then (MT_H)
	elsif (not(((instr = INSTR_LW) or (instr = INSTR_SW))) and not(((instr = INSTR_LH) or (instr = INSTR_SH))) and ((instr = INSTR_LB) or (instr = INSTR_SB))) then (MT_B)
	elsif (not(((instr = INSTR_LW) or (instr = INSTR_SW))) and not(((instr = INSTR_LH) or (instr = INSTR_SH))) and not(((instr = INSTR_LB) or (instr = INSTR_SB))) and (instr = INSTR_LHU)) then (MT_HU)
	elsif (not(((instr = INSTR_LW) or (instr = INSTR_SW))) and not(((instr = INSTR_LH) or (instr = INSTR_SH))) and not(((instr = INSTR_LB) or (instr = INSTR_SB))) and not((instr = INSTR_LHU)) and (instr = INSTR_LBU)) then (MT_BU)
	else (MT_X)
end if;
end macro; 

macro getRdAddr(encodedInstr: unsigned) : unsigned := 
	if (((encodedInstr and resize(127,32)) = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(103,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(55,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and ((encodedInstr and resize(127,32)) = resize(23,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(55,32))) and not(((encodedInstr and resize(127,32)) = resize(23,32))) and ((encodedInstr and resize(127,32)) = resize(111,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and resize(31,32)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getRs1Addr(encodedInstr: unsigned) : unsigned := 
	if (((encodedInstr and resize(127,32)) = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(19,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and ((encodedInstr and resize(127,32)) = resize(3,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and ((encodedInstr and resize(127,32)) = resize(103,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and ((encodedInstr and resize(127,32)) = resize(35,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(19,32))) and not(((encodedInstr and resize(127,32)) = resize(3,32))) and not(((encodedInstr and resize(127,32)) = resize(103,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and resize(31,32)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getRs2Addr(encodedInstr: unsigned) : unsigned := 
	if (((encodedInstr and resize(127,32)) = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and ((encodedInstr and resize(127,32)) = resize(35,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and resize(31,32)))
	elsif (not(((encodedInstr and resize(127,32)) = resize(51,32))) and not(((encodedInstr and resize(127,32)) = resize(35,32))) and ((encodedInstr and resize(127,32)) = resize(99,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and resize(31,32)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro readRegfile(RFtoISA_data_reg_file_01: unsigned;RFtoISA_data_reg_file_02: unsigned;RFtoISA_data_reg_file_03: unsigned;RFtoISA_data_reg_file_04: unsigned;RFtoISA_data_reg_file_05: unsigned;RFtoISA_data_reg_file_06: unsigned;RFtoISA_data_reg_file_07: unsigned;RFtoISA_data_reg_file_08: unsigned;RFtoISA_data_reg_file_09: unsigned;RFtoISA_data_reg_file_10: unsigned;RFtoISA_data_reg_file_11: unsigned;RFtoISA_data_reg_file_12: unsigned;RFtoISA_data_reg_file_13: unsigned;RFtoISA_data_reg_file_14: unsigned;RFtoISA_data_reg_file_15: unsigned;RFtoISA_data_reg_file_16: unsigned;RFtoISA_data_reg_file_17: unsigned;RFtoISA_data_reg_file_18: unsigned;RFtoISA_data_reg_file_19: unsigned;RFtoISA_data_reg_file_20: unsigned;RFtoISA_data_reg_file_21: unsigned;RFtoISA_data_reg_file_22: unsigned;RFtoISA_data_reg_file_23: unsigned;RFtoISA_data_reg_file_24: unsigned;RFtoISA_data_reg_file_25: unsigned;RFtoISA_data_reg_file_26: unsigned;RFtoISA_data_reg_file_27: unsigned;RFtoISA_data_reg_file_28: unsigned;RFtoISA_data_reg_file_29: unsigned;RFtoISA_data_reg_file_30: unsigned;RFtoISA_data_reg_file_31: unsigned;src: unsigned) : unsigned := 
	if ((src = resize(0,32))) then unsigned(resize(0,32))
	elsif (not((src = resize(0,32))) and (src = resize(1,32))) then unsigned(RFtoISA_data_reg_file_01)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and (src = resize(2,32))) then unsigned(RFtoISA_data_reg_file_02)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and (src = resize(3,32))) then unsigned(RFtoISA_data_reg_file_03)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and (src = resize(4,32))) then unsigned(RFtoISA_data_reg_file_04)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and (src = resize(5,32))) then unsigned(RFtoISA_data_reg_file_05)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and (src = resize(6,32))) then unsigned(RFtoISA_data_reg_file_06)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and (src = resize(7,32))) then unsigned(RFtoISA_data_reg_file_07)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and (src = resize(8,32))) then unsigned(RFtoISA_data_reg_file_08)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and (src = resize(9,32))) then unsigned(RFtoISA_data_reg_file_09)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and (src = resize(10,32))) then unsigned(RFtoISA_data_reg_file_10)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and (src = resize(11,32))) then unsigned(RFtoISA_data_reg_file_11)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and (src = resize(12,32))) then unsigned(RFtoISA_data_reg_file_12)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and (src = resize(13,32))) then unsigned(RFtoISA_data_reg_file_13)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and (src = resize(14,32))) then unsigned(RFtoISA_data_reg_file_14)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and (src = resize(15,32))) then unsigned(RFtoISA_data_reg_file_15)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and (src = resize(16,32))) then unsigned(RFtoISA_data_reg_file_16)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and (src = resize(17,32))) then unsigned(RFtoISA_data_reg_file_17)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and (src = resize(18,32))) then unsigned(RFtoISA_data_reg_file_18)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and (src = resize(19,32))) then unsigned(RFtoISA_data_reg_file_19)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and (src = resize(20,32))) then unsigned(RFtoISA_data_reg_file_20)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and (src = resize(21,32))) then unsigned(RFtoISA_data_reg_file_21)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and (src = resize(22,32))) then unsigned(RFtoISA_data_reg_file_22)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and (src = resize(23,32))) then unsigned(RFtoISA_data_reg_file_23)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and (src = resize(24,32))) then unsigned(RFtoISA_data_reg_file_24)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and (src = resize(25,32))) then unsigned(RFtoISA_data_reg_file_25)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and (src = resize(26,32))) then unsigned(RFtoISA_data_reg_file_26)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and (src = resize(27,32))) then unsigned(RFtoISA_data_reg_file_27)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and (src = resize(28,32))) then unsigned(RFtoISA_data_reg_file_28)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and not((src = resize(28,32))) and (src = resize(29,32))) then unsigned(RFtoISA_data_reg_file_29)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and not((src = resize(28,32))) and not((src = resize(29,32))) and (src = resize(30,32))) then unsigned(RFtoISA_data_reg_file_30)
	else unsigned(RFtoISA_data_reg_file_31)
end if;
end macro; 



-- VISIBLE REGISTERS --
macro ISAtoMEM_data_addrIn : unsigned := ISAtoMEM_data.addrIn end macro; 
macro ISAtoMEM_data_dataIn : unsigned := ISAtoMEM_data.dataIn end macro; 
macro ISAtoMEM_data_mask : ME_MaskType := ISAtoMEM_data.mask end macro; 
macro ISAtoMEM_data_req : ME_AccessType := ISAtoMEM_data.req end macro; 
macro decodedInstr_rd_addr : unsigned := decodedInstr.rd_addr end macro; 
--macro pcReg : unsigned := end macro; 


-- STATES -- 
--macro fetch_6 : boolean := true end macro;
--macro fetch_7 : boolean := true end macro;
--macro memory_8 : boolean := true end macro;
--macro memory_9 : boolean := true end macro;
--macro memory_10 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_6;
	 at t: ISAtoMEM_data_addrIn = resize(0,32);
	 at t: ISAtoMEM_data_dataIn = resize(0,32);
	 at t: ISAtoMEM_data_mask = MT_W;
	 at t: ISAtoMEM_data_req = ME_RD;
	 at t: ISAtoMEM_port_sig_addrIn = resize(0,32);
	 at t: ISAtoMEM_port_sig_dataIn = resize(0,32);
	 at t: ISAtoMEM_port_sig_mask = MT_W;
	 at t: ISAtoMEM_port_sig_req = ME_RD;
	 at t: decodedInstr_rd_addr = resize(0,32);
	 at t: pcReg = resize(0,32);
	 at t: ISAtoMEM_port_notify = true;
	 at t: ISAtoRF_port_notify = false;
	 at t: MEMtoISA_port_notify = false;
end property;


property fetch_6_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_6;
	 at t: ISAtoMEM_port_sync;
prove:
	 at t_end: fetch_7;
	 at t_end: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t_end: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 during[t+1, t_end]: ISAtoMEM_port_notify = false;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end-1]: MEMtoISA_port_notify = false;
	 at t_end: MEMtoISA_port_notify = true;
end property;

property fetch_7_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_I));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_L));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = pcReg_at_t;
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ);
	 at t: (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE);
	 at t: not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE) and not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)))));
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLT);
	 at t: (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE) and not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGE);
	 at t: (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE) and not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLTU);
	 at t: (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE) and not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGEU);
	 at t: (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_B);
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BNE) and not((getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32)))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(1,32))));
	 at t: not(((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_BGEU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs1Addr(MEMtoISA_port_sig_loadedData)), readRegfile(RFtoISA_port_sig_reg_file_01,RFtoISA_port_sig_reg_file_02,RFtoISA_port_sig_reg_file_03,RFtoISA_port_sig_reg_file_04,RFtoISA_port_sig_reg_file_05,RFtoISA_port_sig_reg_file_06,RFtoISA_port_sig_reg_file_07,RFtoISA_port_sig_reg_file_08,RFtoISA_port_sig_reg_file_09,RFtoISA_port_sig_reg_file_10,RFtoISA_port_sig_reg_file_11,RFtoISA_port_sig_reg_file_12,RFtoISA_port_sig_reg_file_13,RFtoISA_port_sig_reg_file_14,RFtoISA_port_sig_reg_file_15,RFtoISA_port_sig_reg_file_16,RFtoISA_port_sig_reg_file_17,RFtoISA_port_sig_reg_file_18,RFtoISA_port_sig_reg_file_19,RFtoISA_port_sig_reg_file_20,RFtoISA_port_sig_reg_file_21,RFtoISA_port_sig_reg_file_22,RFtoISA_port_sig_reg_file_23,RFtoISA_port_sig_reg_file_24,RFtoISA_port_sig_reg_file_25,RFtoISA_port_sig_reg_file_26,RFtoISA_port_sig_reg_file_27,RFtoISA_port_sig_reg_file_28,RFtoISA_port_sig_reg_file_29,RFtoISA_port_sig_reg_file_30,RFtoISA_port_sig_reg_file_31, getRs2Addr(MEMtoISA_port_sig_loadedData))) = resize(0,32))));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_S);
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_S);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: memory_8;
	 at t_end: ISAtoMEM_data_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs2Addr(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_req = ME_WR;
	 at t_end: ISAtoMEM_port_sig_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs2Addr(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_req = ME_WR;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_S);
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: memory_9;
	 at t_end: ISAtoMEM_data_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_I));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_L);
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_S);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: memory_8;
	 at t_end: ISAtoMEM_data_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs2Addr(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_req = ME_WR;
	 at t_end: ISAtoMEM_port_sig_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_dataIn = readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs2Addr(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_req = ME_WR;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_I));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_L);
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: memory_9;
	 at t_end: ISAtoMEM_data_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = getMemoryMask(getInstrType(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_J);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (pcReg_at_t + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_14 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_U);
	 at t: (getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_LUI);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t), 0);
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_15 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_U);
	 at t: not((getInstrType(MEMtoISA_port_sig_loadedData) = INSTR_LUI));
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), pcReg_at_t, getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_16 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_R);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs2Addr(MEMtoISA_port_sig_loadedData_at_t)));
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_17 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_J));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_J);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)) + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)) + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)) + getImmediate(MEMtoISA_port_sig_loadedData_at_t))(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property fetch_7_read_18 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	RFtoISA_port_sig_reg_file_01_at_t = RFtoISA_port_sig_reg_file_01@t,
	RFtoISA_port_sig_reg_file_02_at_t = RFtoISA_port_sig_reg_file_02@t,
	RFtoISA_port_sig_reg_file_03_at_t = RFtoISA_port_sig_reg_file_03@t,
	RFtoISA_port_sig_reg_file_04_at_t = RFtoISA_port_sig_reg_file_04@t,
	RFtoISA_port_sig_reg_file_05_at_t = RFtoISA_port_sig_reg_file_05@t,
	RFtoISA_port_sig_reg_file_06_at_t = RFtoISA_port_sig_reg_file_06@t,
	RFtoISA_port_sig_reg_file_07_at_t = RFtoISA_port_sig_reg_file_07@t,
	RFtoISA_port_sig_reg_file_08_at_t = RFtoISA_port_sig_reg_file_08@t,
	RFtoISA_port_sig_reg_file_09_at_t = RFtoISA_port_sig_reg_file_09@t,
	RFtoISA_port_sig_reg_file_10_at_t = RFtoISA_port_sig_reg_file_10@t,
	RFtoISA_port_sig_reg_file_11_at_t = RFtoISA_port_sig_reg_file_11@t,
	RFtoISA_port_sig_reg_file_12_at_t = RFtoISA_port_sig_reg_file_12@t,
	RFtoISA_port_sig_reg_file_13_at_t = RFtoISA_port_sig_reg_file_13@t,
	RFtoISA_port_sig_reg_file_14_at_t = RFtoISA_port_sig_reg_file_14@t,
	RFtoISA_port_sig_reg_file_15_at_t = RFtoISA_port_sig_reg_file_15@t,
	RFtoISA_port_sig_reg_file_16_at_t = RFtoISA_port_sig_reg_file_16@t,
	RFtoISA_port_sig_reg_file_17_at_t = RFtoISA_port_sig_reg_file_17@t,
	RFtoISA_port_sig_reg_file_18_at_t = RFtoISA_port_sig_reg_file_18@t,
	RFtoISA_port_sig_reg_file_19_at_t = RFtoISA_port_sig_reg_file_19@t,
	RFtoISA_port_sig_reg_file_20_at_t = RFtoISA_port_sig_reg_file_20@t,
	RFtoISA_port_sig_reg_file_21_at_t = RFtoISA_port_sig_reg_file_21@t,
	RFtoISA_port_sig_reg_file_22_at_t = RFtoISA_port_sig_reg_file_22@t,
	RFtoISA_port_sig_reg_file_23_at_t = RFtoISA_port_sig_reg_file_23@t,
	RFtoISA_port_sig_reg_file_24_at_t = RFtoISA_port_sig_reg_file_24@t,
	RFtoISA_port_sig_reg_file_25_at_t = RFtoISA_port_sig_reg_file_25@t,
	RFtoISA_port_sig_reg_file_26_at_t = RFtoISA_port_sig_reg_file_26@t,
	RFtoISA_port_sig_reg_file_27_at_t = RFtoISA_port_sig_reg_file_27@t,
	RFtoISA_port_sig_reg_file_28_at_t = RFtoISA_port_sig_reg_file_28@t,
	RFtoISA_port_sig_reg_file_29_at_t = RFtoISA_port_sig_reg_file_29@t,
	RFtoISA_port_sig_reg_file_30_at_t = RFtoISA_port_sig_reg_file_30@t,
	RFtoISA_port_sig_reg_file_31_at_t = RFtoISA_port_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_R));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_B));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_S));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_U));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_J));
	 at t: not((getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_J));
	 at t: (getEncType(MEMtoISA_port_sig_loadedData) = ENC_I_I);
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: ISAtoRF_port_sig_dstData = getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig_loadedData_at_t)), readRegfile(RFtoISA_port_sig_reg_file_01_at_t,RFtoISA_port_sig_reg_file_02_at_t,RFtoISA_port_sig_reg_file_03_at_t,RFtoISA_port_sig_reg_file_04_at_t,RFtoISA_port_sig_reg_file_05_at_t,RFtoISA_port_sig_reg_file_06_at_t,RFtoISA_port_sig_reg_file_07_at_t,RFtoISA_port_sig_reg_file_08_at_t,RFtoISA_port_sig_reg_file_09_at_t,RFtoISA_port_sig_reg_file_10_at_t,RFtoISA_port_sig_reg_file_11_at_t,RFtoISA_port_sig_reg_file_12_at_t,RFtoISA_port_sig_reg_file_13_at_t,RFtoISA_port_sig_reg_file_14_at_t,RFtoISA_port_sig_reg_file_15_at_t,RFtoISA_port_sig_reg_file_16_at_t,RFtoISA_port_sig_reg_file_17_at_t,RFtoISA_port_sig_reg_file_18_at_t,RFtoISA_port_sig_reg_file_19_at_t,RFtoISA_port_sig_reg_file_20_at_t,RFtoISA_port_sig_reg_file_21_at_t,RFtoISA_port_sig_reg_file_22_at_t,RFtoISA_port_sig_reg_file_23_at_t,RFtoISA_port_sig_reg_file_24_at_t,RFtoISA_port_sig_reg_file_25_at_t,RFtoISA_port_sig_reg_file_26_at_t,RFtoISA_port_sig_reg_file_27_at_t,RFtoISA_port_sig_reg_file_28_at_t,RFtoISA_port_sig_reg_file_29_at_t,RFtoISA_port_sig_reg_file_30_at_t,RFtoISA_port_sig_reg_file_31_at_t, getRs1Addr(MEMtoISA_port_sig_loadedData_at_t)), getImmediate(MEMtoISA_port_sig_loadedData_at_t));
	 at t_end: decodedInstr_rd_addr = getRdAddr(MEMtoISA_port_sig_loadedData_at_t);
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property memory_8_write_19 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_8;
	 at t: ISAtoMEM_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property memory_9_write_20 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_9;
	 at t: ISAtoMEM_port_sync;
prove:
	 at t_end: memory_10;
	 at t_end: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t_end: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 during[t+1, t_end]: ISAtoMEM_port_notify = false;
	 during[t+1, t_end]: ISAtoRF_port_notify = false;
	 during[t+1, t_end-1]: MEMtoISA_port_notify = false;
	 at t_end: MEMtoISA_port_notify = true;
end property;

property memory_10_read_21 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	MEMtoISA_port_sig_loadedData_at_t = MEMtoISA_port_sig_loadedData@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_10;
	 at t: MEMtoISA_port_sync;
prove:
	 at t_end: fetch_6;
	 at t_end: ISAtoMEM_data_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_data_mask = MT_W;
	 at t_end: ISAtoMEM_data_req = ME_RD;
	 at t_end: ISAtoMEM_port_sig_addrIn = pcReg_at_t;
	 at t_end: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t_end: ISAtoMEM_port_sig_mask = MT_W;
	 at t_end: ISAtoMEM_port_sig_req = ME_RD;
	 at t_end: ISAtoRF_port_sig_dst = decodedInstr_rd_addr_at_t;
	 at t_end: ISAtoRF_port_sig_dstData = MEMtoISA_port_sig_loadedData_at_t;
	 at t_end: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 during[t+1, t_end-1]: ISAtoMEM_port_notify = false;
	 at t_end: ISAtoMEM_port_notify = true;
	 during[t+1, t_end-1]: ISAtoRF_port_notify = false;
	 at t_end: ISAtoRF_port_notify = true;
	 during[t+1, t_end]: MEMtoISA_port_notify = false;
end property;

property wait_fetch_6 is
dependencies: no_reset;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_6;
	 at t: not(ISAtoMEM_port_sync);
prove:
	 at t+1: fetch_6;
	 at t+1: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t+1: ISAtoMEM_port_sig_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_port_sig_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_port_sig_req = ISAtoMEM_data_req_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: ISAtoMEM_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
	 at t+1: MEMtoISA_port_notify = false;
end property;

property wait_fetch_7 is
dependencies: no_reset;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_7;
	 at t: not(MEMtoISA_port_sync);
prove:
	 at t+1: fetch_7;
	 at t+1: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: ISAtoMEM_port_notify = false;
	 at t+1: ISAtoRF_port_notify = false;
	 at t+1: MEMtoISA_port_notify = true;
end property;

property wait_memory_8 is
dependencies: no_reset;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_8;
	 at t: not(ISAtoMEM_port_sync);
prove:
	 at t+1: memory_8;
	 at t+1: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t+1: ISAtoMEM_port_sig_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_port_sig_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_port_sig_req = ISAtoMEM_data_req_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: ISAtoMEM_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
	 at t+1: MEMtoISA_port_notify = false;
end property;

property wait_memory_9 is
dependencies: no_reset;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_9;
	 at t: not(ISAtoMEM_port_sync);
prove:
	 at t+1: memory_9;
	 at t+1: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t+1: ISAtoMEM_port_sig_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_port_sig_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_port_sig_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_port_sig_req = ISAtoMEM_data_req_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: ISAtoMEM_port_notify = true;
	 at t+1: ISAtoRF_port_notify = false;
	 at t+1: MEMtoISA_port_notify = false;
end property;

property wait_memory_10 is
dependencies: no_reset;
freeze:
	ISAtoMEM_data_addrIn_at_t = ISAtoMEM_data_addrIn@t,
	ISAtoMEM_data_dataIn_at_t = ISAtoMEM_data_dataIn@t,
	ISAtoMEM_data_mask_at_t = ISAtoMEM_data_mask@t,
	ISAtoMEM_data_req_at_t = ISAtoMEM_data_req@t,
	decodedInstr_rd_addr_at_t = decodedInstr_rd_addr@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: memory_10;
	 at t: not(MEMtoISA_port_sync);
prove:
	 at t+1: memory_10;
	 at t+1: ISAtoMEM_data_addrIn = ISAtoMEM_data_addrIn_at_t;
	 at t+1: ISAtoMEM_data_dataIn = ISAtoMEM_data_dataIn_at_t;
	 at t+1: ISAtoMEM_data_mask = ISAtoMEM_data_mask_at_t;
	 at t+1: ISAtoMEM_data_req = ISAtoMEM_data_req_at_t;
	 at t+1: decodedInstr_rd_addr = decodedInstr_rd_addr_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: ISAtoMEM_port_notify = false;
	 at t+1: ISAtoRF_port_notify = false;
	 at t+1: MEMtoISA_port_notify = true;
end property;