library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ISA is
port(	
	fromMemoryPort_sig: in MEtoCU_IF;
	fromMemoryPort_sync: in boolean;
	fromMemoryPort_notify: out boolean;
	fromRegsPort_sig: in RegfileType;
	toMemoryPort_sig: out CUtoME_IF;
	toMemoryPort_sync: in boolean;
	toMemoryPort_notify: out boolean;
	toRegsPort_sig: out RegfileWriteType;
	toRegsPort_notify: out boolean;
	clk: in std_logic;
	rst: in std_logic
);
end ISA;

architecture ISA_arch of ISA is
	-- Define internal data types
	type ISA_assign_t is (assign_0, assign_1, assign_2, assign_3, assign_4, assign_5, assign_6, assign_7, assign_8, assign_9, assign_10, assign_11, assign_12, assign_13, assign_14, assign_15, assign_16, assign_17, assign_18, assign_19, assign_20, assign_21);
	type ISA_state_t is (st_execute_12, st_execute_13, st_execute_4, st_fetch_15, st_fetch_16);
	type ALUfuncType is (ALU_ADD, ALU_AND, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_SRA, ALU_SRL, ALU_SUB, ALU_X, ALU_XOR);
	type EncType is (ENC_B, ENC_ERR, ENC_I_I, ENC_I_J, ENC_I_L, ENC_J, ENC_R, ENC_S, ENC_U);
	type InstrType is (INSTR_ADD, INSTR_ADDI, INSTR_AND, INSTR_ANDI, INSTR_AUIPC, INSTR_BEQ, INSTR_BGE, INSTR_BGEU, INSTR_BLT, INSTR_BLTU, INSTR_BNE, INSTR_JAL, INSTR_JALR, INSTR_LB, INSTR_LBU, INSTR_LH, INSTR_LHU, INSTR_LUI, INSTR_LW, INSTR_OR, INSTR_ORI, INSTR_SB, INSTR_SH, INSTR_SLL, INSTR_SLLI, INSTR_SLT, INSTR_SLTI, INSTR_SLTIU, INSTR_SLTU, INSTR_SRA, INSTR_SRAI, INSTR_SRL, INSTR_SRLI, INSTR_SUB, INSTR_SW, INSTR_UNKNOWN, INSTR_XOR, INSTR_XORI);

	-- Declare signals
	signal active_state: ISA_state_t;
	signal active_assignment: ISA_assign_t;
	signal pcReg: unsigned(31 downto 0);
	signal toMemoryData: CUtoME_IF;
	signal toRegsData: RegfileWriteType;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal execute_4: boolean;
	signal execute_12: boolean;
	signal execute_13: boolean;
	signal fetch_15: boolean;
	signal fetch_16: boolean;


	-- Functions
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

	function readRegfile(fromRegsData_reg_file_01: unsigned; fromRegsData_reg_file_02: unsigned; fromRegsData_reg_file_03: unsigned; fromRegsData_reg_file_04: unsigned; fromRegsData_reg_file_05: unsigned; fromRegsData_reg_file_06: unsigned; fromRegsData_reg_file_07: unsigned; fromRegsData_reg_file_08: unsigned; fromRegsData_reg_file_09: unsigned; fromRegsData_reg_file_10: unsigned; fromRegsData_reg_file_11: unsigned; fromRegsData_reg_file_12: unsigned; fromRegsData_reg_file_13: unsigned; fromRegsData_reg_file_14: unsigned; fromRegsData_reg_file_15: unsigned; fromRegsData_reg_file_16: unsigned; fromRegsData_reg_file_17: unsigned; fromRegsData_reg_file_18: unsigned; fromRegsData_reg_file_19: unsigned; fromRegsData_reg_file_20: unsigned; fromRegsData_reg_file_21: unsigned; fromRegsData_reg_file_22: unsigned; fromRegsData_reg_file_23: unsigned; fromRegsData_reg_file_24: unsigned; fromRegsData_reg_file_25: unsigned; fromRegsData_reg_file_26: unsigned; fromRegsData_reg_file_27: unsigned; fromRegsData_reg_file_28: unsigned; fromRegsData_reg_file_29: unsigned; fromRegsData_reg_file_30: unsigned; fromRegsData_reg_file_31: unsigned; src: unsigned) return unsigned is
	begin
		if (src = x"00000000") then return x"00000000";
		elsif (src = x"00000001") then return fromRegsData_reg_file_01;
		elsif (src = x"00000002") then return fromRegsData_reg_file_02;
		elsif (src = x"00000003") then return fromRegsData_reg_file_03;
		elsif (src = x"00000004") then return fromRegsData_reg_file_04;
		elsif (src = x"00000005") then return fromRegsData_reg_file_05;
		elsif (src = x"00000006") then return fromRegsData_reg_file_06;
		elsif (src = x"00000007") then return fromRegsData_reg_file_07;
		elsif (src = x"00000008") then return fromRegsData_reg_file_08;
		elsif (src = x"00000009") then return fromRegsData_reg_file_09;
		elsif (src = x"0000000a") then return fromRegsData_reg_file_10;
		elsif (src = x"0000000b") then return fromRegsData_reg_file_11;
		elsif (src = x"0000000c") then return fromRegsData_reg_file_12;
		elsif (src = x"0000000d") then return fromRegsData_reg_file_13;
		elsif (src = x"0000000e") then return fromRegsData_reg_file_14;
		elsif (src = x"0000000f") then return fromRegsData_reg_file_15;
		elsif (src = x"00000010") then return fromRegsData_reg_file_16;
		elsif (src = x"00000011") then return fromRegsData_reg_file_17;
		elsif (src = x"00000012") then return fromRegsData_reg_file_18;
		elsif (src = x"00000013") then return fromRegsData_reg_file_19;
		elsif (src = x"00000014") then return fromRegsData_reg_file_20;
		elsif (src = x"00000015") then return fromRegsData_reg_file_21;
		elsif (src = x"00000016") then return fromRegsData_reg_file_22;
		elsif (src = x"00000017") then return fromRegsData_reg_file_23;
		elsif (src = x"00000018") then return fromRegsData_reg_file_24;
		elsif (src = x"00000019") then return fromRegsData_reg_file_25;
		elsif (src = x"0000001a") then return fromRegsData_reg_file_26;
		elsif (src = x"0000001b") then return fromRegsData_reg_file_27;
		elsif (src = x"0000001c") then return fromRegsData_reg_file_28;
		elsif (src = x"0000001d") then return fromRegsData_reg_file_29;
		elsif (src = x"0000001e") then return fromRegsData_reg_file_30;
		else return fromRegsData_reg_file_31;
		end if;
	end readRegfile;


