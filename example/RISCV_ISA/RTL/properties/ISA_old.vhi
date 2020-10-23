-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro fromMemoryPort_notify :  boolean  := end macro; 
--macro fromMemoryPort_sync   :  boolean  := end macro; 
--macro toMemoryPort_notify :  boolean  := end macro; 
--macro toMemoryPort_sync   :  boolean  := end macro; 
--macro toRegsPort_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro fromMemoryPort_sig_loadedData : unsigned := fromMemoryPort.loadedData end macro; 
macro fromRegsPort_sig_reg_file_01 : unsigned := fromRegsPort.reg_file_01 end macro; 
macro fromRegsPort_sig_reg_file_02 : unsigned := fromRegsPort.reg_file_02 end macro; 
macro fromRegsPort_sig_reg_file_03 : unsigned := fromRegsPort.reg_file_03 end macro; 
macro fromRegsPort_sig_reg_file_04 : unsigned := fromRegsPort.reg_file_04 end macro; 
macro fromRegsPort_sig_reg_file_05 : unsigned := fromRegsPort.reg_file_05 end macro; 
macro fromRegsPort_sig_reg_file_06 : unsigned := fromRegsPort.reg_file_06 end macro; 
macro fromRegsPort_sig_reg_file_07 : unsigned := fromRegsPort.reg_file_07 end macro; 
macro fromRegsPort_sig_reg_file_08 : unsigned := fromRegsPort.reg_file_08 end macro; 
macro fromRegsPort_sig_reg_file_09 : unsigned := fromRegsPort.reg_file_09 end macro; 
macro fromRegsPort_sig_reg_file_10 : unsigned := fromRegsPort.reg_file_10 end macro; 
macro fromRegsPort_sig_reg_file_11 : unsigned := fromRegsPort.reg_file_11 end macro; 
macro fromRegsPort_sig_reg_file_12 : unsigned := fromRegsPort.reg_file_12 end macro; 
macro fromRegsPort_sig_reg_file_13 : unsigned := fromRegsPort.reg_file_13 end macro; 
macro fromRegsPort_sig_reg_file_14 : unsigned := fromRegsPort.reg_file_14 end macro; 
macro fromRegsPort_sig_reg_file_15 : unsigned := fromRegsPort.reg_file_15 end macro; 
macro fromRegsPort_sig_reg_file_16 : unsigned := fromRegsPort.reg_file_16 end macro; 
macro fromRegsPort_sig_reg_file_17 : unsigned := fromRegsPort.reg_file_17 end macro; 
macro fromRegsPort_sig_reg_file_18 : unsigned := fromRegsPort.reg_file_18 end macro; 
macro fromRegsPort_sig_reg_file_19 : unsigned := fromRegsPort.reg_file_19 end macro; 
macro fromRegsPort_sig_reg_file_20 : unsigned := fromRegsPort.reg_file_20 end macro; 
macro fromRegsPort_sig_reg_file_21 : unsigned := fromRegsPort.reg_file_21 end macro; 
macro fromRegsPort_sig_reg_file_22 : unsigned := fromRegsPort.reg_file_22 end macro; 
macro fromRegsPort_sig_reg_file_23 : unsigned := fromRegsPort.reg_file_23 end macro; 
macro fromRegsPort_sig_reg_file_24 : unsigned := fromRegsPort.reg_file_24 end macro; 
macro fromRegsPort_sig_reg_file_25 : unsigned := fromRegsPort.reg_file_25 end macro; 
macro fromRegsPort_sig_reg_file_26 : unsigned := fromRegsPort.reg_file_26 end macro; 
macro fromRegsPort_sig_reg_file_27 : unsigned := fromRegsPort.reg_file_27 end macro; 
macro fromRegsPort_sig_reg_file_28 : unsigned := fromRegsPort.reg_file_28 end macro; 
macro fromRegsPort_sig_reg_file_29 : unsigned := fromRegsPort.reg_file_29 end macro; 
macro fromRegsPort_sig_reg_file_30 : unsigned := fromRegsPort.reg_file_30 end macro; 
macro fromRegsPort_sig_reg_file_31 : unsigned := fromRegsPort.reg_file_31 end macro; 
macro toMemoryPort_sig_addrIn : unsigned := toMemoryPort.addrIn end macro; 
macro toMemoryPort_sig_dataIn : unsigned := toMemoryPort.dataIn end macro; 
macro toMemoryPort_sig_mask : ME_MaskType := toMemoryPort.mask end macro; 
macro toMemoryPort_sig_req : ME_AccessType := toMemoryPort.req end macro; 
macro toRegsPort_sig_dst : unsigned := toRegsPort.dst end macro; 
macro toRegsPort_sig_dstData : unsigned := toRegsPort.dstData end macro;


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- FUNCTIONS --
macro branchPCcalculation(aluResult: unsigned;encodedInstr: unsigned;pcReg: unsigned) : unsigned := 
	if (((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	elsif (not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) and ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BNE) and (aluResult /= resize(0,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	elsif (not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BNE) and (aluResult /= resize(0,32)))) and ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLT) and (aluResult = resize(1,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	elsif (not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BNE) and (aluResult /= resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLT) and (aluResult = resize(1,32)))) and ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BGE) and (aluResult = resize(0,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	elsif (not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BNE) and (aluResult /= resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLT) and (aluResult = resize(1,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BGE) and (aluResult = resize(0,32)))) and ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLTU) and (aluResult = resize(1,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	elsif (not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BEQ) and (aluResult = resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BNE) and (aluResult /= resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLT) and (aluResult = resize(1,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BGE) and (aluResult = resize(0,32)))) and not(((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BLTU) and (aluResult = resize(1,32)))) and ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_BGEU) and (aluResult = resize(0,32)))) then unsigned((pcReg + getImmediate(encodedInstr,getOpcode(encodedInstr)))(31 downto 0))
	else unsigned((pcReg + resize(4,32))(31 downto 0))
