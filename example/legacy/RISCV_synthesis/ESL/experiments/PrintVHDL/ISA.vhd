library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ISA is
port(	
	ISAtoMEM_port_sig: out CUtoME_IF;
	ISAtoMEM_port_sync: in boolean;
	ISAtoMEM_port_notify: out boolean;
	ISAtoRF_port_sig: out ISAtoRF_IF;
	ISAtoRF_port_notify: out boolean;
	MEMtoISA_port_sig: in MEtoCU_IF;
	MEMtoISA_port_sync: in boolean;
	MEMtoISA_port_notify: out boolean;
	RFtoISA_port_sig: in RFtoISA_IF;
	clk: in std_logic;
	rst: in std_logic
);
end ISA;

architecture ISA_arch of ISA is
	-- Define internal data types
	type ISA_operation_t is (op_wait_fetch_6, op_fetch_6_write_0, op_fetch_7_read_1, op_wait_fetch_7, op_fetch_7_read_2, op_fetch_7_read_3, op_fetch_7_read_4, op_fetch_7_read_5, op_fetch_7_read_6, op_fetch_7_read_7, op_fetch_7_read_8, op_fetch_7_read_9, op_fetch_7_read_10, op_fetch_7_read_11, op_fetch_7_read_12, op_fetch_7_read_13, op_fetch_7_read_14, op_fetch_7_read_15, op_fetch_7_read_16, op_fetch_7_read_17, op_fetch_7_read_18, op_memory_8_write_19, op_wait_memory_8, op_wait_memory_9, op_memory_9_write_20, op_wait_memory_10, op_memory_10_read_21);
	type ISA_state_t is (st_fetch_6, st_fetch_7, st_memory_10, st_memory_8, st_memory_9);
	type ALUfuncType is (ALU_ADD, ALU_AND, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_SRA, ALU_SRL, ALU_SUB, ALU_X, ALU_XOR);
	type EncType is (ENC_B, ENC_ERR, ENC_I_I, ENC_I_J, ENC_I_L, ENC_J, ENC_R, ENC_S, ENC_U);
	type InstrType is (INSTR_ADD, INSTR_ADDI, INSTR_AND, INSTR_ANDI, INSTR_AUIPC, INSTR_BEQ, INSTR_BGE, INSTR_BGEU, INSTR_BLT, INSTR_BLTU, INSTR_BNE, INSTR_JAL, INSTR_JALR, INSTR_LB, INSTR_LBU, INSTR_LH, INSTR_LHU, INSTR_LUI, INSTR_LW, INSTR_OR, INSTR_ORI, INSTR_SB, INSTR_SH, INSTR_SLL, INSTR_SLLI, INSTR_SLT, INSTR_SLTI, INSTR_SLTIU, INSTR_SLTU, INSTR_SRA, INSTR_SRAI, INSTR_SRL, INSTR_SRLI, INSTR_SUB, INSTR_SW, INSTR_UNKNOWN, INSTR_XOR, INSTR_XORI);
	type DecodedInstrType is record
		ALUfunc: ALUfuncType;
		MEMmask: ME_MaskType;
		enc: EncType;
		imm: unsigned(31 downto 0);
		instr: InstrType;
		rd_addr: unsigned(31 downto 0);
		rs1_addr: unsigned(31 downto 0);
		rs2_addr: unsigned(31 downto 0);
	end record;

	-- Declare signals
	signal active_state: ISA_state_t;
	signal active_operation: ISA_operation_t;
	signal ISAtoMEM_data: CUtoME_IF;
	signal decodedInstr: DecodedInstrType;
	signal pcReg: unsigned(31 downto 0);

	-- Declare state signals that are used by ITL properties for OneSpin
	signal fetch_6: boolean;
	signal fetch_7: boolean;
	signal memory_8: boolean;
	signal memory_9: boolean;
	signal memory_10: boolean;


	-- Functions
	function getALUfunc(instr: InstrType) return ALUfuncType;
	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned;
	function getEncType(encodedInstr: unsigned) return EncType;
	function getImmediate(encodedInstr: unsigned) return unsigned;
	function getInstrType(encodedInstr: unsigned) return InstrType;
	function getMemoryMask(instr: InstrType) return ME_MaskType;
	function getRdAddr(encodedInstr: unsigned) return unsigned;
	function getRs1Addr(encodedInstr: unsigned) return unsigned;
	function getRs2Addr(encodedInstr: unsigned) return unsigned;
	function readRegfile(RFtoISA_data_reg_file_01: unsigned; RFtoISA_data_reg_file_02: unsigned; RFtoISA_data_reg_file_03: unsigned; RFtoISA_data_reg_file_04: unsigned; RFtoISA_data_reg_file_05: unsigned; RFtoISA_data_reg_file_06: unsigned; RFtoISA_data_reg_file_07: unsigned; RFtoISA_data_reg_file_08: unsigned; RFtoISA_data_reg_file_09: unsigned; RFtoISA_data_reg_file_10: unsigned; RFtoISA_data_reg_file_11: unsigned; RFtoISA_data_reg_file_12: unsigned; RFtoISA_data_reg_file_13: unsigned; RFtoISA_data_reg_file_14: unsigned; RFtoISA_data_reg_file_15: unsigned; RFtoISA_data_reg_file_16: unsigned; RFtoISA_data_reg_file_17: unsigned; RFtoISA_data_reg_file_18: unsigned; RFtoISA_data_reg_file_19: unsigned; RFtoISA_data_reg_file_20: unsigned; RFtoISA_data_reg_file_21: unsigned; RFtoISA_data_reg_file_22: unsigned; RFtoISA_data_reg_file_23: unsigned; RFtoISA_data_reg_file_24: unsigned; RFtoISA_data_reg_file_25: unsigned; RFtoISA_data_reg_file_26: unsigned; RFtoISA_data_reg_file_27: unsigned; RFtoISA_data_reg_file_28: unsigned; RFtoISA_data_reg_file_29: unsigned; RFtoISA_data_reg_file_30: unsigned; RFtoISA_data_reg_file_31: unsigned; src: unsigned) return unsigned;

	function getALUfunc(instr: InstrType) return ALUfuncType is
	begin
		if ((instr = INSTR_ADD) or (instr = INSTR_ADDI)) then return ALU_ADD;
		elsif (instr = INSTR_SUB) then return ALU_SUB;
		elsif ((instr = INSTR_SLL) or (instr = INSTR_SLLI)) then return ALU_SLL;
		elsif ((instr = INSTR_SLT) or (instr = INSTR_SLTI)) then return ALU_SLT;
		elsif ((instr = INSTR_SLTU) or (instr = INSTR_SLTIU)) then return ALU_SLTU;
		elsif ((instr = INSTR_XOR) or (instr = INSTR_XORI)) then return ALU_XOR;
		elsif ((instr = INSTR_SRL) or (instr = INSTR_SRLI)) then return ALU_SRL;
		elsif ((instr = INSTR_SRA) or (instr = INSTR_SRAI)) then return ALU_SRA;
		elsif ((instr = INSTR_OR) or (instr = INSTR_ORI)) then return ALU_OR;
		elsif ((instr = INSTR_AND) or (instr = INSTR_ANDI)) then return ALU_AND;
		elsif (((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU)) then return ALU_ADD;
		elsif ((instr = INSTR_JALR) or (instr = INSTR_JAL)) then return ALU_X;
		elsif ((instr = INSTR_BEQ) or (instr = INSTR_BNE)) then return ALU_SUB;
		elsif ((instr = INSTR_BLT) or (instr = INSTR_BGE)) then return ALU_SLT;
		elsif ((instr = INSTR_BLTU) or (instr = INSTR_BGEU)) then return ALU_SLTU;
		elsif (((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW)) then return ALU_ADD;
		elsif (instr = INSTR_AUIPC) then return ALU_ADD;
		elsif (instr = INSTR_LUI) then return ALU_COPY1;
		else return ALU_X;
		end if;
	end getALUfunc;

	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned is
	begin
		if (aluFunction = ALU_ADD) then return (operand1 + operand2);
		elsif (aluFunction = ALU_SUB) then return (operand1 - operand2);
		elsif (aluFunction = ALU_AND) then return (operand1 and operand2);
		elsif (aluFunction = ALU_OR) then return (operand1 or operand2);
		elsif (aluFunction = ALU_XOR) then return (operand1 xor operand2);
		elsif (aluFunction = ALU_SLT) and (signed(operand1) < signed(operand2)) then return x"00000001";
		elsif (aluFunction = ALU_SLT) then return x"00000000";
		elsif (aluFunction = ALU_SLTU) and (operand1 < operand2) then return x"00000001";
		elsif (aluFunction = ALU_SLTU) then return x"00000000";
		elsif (aluFunction = ALU_SLL) then return shift_left(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		elsif (aluFunction = ALU_SRA) then return unsigned(shift_right(signed(operand1), to_integer(signed(operand2 and to_unsigned(31, 32)))));
		elsif (aluFunction = ALU_SRL) then return shift_right(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		elsif (aluFunction = ALU_COPY1) then return operand1;
		else return x"00000000";
		end if;
	end getALUresult;

	function getEncType(encodedInstr: unsigned) return EncType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return ENC_R;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return ENC_I_I;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return ENC_I_L;
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return ENC_I_J;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return ENC_S;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return ENC_B;
		elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return ENC_U;
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return ENC_J;
		else return ENC_ERR;
		end if;
	end getEncType;

	function getImmediate(encodedInstr: unsigned) return unsigned is
	begin
		if ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return (x"fffff000" or shift_right(encodedInstr, 20));
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return (x"fffff000" or shift_right(encodedInstr, 20));
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e"));
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return (x"fffff000" or (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e")));
		elsif ((encodedInstr and x"0000007f") = x"00000067") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return (x"fffff000" or shift_right(encodedInstr, 20));
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f"));
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return (x"fffff000" or ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f")));
		elsif ((encodedInstr and x"0000007f") = x"00000037") then return (encodedInstr and x"fffff000");
		elsif ((encodedInstr and x"0000007f") = x"00000017") then return (encodedInstr and x"fffff000");
		elsif ((encodedInstr and x"0000007f") = x"0000006f") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe"));
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return (x"fff00000" or (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe")));
		else return x"00000000";
		end if;
	end getImmediate;

	function getInstrType(encodedInstr: unsigned) return InstrType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000") then return INSTR_ADD;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000020") then return INSTR_SUB;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SLL;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SLT;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_SLTU;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_XOR;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000") then return INSTR_SRL;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000020") then return INSTR_SRA;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_OR;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_AND;
		elsif ((encodedInstr and x"0000007f") = x"00000033") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_ADDI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SLLI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SLTI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_SLTIU;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_XORI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000") then return INSTR_SRLI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000020") then return INSTR_SRAI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_ORI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_ANDI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_LB;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_LH;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_LW;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_LBU;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_LHU;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return INSTR_JALR;
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_SB;
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SH;
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SW;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_BEQ;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_BNE;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_BLT;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_BGE;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_BLTU;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_BGEU;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return INSTR_UNKNOWN;
		elsif ((encodedInstr and x"0000007f") = x"00000037") then return INSTR_LUI;
		elsif ((encodedInstr and x"0000007f") = x"00000017") then return INSTR_AUIPC;
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return INSTR_JAL;
		else return INSTR_UNKNOWN;
		end if;
	end getInstrType;

	function getMemoryMask(instr: InstrType) return ME_MaskType is
	begin
		if ((instr = INSTR_LW) or (instr = INSTR_SW)) then return MT_W;
		elsif ((instr = INSTR_LH) or (instr = INSTR_SH)) then return MT_H;
		elsif ((instr = INSTR_LB) or (instr = INSTR_SB)) then return MT_B;
		elsif (instr = INSTR_LHU) then return MT_HU;
		elsif (instr = INSTR_LBU) then return MT_BU;
		else return MT_X;
		end if;
	end getMemoryMask;

	function getRdAddr(encodedInstr: unsigned) return unsigned is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000037") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000017") then return (shift_right(encodedInstr, 7) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return (shift_right(encodedInstr, 7) and x"0000001f");
		else return x"00000000";
		end if;
	end getRdAddr;

	function getRs1Addr(encodedInstr: unsigned) return unsigned is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return (shift_right(encodedInstr, 15) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return (shift_right(encodedInstr, 15) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return (shift_right(encodedInstr, 15) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return (shift_right(encodedInstr, 15) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return (shift_right(encodedInstr, 15) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return (shift_right(encodedInstr, 15) and x"0000001f");
		else return x"00000000";
		end if;
	end getRs1Addr;

	function getRs2Addr(encodedInstr: unsigned) return unsigned is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return (shift_right(encodedInstr, 20) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return (shift_right(encodedInstr, 20) and x"0000001f");
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return (shift_right(encodedInstr, 20) and x"0000001f");
		else return x"00000000";
		end if;
	end getRs2Addr;

	function readRegfile(RFtoISA_data_reg_file_01: unsigned; RFtoISA_data_reg_file_02: unsigned; RFtoISA_data_reg_file_03: unsigned; RFtoISA_data_reg_file_04: unsigned; RFtoISA_data_reg_file_05: unsigned; RFtoISA_data_reg_file_06: unsigned; RFtoISA_data_reg_file_07: unsigned; RFtoISA_data_reg_file_08: unsigned; RFtoISA_data_reg_file_09: unsigned; RFtoISA_data_reg_file_10: unsigned; RFtoISA_data_reg_file_11: unsigned; RFtoISA_data_reg_file_12: unsigned; RFtoISA_data_reg_file_13: unsigned; RFtoISA_data_reg_file_14: unsigned; RFtoISA_data_reg_file_15: unsigned; RFtoISA_data_reg_file_16: unsigned; RFtoISA_data_reg_file_17: unsigned; RFtoISA_data_reg_file_18: unsigned; RFtoISA_data_reg_file_19: unsigned; RFtoISA_data_reg_file_20: unsigned; RFtoISA_data_reg_file_21: unsigned; RFtoISA_data_reg_file_22: unsigned; RFtoISA_data_reg_file_23: unsigned; RFtoISA_data_reg_file_24: unsigned; RFtoISA_data_reg_file_25: unsigned; RFtoISA_data_reg_file_26: unsigned; RFtoISA_data_reg_file_27: unsigned; RFtoISA_data_reg_file_28: unsigned; RFtoISA_data_reg_file_29: unsigned; RFtoISA_data_reg_file_30: unsigned; RFtoISA_data_reg_file_31: unsigned; src: unsigned) return unsigned is
	begin
		if (src = x"00000000") then return x"00000000";
		elsif (src = x"00000001") then return RFtoISA_data_reg_file_01;
		elsif (src = x"00000002") then return RFtoISA_data_reg_file_02;
		elsif (src = x"00000003") then return RFtoISA_data_reg_file_03;
		elsif (src = x"00000004") then return RFtoISA_data_reg_file_04;
		elsif (src = x"00000005") then return RFtoISA_data_reg_file_05;
		elsif (src = x"00000006") then return RFtoISA_data_reg_file_06;
		elsif (src = x"00000007") then return RFtoISA_data_reg_file_07;
		elsif (src = x"00000008") then return RFtoISA_data_reg_file_08;
		elsif (src = x"00000009") then return RFtoISA_data_reg_file_09;
		elsif (src = x"0000000a") then return RFtoISA_data_reg_file_10;
		elsif (src = x"0000000b") then return RFtoISA_data_reg_file_11;
		elsif (src = x"0000000c") then return RFtoISA_data_reg_file_12;
		elsif (src = x"0000000d") then return RFtoISA_data_reg_file_13;
		elsif (src = x"0000000e") then return RFtoISA_data_reg_file_14;
		elsif (src = x"0000000f") then return RFtoISA_data_reg_file_15;
		elsif (src = x"00000010") then return RFtoISA_data_reg_file_16;
		elsif (src = x"00000011") then return RFtoISA_data_reg_file_17;
		elsif (src = x"00000012") then return RFtoISA_data_reg_file_18;
		elsif (src = x"00000013") then return RFtoISA_data_reg_file_19;
		elsif (src = x"00000014") then return RFtoISA_data_reg_file_20;
		elsif (src = x"00000015") then return RFtoISA_data_reg_file_21;
		elsif (src = x"00000016") then return RFtoISA_data_reg_file_22;
		elsif (src = x"00000017") then return RFtoISA_data_reg_file_23;
		elsif (src = x"00000018") then return RFtoISA_data_reg_file_24;
		elsif (src = x"00000019") then return RFtoISA_data_reg_file_25;
		elsif (src = x"0000001a") then return RFtoISA_data_reg_file_26;
		elsif (src = x"0000001b") then return RFtoISA_data_reg_file_27;
		elsif (src = x"0000001c") then return RFtoISA_data_reg_file_28;
		elsif (src = x"0000001d") then return RFtoISA_data_reg_file_29;
		elsif (src = x"0000001e") then return RFtoISA_data_reg_file_30;
		else return RFtoISA_data_reg_file_31;
		end if;
	end readRegfile;


begin
	-- Combinational logic that selects current operation
	process (active_state, MEMtoISA_port_sync, ISAtoMEM_port_sync, RFtoISA_port_sig.reg_file_01, MEMtoISA_port_sig.loadedData, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31)
	begin
		case active_state is
		when st_fetch_6 =>
			if (not(ISAtoMEM_port_sync)) then 
				active_operation <= op_wait_fetch_6;
			else--if(ISAtoMEM_port_sync) then 
				active_operation <= op_fetch_6_write_0;
			end if;
		when st_fetch_7 =>
			if (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_L) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_1;
			elsif (not(MEMtoISA_port_sync)) then 
				active_operation <= op_wait_fetch_7;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_2;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_3;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_4;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_5;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_6;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGEU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000") and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_7;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000001")) and not((getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_BGEU) and (getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData))) = x"00000000")) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_8;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_9;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_10;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_I) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_L) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_11;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_I) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_12;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_13;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and (getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_LUI) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_14;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getInstrType(MEMtoISA_port_sig.loadedData) = INSTR_LUI) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_15;
			elsif ((getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_16;
			elsif (not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_J) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_17;
			else--if(not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_R) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_B) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_S) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_U) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_J) and not(getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_J) and (getEncType(MEMtoISA_port_sig.loadedData) = ENC_I_I) and MEMtoISA_port_sync) then 
				active_operation <= op_fetch_7_read_18;
			end if;
		when st_memory_8 =>
			if (ISAtoMEM_port_sync) then 
				active_operation <= op_memory_8_write_19;
			else--if(not(ISAtoMEM_port_sync)) then 
				active_operation <= op_wait_memory_8;
			end if;
		when st_memory_9 =>
			if (not(ISAtoMEM_port_sync)) then 
				active_operation <= op_wait_memory_9;
			else--if(ISAtoMEM_port_sync) then 
				active_operation <= op_memory_9_write_20;
			end if;
		when st_memory_10 =>
			if (not(MEMtoISA_port_sync)) then 
				active_operation <= op_wait_memory_10;
			else--if(MEMtoISA_port_sync) then 
				active_operation <= op_memory_10_read_21;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			MEMtoISA_port_notify <= false;
			pcReg <= x"00000000";
			ISAtoMEM_data.mask <= MT_W;
			ISAtoMEM_port_sig.req <= ME_RD;
			ISAtoMEM_data.addrIn <= x"00000000";
			ISAtoMEM_port_sig.mask <= MT_W;
			active_state <= st_fetch_6;
			ISAtoMEM_port_sig.dataIn <= x"00000000";
			decodedInstr.rd_addr <= x"00000000";
			ISAtoRF_port_notify <= false;
			ISAtoMEM_data.dataIn <= x"00000000";
			ISAtoMEM_port_notify <= true;
			ISAtoMEM_port_sig.addrIn <= x"00000000";
			ISAtoMEM_data.req <= ME_RD;
		elsif (clk = '1' and clk'event) then
			case active_operation is
			when op_wait_fetch_6 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_port_sig.mask <= ISAtoMEM_data.mask;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_sig.addrIn <= ISAtoMEM_data.addrIn;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.req <= ISAtoMEM_data.req;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
			when op_fetch_6_write_0 =>
				ISAtoRF_port_notify <= false;
				active_state <= st_fetch_7;
				ISAtoMEM_port_notify <= false;
				MEMtoISA_port_notify <= true;
			when op_fetch_7_read_1 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg;
				ISAtoMEM_data.addrIn <= pcReg;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_wait_fetch_7 =>
				ISAtoRF_port_notify <= false;
				active_state <= st_fetch_7;
				ISAtoMEM_port_notify <= false;
				MEMtoISA_port_notify <= true;
			when op_fetch_7_read_2 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= false;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_notify <= true;
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_3 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_4 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_5 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.req <= ME_RD;
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_6 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_7 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= false;
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_8 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= x"00000004" + pcReg;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= x"00000004" + pcReg;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_9 =>
				MEMtoISA_port_notify <= false;
				pcReg <= x"00000004" + pcReg;
				ISAtoMEM_data.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				ISAtoRF_port_notify <= false;
				active_state <= st_memory_8;
				ISAtoMEM_data.req <= ME_WR;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.req <= ME_WR;
			when op_fetch_7_read_10 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.req <= ME_RD;
				pcReg <= x"00000004" + pcReg;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_sig.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_data.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				active_state <= st_memory_9;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_11 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				pcReg <= x"00000004" + pcReg;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_sig.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				active_state <= st_memory_8;
				ISAtoMEM_data.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.req <= ME_WR;
				ISAtoMEM_port_notify <= true;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.req <= ME_WR;
			when op_fetch_7_read_12 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_port_sig.req <= ME_RD;
				pcReg <= x"00000004" + pcReg;
				ISAtoMEM_port_sig.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				ISAtoRF_port_notify <= false;
				ISAtoMEM_data.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_notify <= true;
				active_state <= st_memory_9;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.addrIn <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.mask <= getMemoryMask(getInstrType(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_13 =>
				pcReg <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.addrIn <= pcReg + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_notify <= true;
				ISAtoRF_port_sig.dstData <= x"00000004" + pcReg;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_14 =>
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= x"00000004" + pcReg;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= x"00000004" + pcReg;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData), x"00000000");
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_15 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= x"00000004" + pcReg;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= x"00000004" + pcReg;
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), pcReg, getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_16 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= x"00000004" + pcReg;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= x"00000004" + pcReg;
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs2Addr(MEMtoISA_port_sig.loadedData)));
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_17 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)) + getImmediate(MEMtoISA_port_sig.loadedData);
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoMEM_data.addrIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)) + getImmediate(MEMtoISA_port_sig.loadedData);
				pcReg <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)) + getImmediate(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_sig.dstData <= x"00000004" + pcReg;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_fetch_7_read_18 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.addrIn <= x"00000004" + pcReg;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				active_state <= st_fetch_6;
				ISAtoMEM_port_sig.addrIn <= x"00000004" + pcReg;
				ISAtoRF_port_sig.dst <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				decodedInstr.rd_addr <= getRdAddr(MEMtoISA_port_sig.loadedData);
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEMtoISA_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, getRs1Addr(MEMtoISA_port_sig.loadedData)), getImmediate(MEMtoISA_port_sig.loadedData));
				ISAtoMEM_data.req <= ME_RD;
			when op_memory_8_write_19 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg;
				ISAtoMEM_data.addrIn <= pcReg;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoMEM_data.req <= ME_RD;
			when op_wait_memory_8 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_port_sig.mask <= ISAtoMEM_data.mask;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_sig.addrIn <= ISAtoMEM_data.addrIn;
				active_state <= st_memory_8;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.req <= ISAtoMEM_data.req;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
			when op_wait_memory_9 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_port_sig.mask <= ISAtoMEM_data.mask;
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_sig.addrIn <= ISAtoMEM_data.addrIn;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.req <= ISAtoMEM_data.req;
				active_state <= st_memory_9;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
			when op_memory_9_write_20 =>
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= false;
				MEMtoISA_port_notify <= true;
				active_state <= st_memory_10;
			when op_wait_memory_10 =>
				ISAtoRF_port_notify <= false;
				ISAtoMEM_port_notify <= false;
				MEMtoISA_port_notify <= true;
				active_state <= st_memory_10;
			when op_memory_10_read_21 =>
				MEMtoISA_port_notify <= false;
				ISAtoMEM_data.mask <= MT_W;
				ISAtoMEM_port_sig.req <= ME_RD;
				ISAtoMEM_port_sig.mask <= MT_W;
				active_state <= st_fetch_6;
				ISAtoRF_port_sig.dst <= decodedInstr.rd_addr;
				ISAtoRF_port_notify <= true;
				ISAtoMEM_port_notify <= true;
				ISAtoMEM_port_sig.addrIn <= pcReg;
				ISAtoMEM_data.addrIn <= pcReg;
				ISAtoMEM_port_sig.dataIn <= ISAtoMEM_data.dataIn;
				ISAtoRF_port_sig.dstData <= MEMtoISA_port_sig.loadedData;
				ISAtoMEM_data.req <= ME_RD;
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	fetch_6 <= active_state = st_fetch_6;
	fetch_7 <= active_state = st_fetch_7;
	memory_8 <= active_state = st_memory_8;
	memory_9 <= active_state = st_memory_9;
	memory_10 <= active_state = st_memory_10;

end ISA_arch;