begin
	-- Combinational logic that selects current operation
	process (active_state, toMemoryPort_sync, fromMemoryPort_sync, fromRegsPort_sig.reg_file_01, fromMemoryPort_sig.loadedData, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31)
	begin
		case active_state is
		when st_execute_4 =>
			if (not(toMemoryPort_sync)) then 
				-- Operation: op_wait_execute_4;
				active_assignment <= assign_0;
			else--if(toMemoryPort_sync) then 
				-- Operation: op_execute_4_write_0;
				active_assignment <= assign_1;
			end if;
		when st_execute_12 =>
			if (not(toMemoryPort_sync)) then 
				-- Operation: op_wait_execute_12;
				active_assignment <= assign_2;
			else--if(toMemoryPort_sync) then 
				-- Operation: op_execute_12_write_1;
				active_assignment <= assign_3;
			end if;
		when st_execute_13 =>
			if (not(fromMemoryPort_sync)) then 
				-- Operation: op_wait_execute_13;
				active_assignment <= assign_3;
			else--if(fromMemoryPort_sync) then 
				-- Operation: op_execute_13_read_2;
				active_assignment <= assign_4;
			end if;
		when st_fetch_15 =>
			if (not(toMemoryPort_sync)) then 
				-- Operation: op_wait_fetch_15;
				active_assignment <= assign_5;
			else--if(toMemoryPort_sync) then 
				-- Operation: op_fetch_15_write_3;
				active_assignment <= assign_6;
			end if;
		when st_fetch_16 =>
			if (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_J) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_J) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_I) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_L) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_4;
				active_assignment <= assign_7;
			elsif (not(fromMemoryPort_sync)) then 
				-- Operation: op_wait_fetch_16;
				active_assignment <= assign_6;
			elsif ((getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_5;
				active_assignment <= assign_8;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_6;
				active_assignment <= assign_9;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_7;
				active_assignment <= assign_10;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_8;
				active_assignment <= assign_11;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_9;
				active_assignment <= assign_12;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_10;
				active_assignment <= assign_13;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGEU) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000") and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_11;
				active_assignment <= assign_14;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BEQ) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BNE) and not(getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLT) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGE) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BLTU) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000001")) and not((getInstrType(fromMemoryPort_sig.loadedData) = INSTR_BGEU) and (getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"))) = x"00000000")) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_12;
				active_assignment <= assign_1;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_13;
				active_assignment <= assign_15;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and (getInstrType(fromMemoryPort_sig.loadedData) = INSTR_LUI) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_14;
				active_assignment <= assign_16;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and not(getInstrType(fromMemoryPort_sig.loadedData) = INSTR_LUI) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_15;
				active_assignment <= assign_17;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_J) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_16;
				active_assignment <= assign_18;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_J) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_I_J) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_17;
				active_assignment <= assign_19;
			elsif (not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_J) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_J) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_I_I) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_18;
				active_assignment <= assign_20;
			else--if(not(getEncType(fromMemoryPort_sig.loadedData) = ENC_R) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_B) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_S) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_U) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_J) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_J) and not(getEncType(fromMemoryPort_sig.loadedData) = ENC_I_I) and (getEncType(fromMemoryPort_sig.loadedData) = ENC_I_L) and fromMemoryPort_sync) then 
				-- Operation: op_fetch_16_read_19;
				active_assignment <= assign_21;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			toMemoryData.addrIn <= x"00000000";
			toMemoryData.dataIn <= x"00000000";
			toMemoryPort_sig.dataIn <= x"00000000";
			toMemoryPort_sig.addrIn <= x"00000000";
			toMemoryPort_sig.mask <= MT_W;
			toRegsData.dst <= x"00000000";
			toMemoryData.req <= ME_RD;
			toMemoryData.mask <= MT_W;
			pcReg <= x"00000000";
			toRegsPort_notify <= false;
			toMemoryPort_sig.req <= ME_RD;
			toMemoryPort_notify <= true;
			fromMemoryPort_notify <= false;
			active_state <= st_fetch_15;
		elsif (clk = '1' and clk'event) then
			case active_assignment is
			when assign_0 =>
				toMemoryPort_sig.addrIn <= toMemoryData.addrIn;
				toMemoryPort_sig.mask <= toMemoryData.mask;
				toRegsPort_notify <= false;
				active_state <= st_execute_4;
				toMemoryPort_sig.dataIn <= toMemoryData.dataIn;
				toMemoryPort_sig.req <= toMemoryData.req;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
			when assign_1 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_2 =>
				toMemoryPort_sig.addrIn <= toMemoryData.addrIn;
				toMemoryPort_sig.mask <= toMemoryData.mask;
				toRegsPort_notify <= false;
				toMemoryPort_sig.dataIn <= toMemoryData.dataIn;
				toMemoryPort_sig.req <= toMemoryData.req;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_execute_12;
			when assign_3 =>
				toMemoryPort_notify <= false;
				toRegsPort_notify <= false;
				fromMemoryPort_notify <= true;
				active_state <= st_execute_13;
			when assign_4 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsPort_sig.dstData <= fromMemoryPort_sig.loadedData;
				toMemoryPort_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= toRegsData.dst;
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_5 =>
				toMemoryPort_sig.addrIn <= toMemoryData.addrIn;
				toMemoryPort_sig.mask <= toMemoryData.mask;
				toRegsPort_notify <= false;
				toMemoryPort_sig.dataIn <= toMemoryData.dataIn;
				toMemoryPort_sig.req <= toMemoryData.req;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_6 =>
				toMemoryPort_notify <= false;
				active_state <= st_fetch_16;
				toRegsPort_notify <= false;
				fromMemoryPort_notify <= true;
			when assign_7 =>
				toMemoryPort_sig.addrIn <= pcReg;
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryData.addrIn <= pcReg;
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_8 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toRegsPort_sig.dstData <= getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f")));
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_9 =>
				toMemoryData.dataIn <= x"00000000";
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_10 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.req <= ME_RD;
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_11 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_12 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.req <= ME_RD;
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.mask <= MT_W;
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_13 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.mask <= MT_W;
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_14 =>
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.dataIn <= x"00000000";
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.dataIn <= x"00000000";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= MT_W;
				toRegsPort_notify <= false;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
			when assign_15 =>
				toMemoryData.mask <= getMemoryMask(getInstrType(fromMemoryPort_sig.loadedData));
				toMemoryPort_sig.req <= ME_WR;
				toMemoryPort_sig.dataIn <= readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"));
				toMemoryPort_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), getImmediate(fromMemoryPort_sig.loadedData));
				toMemoryData.dataIn <= readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 20) and x"0000001f"));
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), getImmediate(fromMemoryPort_sig.loadedData));
				toMemoryPort_sig.mask <= getMemoryMask(getInstrType(fromMemoryPort_sig.loadedData));
				toRegsPort_notify <= false;
				active_state <= st_execute_4;
				toMemoryData.req <= ME_WR;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
			when assign_16 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				toRegsPort_sig.dstData <= getALUresult(ALU_COPY1, getImmediate(fromMemoryPort_sig.loadedData), x"00000000");
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_17 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				toRegsPort_sig.dstData <= getALUresult(ALU_ADD, getImmediate(fromMemoryPort_sig.loadedData), pcReg);
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_18 =>
				toMemoryPort_sig.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				pcReg <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsPort_sig.dstData <= x"00000004" + pcReg;
				toMemoryData.addrIn <= pcReg + getImmediate(fromMemoryPort_sig.loadedData);
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_19 =>
				pcReg <= readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")) + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.addrIn <= readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")) + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsPort_sig.dstData <= x"00000004" + pcReg;
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryPort_sig.addrIn <= readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")) + getImmediate(fromMemoryPort_sig.loadedData);
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_20 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsPort_sig.dstData <= getALUresult(getALUfunc(getInstrType(fromMemoryPort_sig.loadedData)), readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), getImmediate(fromMemoryPort_sig.loadedData));
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryPort_sig.mask <= MT_W;
				pcReg <= x"00000004" + pcReg;
				toMemoryPort_sig.addrIn <= x"00000004" + pcReg;
				toMemoryData.req <= ME_RD;
				toRegsPort_sig.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.mask <= MT_W;
				toMemoryData.addrIn <= x"00000004" + pcReg;
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_fetch_15;
				toRegsPort_notify <= true;
			when assign_21 =>
				toMemoryData.dataIn <= x"00000000";
				toMemoryPort_sig.dataIn <= x"00000000";
				toRegsData.dst <= shift_right(fromMemoryPort_sig.loadedData, 7) and x"0000001f";
				toMemoryData.req <= ME_RD;
				toMemoryData.mask <= getMemoryMask(getInstrType(fromMemoryPort_sig.loadedData));
				toMemoryPort_sig.mask <= getMemoryMask(getInstrType(fromMemoryPort_sig.loadedData));
				toRegsPort_notify <= false;
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), getImmediate(fromMemoryPort_sig.loadedData));
				toMemoryPort_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(fromRegsPort_sig.reg_file_01, fromRegsPort_sig.reg_file_02, fromRegsPort_sig.reg_file_03, fromRegsPort_sig.reg_file_04, fromRegsPort_sig.reg_file_05, fromRegsPort_sig.reg_file_06, fromRegsPort_sig.reg_file_07, fromRegsPort_sig.reg_file_08, fromRegsPort_sig.reg_file_09, fromRegsPort_sig.reg_file_10, fromRegsPort_sig.reg_file_11, fromRegsPort_sig.reg_file_12, fromRegsPort_sig.reg_file_13, fromRegsPort_sig.reg_file_14, fromRegsPort_sig.reg_file_15, fromRegsPort_sig.reg_file_16, fromRegsPort_sig.reg_file_17, fromRegsPort_sig.reg_file_18, fromRegsPort_sig.reg_file_19, fromRegsPort_sig.reg_file_20, fromRegsPort_sig.reg_file_21, fromRegsPort_sig.reg_file_22, fromRegsPort_sig.reg_file_23, fromRegsPort_sig.reg_file_24, fromRegsPort_sig.reg_file_25, fromRegsPort_sig.reg_file_26, fromRegsPort_sig.reg_file_27, fromRegsPort_sig.reg_file_28, fromRegsPort_sig.reg_file_29, fromRegsPort_sig.reg_file_30, fromRegsPort_sig.reg_file_31, (shift_right(fromMemoryPort_sig.loadedData, 15) and x"0000001f")), getImmediate(fromMemoryPort_sig.loadedData));
				toMemoryPort_sig.req <= ME_RD;
				toMemoryPort_notify <= true;
				fromMemoryPort_notify <= false;
				active_state <= st_execute_12;
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	execute_4 <= active_state = st_execute_4;
	execute_12 <= active_state = st_execute_12;
	execute_13 <= active_state = st_execute_13;
	fetch_15 <= active_state = st_fetch_15;
	fetch_16 <= active_state = st_fetch_16;

end ISA_arch;