end if;
end macro; 

macro getALUfunc(instr: InstrType) : ALUfuncType := 
	if (((instr = INSTR_ADD) or (instr = INSTR_ADDI))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and (instr = INSTR_SUB)) then (ALU_SUB)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and ((instr = INSTR_SLL) or (instr = INSTR_SLLI))) then (ALU_SLL)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and ((instr = INSTR_SLT) or (instr = INSTR_SLTI))) then (ALU_SLT)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and ((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) then (ALU_SLTU)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and ((instr = INSTR_XOR) or (instr = INSTR_XORI))) then (ALU_XOR)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and ((instr = INSTR_SRL) or (instr = INSTR_SRLI))) then (ALU_SRL)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and ((instr = INSTR_SRA) or (instr = INSTR_SRAI))) then (ALU_SRA)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and ((instr = INSTR_OR) or (instr = INSTR_ORI))) then (ALU_OR)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and ((instr = INSTR_AND) or (instr = INSTR_ANDI))) then (ALU_AND)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and (((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and ((instr = INSTR_JALR) or (instr = INSTR_JAL))) then (ALU_X)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and ((instr = INSTR_BEQ) or (instr = INSTR_BNE))) then (ALU_SUB)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and ((instr = INSTR_BLT) or (instr = INSTR_BGE))) then (ALU_SLT)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and ((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) then (ALU_SLTU)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and (((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and not((((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) and (instr = INSTR_AUIPC)) then (ALU_ADD)
	elsif (not(((instr = INSTR_ADD) or (instr = INSTR_ADDI))) and not((instr = INSTR_SUB)) and not(((instr = INSTR_SLL) or (instr = INSTR_SLLI))) and not(((instr = INSTR_SLT) or (instr = INSTR_SLTI))) and not(((instr = INSTR_SLTU) or (instr = INSTR_SLTUI))) and not(((instr = INSTR_XOR) or (instr = INSTR_XORI))) and not(((instr = INSTR_SRL) or (instr = INSTR_SRLI))) and not(((instr = INSTR_SRA) or (instr = INSTR_SRAI))) and not(((instr = INSTR_OR) or (instr = INSTR_ORI))) and not(((instr = INSTR_AND) or (instr = INSTR_ANDI))) and not((((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU))) and not(((instr = INSTR_JALR) or (instr = INSTR_JAL))) and not(((instr = INSTR_BEQ) or (instr = INSTR_BNE))) and not(((instr = INSTR_BLT) or (instr = INSTR_BGE))) and not(((instr = INSTR_BLTU) or (instr = INSTR_BGEU))) and not((((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW))) and not((instr = INSTR_AUIPC)) and (instr = INSTR_LUI)) then (ALU_COPY1)
	else (ALU_X)
end if;
end macro; 

macro getALUresult(aluFunction: ALUfuncType;operand1: unsigned;operand2: unsigned) : unsigned := 
	if ((aluFunction = ALU_ADD)) then unsigned((operand1 + operand2)(31 downto 0))
	elsif (not((aluFunction = ALU_ADD)) and (aluFunction = ALU_SUB)) then unsigned((operand1 + (operand2 * resize(4294967295,32))(31 downto 0))(31 downto 0))
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

macro getEncType(opcode: unsigned) : EncType := 
	if ((opcode = resize(51,32))) then (ENC_R)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32))) then (ENC_I_I)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32))) then (ENC_I_L)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(103,32))) then (ENC_I_J)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32))) then (ENC_S)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32))) then (ENC_B)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(99,32))) and ((opcode = resize(55,32)) or (opcode = resize(23,32)))) then (ENC_U)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(99,32))) and not(((opcode = resize(55,32)) or (opcode = resize(23,32)))) and (opcode = resize(111,32))) then (ENC_J)
	else (ENC_ERR)
end if;
end macro; 

macro getEncUALUresult(encodedInstr: unsigned;pcReg: unsigned) : unsigned := 
	if ((getInstrType(getFunct3(encodedInstr),getFunct7(encodedInstr),getOpcode(encodedInstr)) = INSTR_LUI)) then unsigned(getALUresult(ALU_COPY1,getImmediate(encodedInstr,getOpcode(encodedInstr)),resize(0,32)))
	else unsigned(getALUresult(ALU_ADD,pcReg,getImmediate(encodedInstr,getOpcode(encodedInstr))))
end if;
end macro; 

macro getFunct3(encodedInstr: unsigned) : unsigned := 
	unsigned(((shift_right(encodedInstr,resize(12,32))) and ((shift_left(resize(1,32),((resize(14,32) - resize(12,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)));
end macro; 

macro getFunct7(encodedInstr: unsigned) : unsigned := 
	unsigned(((shift_right(encodedInstr,resize(25,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(25,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)));
end macro; 

macro getImmediate(encodedInstr: unsigned;opcode: unsigned) : unsigned := 
	if ((opcode = resize(19,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))
	elsif ((opcode = resize(19,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(19,32))) and (opcode = resize(3,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))
	elsif (not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(99,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(31,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(19,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_left(resize(1,32),resize(19,32))) - resize(1,32))(31 downto 0),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(2,32))) - resize(1,32))(31 downto 0),resize(10,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left(((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(7,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))),resize(10,32)))) or (((shift_left(resize(1,32),resize(10,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(6,32))) - resize(1,32))(31 downto 0),resize(4,32))) and (shift_left(((shift_right(encodedInstr,resize(25,32))) and ((shift_left(resize(1,32),((resize(30,32) - resize(25,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(4,32)))) or (((shift_left(resize(1,32),resize(4,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(8,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))))),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(99,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(31,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(2,32))) - resize(1,32))(31 downto 0),resize(10,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left(((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(7,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))),resize(10,32)))) or (((shift_left(resize(1,32),resize(10,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(6,32))) - resize(1,32))(31 downto 0),resize(4,32))) and (shift_left(((shift_right(encodedInstr,resize(25,32))) and ((shift_left(resize(1,32),((resize(30,32) - resize(25,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(4,32)))) or (((shift_left(resize(1,32),resize(4,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(8,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(8,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and (opcode = resize(103,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and (opcode = resize(103,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(7,32))) - resize(1,32))(31 downto 0),resize(5,32))) and (shift_left(((shift_right(encodedInstr,resize(25,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(25,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(5,32)))) or (((shift_left(resize(1,32),resize(5,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(7,32))) - resize(1,32))(31 downto 0),resize(5,32))) and (shift_left(((shift_right(encodedInstr,resize(25,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(25,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(5,32)))) or (((shift_left(resize(1,32),resize(5,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(55,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_right(encodedInstr,resize(12,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(12,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(55,32))) and (opcode = resize(23,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0),resize(12,32))) and (shift_left(((shift_right(encodedInstr,resize(12,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(12,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(12,32)))) or (((shift_left(resize(1,32),resize(12,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(55,32))) and not((opcode = resize(23,32))) and (opcode = resize(111,32)) and (((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(31,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(11,32))) - resize(1,32))(31 downto 0),resize(20,32))) and (shift_left(((shift_left(resize(1,32),resize(11,32))) - resize(1,32))(31 downto 0),resize(20,32)))) or (((shift_left(resize(1,32),resize(20,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(9,32))) - resize(1,32))(31 downto 0),resize(11,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(8,32))) and (shift_left(((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(8,32)))) or (((shift_left(resize(1,32),resize(8,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(12,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(12,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))),resize(11,32)))) or (((shift_left(resize(1,32),resize(11,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(10,32))) and (shift_left(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(20,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(10,32)))) or (((shift_left(resize(1,32),resize(10,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(21,32))) and ((shift_left(resize(1,32),((resize(30,32) - resize(21,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))))),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	elsif (not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(99,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(55,32))) and not((opcode = resize(23,32))) and (opcode = resize(111,32)) and not((((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)) = resize(1,32)))) then unsigned((((shift_left(((shift_left(resize(1,32),resize(31,32))) - resize(1,32))(31 downto 0),resize(1,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(9,32))) - resize(1,32))(31 downto 0),resize(11,32))) and (shift_left((((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(8,32))) and (shift_left(((shift_right(encodedInstr,resize(31,32))) and ((shift_left(resize(1,32),((resize(31,32) - resize(31,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(8,32)))) or (((shift_left(resize(1,32),resize(8,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(12,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(12,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))),resize(11,32)))) or (((shift_left(resize(1,32),resize(11,32))) - resize(1,32))(31 downto 0) and (((shift_left(((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0),resize(10,32))) and (shift_left(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(20,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)),resize(10,32)))) or (((shift_left(resize(1,32),resize(10,32))) - resize(1,32))(31 downto 0) and ((shift_right(encodedInstr,resize(21,32))) and ((shift_left(resize(1,32),((resize(30,32) - resize(21,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))))),resize(1,32)))) or (((shift_left(resize(1,32),resize(1,32))) - resize(1,32))(31 downto 0) and resize(0,32))))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getInstrType(funct3: unsigned;funct7: unsigned;opcode: unsigned) : InstrType := 
	if ((opcode = resize(51,32)) and (funct3 = resize(0,32)) and (funct7 = resize(0,32))) then (INSTR_ADD)
	elsif ((opcode = resize(51,32)) and (funct3 = resize(0,32)) and not((funct7 = resize(0,32))) and (funct7 = resize(32,32))) then (INSTR_SUB)
	elsif ((opcode = resize(51,32)) and (funct3 = resize(0,32)) and not((funct7 = resize(0,32))) and not((funct7 = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and (funct3 = resize(1,32))) then (INSTR_SLL)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and (funct3 = resize(2,32))) then (INSTR_SLT)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and (funct3 = resize(3,32))) then (INSTR_SLTU)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and (funct3 = resize(4,32))) then (INSTR_XOR)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and (funct7 = resize(0,32))) then (INSTR_SRL)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and not((funct7 = resize(0,32))) and (funct7 = resize(32,32))) then (INSTR_SRA)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and not((funct7 = resize(0,32))) and not((funct7 = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and (funct3 = resize(6,32))) then (INSTR_OR)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and (funct3 = resize(7,32))) then (INSTR_AND)
	elsif ((opcode = resize(51,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and not((funct3 = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and (funct3 = resize(0,32))) then (INSTR_ADDI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and (funct3 = resize(1,32))) then (INSTR_SLLI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and (funct3 = resize(2,32))) then (INSTR_SLTI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and (funct3 = resize(3,32))) then (INSTR_SLTUI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and (funct3 = resize(4,32))) then (INSTR_XORI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and (funct7 = resize(0,32))) then (INSTR_SRLI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and not((funct7 = resize(0,32))) and (funct7 = resize(32,32))) then (INSTR_SRAI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32)) and not((funct7 = resize(0,32))) and not((funct7 = resize(32,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and (funct3 = resize(6,32))) then (INSTR_ORI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and (funct3 = resize(7,32))) then (INSTR_ANDI)
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(3,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and not((funct3 = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and (funct3 = resize(0,32))) then (INSTR_LB)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((funct3 = resize(0,32))) and (funct3 = resize(1,32))) then (INSTR_LH)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and (funct3 = resize(2,32))) then (INSTR_LW)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and (funct3 = resize(4,32))) then (INSTR_LBU)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32))) then (INSTR_LHU)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(103,32))) then (INSTR_JALR)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and (funct3 = resize(0,32))) then (INSTR_SB)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and not((funct3 = resize(0,32))) and (funct3 = resize(1,32))) then (INSTR_SH)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and (funct3 = resize(2,32))) then (INSTR_SW)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(2,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and (funct3 = resize(0,32))) then (INSTR_BEQ)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and (funct3 = resize(1,32))) then (INSTR_BNE)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and (funct3 = resize(4,32))) then (INSTR_BLT)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(4,32))) and (funct3 = resize(5,32))) then (INSTR_BGE)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and (funct3 = resize(6,32))) then (INSTR_BLTU)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and (funct3 = resize(7,32))) then (INSTR_BGEU)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32)) and not((funct3 = resize(0,32))) and not((funct3 = resize(1,32))) and not((funct3 = resize(4,32))) and not((funct3 = resize(5,32))) and not((funct3 = resize(6,32))) and not((funct3 = resize(7,32)))) then (INSTR_UNKNOWN)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(99,32))) and (opcode = resize(55,32))) then (INSTR_LUI)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(99,32))) and not((opcode = resize(55,32))) and (opcode = resize(23,32))) then (INSTR_AUIPC)
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and not((opcode = resize(99,32))) and not((opcode = resize(55,32))) and not((opcode = resize(23,32))) and (opcode = resize(111,32))) then (INSTR_JAL)
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

macro getOpcode(encodedInstr: unsigned) : unsigned := 
	unsigned(((shift_right(encodedInstr,resize(0,32))) and ((shift_left(resize(1,32),((resize(6,32) - resize(0,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)));
end macro; 

macro getRdAddr(encodedInstr: unsigned;opcode: unsigned) : unsigned := 
	if ((opcode = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(103,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(55,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(55,32))) and (opcode = resize(23,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(55,32))) and not((opcode = resize(23,32))) and (opcode = resize(111,32))) then unsigned(((shift_right(encodedInstr,resize(7,32))) and ((shift_left(resize(1,32),((resize(11,32) - resize(7,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getRs1Addr(encodedInstr: unsigned;opcode: unsigned) : unsigned := 
	if ((opcode = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and (opcode = resize(19,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and (opcode = resize(3,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and (opcode = resize(103,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and (opcode = resize(35,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(19,32))) and not((opcode = resize(3,32))) and not((opcode = resize(103,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32))) then unsigned(((shift_right(encodedInstr,resize(15,32))) and ((shift_left(resize(1,32),((resize(19,32) - resize(15,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro getRs2Addr(encodedInstr: unsigned;opcode: unsigned) : unsigned := 
	if ((opcode = resize(51,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(24,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and (opcode = resize(35,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(24,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	elsif (not((opcode = resize(51,32))) and not((opcode = resize(35,32))) and (opcode = resize(99,32))) then unsigned(((shift_right(encodedInstr,resize(20,32))) and ((shift_left(resize(1,32),((resize(24,32) - resize(20,32))(31 downto 0) + resize(1,32))(31 downto 0))) - resize(1,32))(31 downto 0)))
	else unsigned(resize(0,32))
end if;
end macro; 

macro readRegfile(regfile_reg_file_01: unsigned;regfile_reg_file_02: unsigned;regfile_reg_file_03: unsigned;regfile_reg_file_04: unsigned;regfile_reg_file_05: unsigned;regfile_reg_file_06: unsigned;regfile_reg_file_07: unsigned;regfile_reg_file_08: unsigned;regfile_reg_file_09: unsigned;regfile_reg_file_10: unsigned;regfile_reg_file_11: unsigned;regfile_reg_file_12: unsigned;regfile_reg_file_13: unsigned;regfile_reg_file_14: unsigned;regfile_reg_file_15: unsigned;regfile_reg_file_16: unsigned;regfile_reg_file_17: unsigned;regfile_reg_file_18: unsigned;regfile_reg_file_19: unsigned;regfile_reg_file_20: unsigned;regfile_reg_file_21: unsigned;regfile_reg_file_22: unsigned;regfile_reg_file_23: unsigned;regfile_reg_file_24: unsigned;regfile_reg_file_25: unsigned;regfile_reg_file_26: unsigned;regfile_reg_file_27: unsigned;regfile_reg_file_28: unsigned;regfile_reg_file_29: unsigned;regfile_reg_file_30: unsigned;regfile_reg_file_31: unsigned;src: unsigned) : unsigned := 
	if ((src = resize(0,32))) then unsigned(resize(0,32))
	elsif (not((src = resize(0,32))) and (src = resize(1,32))) then unsigned(regfile_reg_file_01)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and (src = resize(2,32))) then unsigned(regfile_reg_file_02)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and (src = resize(3,32))) then unsigned(regfile_reg_file_03)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and (src = resize(4,32))) then unsigned(regfile_reg_file_04)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and (src = resize(5,32))) then unsigned(regfile_reg_file_05)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and (src = resize(6,32))) then unsigned(regfile_reg_file_06)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and (src = resize(7,32))) then unsigned(regfile_reg_file_07)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and (src = resize(8,32))) then unsigned(regfile_reg_file_08)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and (src = resize(9,32))) then unsigned(regfile_reg_file_09)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and (src = resize(10,32))) then unsigned(regfile_reg_file_10)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and (src = resize(11,32))) then unsigned(regfile_reg_file_11)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and (src = resize(12,32))) then unsigned(regfile_reg_file_12)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and (src = resize(13,32))) then unsigned(regfile_reg_file_13)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and (src = resize(14,32))) then unsigned(regfile_reg_file_14)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and (src = resize(15,32))) then unsigned(regfile_reg_file_15)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and (src = resize(16,32))) then unsigned(regfile_reg_file_16)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and (src = resize(17,32))) then unsigned(regfile_reg_file_17)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and (src = resize(18,32))) then unsigned(regfile_reg_file_18)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and (src = resize(19,32))) then unsigned(regfile_reg_file_19)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and (src = resize(20,32))) then unsigned(regfile_reg_file_20)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and (src = resize(21,32))) then unsigned(regfile_reg_file_21)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and (src = resize(22,32))) then unsigned(regfile_reg_file_22)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and (src = resize(23,32))) then unsigned(regfile_reg_file_23)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and (src = resize(24,32))) then unsigned(regfile_reg_file_24)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and (src = resize(25,32))) then unsigned(regfile_reg_file_25)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and (src = resize(26,32))) then unsigned(regfile_reg_file_26)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and (src = resize(27,32))) then unsigned(regfile_reg_file_27)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and (src = resize(28,32))) then unsigned(regfile_reg_file_28)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and not((src = resize(28,32))) and (src = resize(29,32))) then unsigned(regfile_reg_file_29)
	elsif (not((src = resize(0,32))) and not((src = resize(1,32))) and not((src = resize(2,32))) and not((src = resize(3,32))) and not((src = resize(4,32))) and not((src = resize(5,32))) and not((src = resize(6,32))) and not((src = resize(7,32))) and not((src = resize(8,32))) and not((src = resize(9,32))) and not((src = resize(10,32))) and not((src = resize(11,32))) and not((src = resize(12,32))) and not((src = resize(13,32))) and not((src = resize(14,32))) and not((src = resize(15,32))) and not((src = resize(16,32))) and not((src = resize(17,32))) and not((src = resize(18,32))) and not((src = resize(19,32))) and not((src = resize(20,32))) and not((src = resize(21,32))) and not((src = resize(22,32))) and not((src = resize(23,32))) and not((src = resize(24,32))) and not((src = resize(25,32))) and not((src = resize(26,32))) and not((src = resize(27,32))) and not((src = resize(28,32))) and not((src = resize(29,32))) and (src = resize(30,32))) then unsigned(regfile_reg_file_30)
	else unsigned(regfile_reg_file_31)
end if;
end macro; 



-- VISIBLE REGISTERS --
macro memoryAccess_addrIn : unsigned      := toMemoryPort.addrIn end macro; 
macro memoryAccess_dataIn : unsigned      := toMemoryPort.dataIn end macro; 
macro memoryAccess_mask   : ME_MaskType   := toMemoryPort.mask   end macro; 
macro memoryAccess_req    : ME_AccessType := toMemoryPort.req    end macro; 
macro pcReg : unsigned := IF_ISA/pcReg_signal end macro; 
macro regfileWrite_dst     : unsigned := toRegsPort.dst     end macro; 
macro regfileWrite_dstData : unsigned := toRegsPort.dstData end macro; 


-- STATES -- 
macro execute_4  : boolean := (IF_ISA/section = store1)  end macro;
macro execute_5  : boolean := (IF_ISA/section = store2)  end macro;
macro execute_11 : boolean := (IF_ISA/section = load1)   end macro;
macro execute_12 : boolean := (IF_ISA/section = load2)   end macro;
macro fetch_16   : boolean := (IF_ISA/section = fetch)   end macro;
macro fetch_17   : boolean := (IF_ISA/section = execute) end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: fetch_16;
	 at t: memoryAccess_addrIn = resize(0,32);
	 at t: memoryAccess_dataIn = resize(0,32);
	 at t: memoryAccess_mask = MT_W;
	 at t: memoryAccess_req = ME_RD;
	 at t: pcReg = resize(0,32);
	 at t: regfileWrite_dst = resize(0,32);
	 at t: regfileWrite_dstData = resize(0,32);
	 at t: toMemoryPort_sig_addrIn = resize(0,32);
	 at t: toMemoryPort_sig_dataIn = resize(0,32);
	 at t: toMemoryPort_sig_mask = MT_W;
	 at t: toMemoryPort_sig_req = ME_RD;
	 at t: fromMemoryPort_notify = false;
	 at t: toMemoryPort_notify = true;
	 at t: toRegsPort_notify = false;
end property;


property execute_4_write_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_4;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_5;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_5_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_5;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_11_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_11;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: execute_12;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property execute_12_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_12;
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = fromMemoryPort_sig_loadedData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = regfileWrite_dst_at_t;
	 at t_end: toRegsPort_sig_dstData = fromMemoryPort_sig_loadedData_at_t;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_16_write_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_16;
	 at t: toMemoryPort_sync;
prove:
	 at t_end: fetch_17;
	 at t_end: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t_end: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t_end: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t_end: memoryAccess_req = memoryAccess_req_at_t;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 during[t+1, t_end-1]: fromMemoryPort_notify = false;
	 at t_end: fromMemoryPort_notify = true;
	 during[t+1, t_end]: toMemoryPort_notify = false;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_J));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_I));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_L));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_J));
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = pcReg_at_t;
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = pcReg_at_t;
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_17;
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))));
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))));
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_17_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = branchPCcalculation(getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = branchPCcalculation(getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))),fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_4;
	 at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: memoryAccess_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: memoryAccess_mask = getMemoryMask(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: memoryAccess_req = ME_WR;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_dataIn = readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs2Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_req = ME_WR;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_9 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = getEncUALUresult(fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toRegsPort_sig_dstData = getEncUALUresult(fromMemoryPort_sig_loadedData_at_t,pcReg_at_t);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_17_read_10 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_J);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_addrIn = (pcReg_at_t + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_17_read_11 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_J));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_I);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_addrIn = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toRegsPort_sig_dstData = getALUresult(getALUfunc(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t))),readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property fetch_17_read_12 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_J));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_I));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_L);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: execute_11;
	 at t_end: memoryAccess_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = getMemoryMask(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = pcReg_at_t;
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t_end: toMemoryPort_sig_addrIn = getALUresult(ALU_ADD,readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))),getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = getMemoryMask(getInstrType(getFunct3(fromMemoryPort_sig_loadedData_at_t),getFunct7(fromMemoryPort_sig_loadedData_at_t),getOpcode(fromMemoryPort_sig_loadedData_at_t)));
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end]: toRegsPort_notify = false;
end property;

property fetch_17_read_13 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	fromMemoryPort_sig_loadedData_at_t = fromMemoryPort_sig_loadedData@t,
	fromRegsPort_sig_reg_file_01_at_t = fromRegsPort_sig_reg_file_01@t,
	fromRegsPort_sig_reg_file_02_at_t = fromRegsPort_sig_reg_file_02@t,
	fromRegsPort_sig_reg_file_03_at_t = fromRegsPort_sig_reg_file_03@t,
	fromRegsPort_sig_reg_file_04_at_t = fromRegsPort_sig_reg_file_04@t,
	fromRegsPort_sig_reg_file_05_at_t = fromRegsPort_sig_reg_file_05@t,
	fromRegsPort_sig_reg_file_06_at_t = fromRegsPort_sig_reg_file_06@t,
	fromRegsPort_sig_reg_file_07_at_t = fromRegsPort_sig_reg_file_07@t,
	fromRegsPort_sig_reg_file_08_at_t = fromRegsPort_sig_reg_file_08@t,
	fromRegsPort_sig_reg_file_09_at_t = fromRegsPort_sig_reg_file_09@t,
	fromRegsPort_sig_reg_file_10_at_t = fromRegsPort_sig_reg_file_10@t,
	fromRegsPort_sig_reg_file_11_at_t = fromRegsPort_sig_reg_file_11@t,
	fromRegsPort_sig_reg_file_12_at_t = fromRegsPort_sig_reg_file_12@t,
	fromRegsPort_sig_reg_file_13_at_t = fromRegsPort_sig_reg_file_13@t,
	fromRegsPort_sig_reg_file_14_at_t = fromRegsPort_sig_reg_file_14@t,
	fromRegsPort_sig_reg_file_15_at_t = fromRegsPort_sig_reg_file_15@t,
	fromRegsPort_sig_reg_file_16_at_t = fromRegsPort_sig_reg_file_16@t,
	fromRegsPort_sig_reg_file_17_at_t = fromRegsPort_sig_reg_file_17@t,
	fromRegsPort_sig_reg_file_18_at_t = fromRegsPort_sig_reg_file_18@t,
	fromRegsPort_sig_reg_file_19_at_t = fromRegsPort_sig_reg_file_19@t,
	fromRegsPort_sig_reg_file_20_at_t = fromRegsPort_sig_reg_file_20@t,
	fromRegsPort_sig_reg_file_21_at_t = fromRegsPort_sig_reg_file_21@t,
	fromRegsPort_sig_reg_file_22_at_t = fromRegsPort_sig_reg_file_22@t,
	fromRegsPort_sig_reg_file_23_at_t = fromRegsPort_sig_reg_file_23@t,
	fromRegsPort_sig_reg_file_24_at_t = fromRegsPort_sig_reg_file_24@t,
	fromRegsPort_sig_reg_file_25_at_t = fromRegsPort_sig_reg_file_25@t,
	fromRegsPort_sig_reg_file_26_at_t = fromRegsPort_sig_reg_file_26@t,
	fromRegsPort_sig_reg_file_27_at_t = fromRegsPort_sig_reg_file_27@t,
	fromRegsPort_sig_reg_file_28_at_t = fromRegsPort_sig_reg_file_28@t,
	fromRegsPort_sig_reg_file_29_at_t = fromRegsPort_sig_reg_file_29@t,
	fromRegsPort_sig_reg_file_30_at_t = fromRegsPort_sig_reg_file_30@t,
	fromRegsPort_sig_reg_file_31_at_t = fromRegsPort_sig_reg_file_31@t,
	pcReg_at_t = pcReg@t;
assume: 
	 at t: fetch_17;
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_R));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_B));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_S));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_U));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_J));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_I));
	 at t: not((getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_L));
	 at t: (getEncType(getOpcode(fromMemoryPort_sig_loadedData)) = ENC_I_J);
	 at t: fromMemoryPort_sync;
prove:
	 at t_end: fetch_16;
	 at t_end: memoryAccess_addrIn = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))) + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: memoryAccess_dataIn = 0;
	 at t_end: memoryAccess_mask = MT_W;
	 at t_end: memoryAccess_req = ME_RD;
	 at t_end: pcReg = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))) + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: regfileWrite_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: regfileWrite_dstData = (4 + pcReg_at_t)(31 downto 0);
	 at t_end: toMemoryPort_sig_addrIn = (readRegfile(fromRegsPort_sig_reg_file_01_at_t,fromRegsPort_sig_reg_file_02_at_t,fromRegsPort_sig_reg_file_03_at_t,fromRegsPort_sig_reg_file_04_at_t,fromRegsPort_sig_reg_file_05_at_t,fromRegsPort_sig_reg_file_06_at_t,fromRegsPort_sig_reg_file_07_at_t,fromRegsPort_sig_reg_file_08_at_t,fromRegsPort_sig_reg_file_09_at_t,fromRegsPort_sig_reg_file_10_at_t,fromRegsPort_sig_reg_file_11_at_t,fromRegsPort_sig_reg_file_12_at_t,fromRegsPort_sig_reg_file_13_at_t,fromRegsPort_sig_reg_file_14_at_t,fromRegsPort_sig_reg_file_15_at_t,fromRegsPort_sig_reg_file_16_at_t,fromRegsPort_sig_reg_file_17_at_t,fromRegsPort_sig_reg_file_18_at_t,fromRegsPort_sig_reg_file_19_at_t,fromRegsPort_sig_reg_file_20_at_t,fromRegsPort_sig_reg_file_21_at_t,fromRegsPort_sig_reg_file_22_at_t,fromRegsPort_sig_reg_file_23_at_t,fromRegsPort_sig_reg_file_24_at_t,fromRegsPort_sig_reg_file_25_at_t,fromRegsPort_sig_reg_file_26_at_t,fromRegsPort_sig_reg_file_27_at_t,fromRegsPort_sig_reg_file_28_at_t,fromRegsPort_sig_reg_file_29_at_t,fromRegsPort_sig_reg_file_30_at_t,fromRegsPort_sig_reg_file_31_at_t,getRs1Addr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t))) + getImmediate(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t)))(31 downto 0);
	 at t_end: toMemoryPort_sig_dataIn = 0;
	 at t_end: toMemoryPort_sig_mask = MT_W;
	 at t_end: toMemoryPort_sig_req = ME_RD;
	 at t_end: toRegsPort_sig_dst = getRdAddr(fromMemoryPort_sig_loadedData_at_t,getOpcode(fromMemoryPort_sig_loadedData_at_t));
	 at t_end: toRegsPort_sig_dstData = (4 + pcReg_at_t)(31 downto 0);
	 during[t+1, t_end]: fromMemoryPort_notify = false;
	 during[t+1, t_end-1]: toMemoryPort_notify = false;
	 at t_end: toMemoryPort_notify = true;
	 during[t+1, t_end-1]: toRegsPort_notify = false;
	 at t_end: toRegsPort_notify = true;
end property;

property wait_execute_4 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_4;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_4;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_5 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_5;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_5;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_11 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_11;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: execute_11;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_execute_12 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: execute_12;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: execute_12;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_16 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_16;
	 at t: not(toMemoryPort_sync);
prove:
	 at t+1: fetch_16;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: toMemoryPort_sig_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: toMemoryPort_sig_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: toMemoryPort_sig_mask = memoryAccess_mask_at_t;
	 at t+1: toMemoryPort_sig_req = memoryAccess_req_at_t;
	 at t+1: fromMemoryPort_notify = false;
	 at t+1: toMemoryPort_notify = true;
	 at t+1: toRegsPort_notify = false;
end property;

property wait_fetch_17 is
dependencies: no_reset;
freeze:
	memoryAccess_addrIn_at_t = memoryAccess_addrIn@t,
	memoryAccess_dataIn_at_t = memoryAccess_dataIn@t,
	memoryAccess_mask_at_t = memoryAccess_mask@t,
	memoryAccess_req_at_t = memoryAccess_req@t,
	pcReg_at_t = pcReg@t,
	regfileWrite_dstData_at_t = regfileWrite_dstData@t,
	regfileWrite_dst_at_t = regfileWrite_dst@t;
assume: 
	 at t: fetch_17;
	 at t: not(fromMemoryPort_sync);
prove:
	 at t+1: fetch_17;
	 at t+1: memoryAccess_addrIn = memoryAccess_addrIn_at_t;
	 at t+1: memoryAccess_dataIn = memoryAccess_dataIn_at_t;
	 at t+1: memoryAccess_mask = memoryAccess_mask_at_t;
	 at t+1: memoryAccess_req = memoryAccess_req_at_t;
	 at t+1: pcReg = pcReg_at_t;
	 at t+1: regfileWrite_dst = regfileWrite_dst_at_t;
	 at t+1: regfileWrite_dstData = regfileWrite_dstData_at_t;
	 at t+1: fromMemoryPort_notify = true;
	 at t+1: toMemoryPort_notify = false;
	 at t+1: toRegsPort_notify = false;
end property;

