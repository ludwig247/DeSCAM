library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

entity ISA is
port(	
	COtoME_port_sig: out CUtoME_IF;
	COtoME_port_sync: in boolean;
	COtoME_port_notify: out boolean;
	ISAtoRF_port_sig: out RegfileWriteType;
	ISAtoRF_port_notify: out boolean;
	MEtoCO_port_sig: in MEtoCU_IF;
	MEtoCO_port_sync: in boolean;
	MEtoCO_port_notify: out boolean;
	RFtoISA_port_sig: in RegfileType;
	mip_isa_Port_sig: in unsigned(31 downto 0);
	clk: in std_logic;
	rst: in std_logic
);
end ISA;

architecture ISA_arch of ISA is
	-- Define internal data types
	type ISA_operation_t is (op_wait_fetch_18, op_fetch_18_write_3, op_wait_fetch_19, op_fetch_19_read_4, op_fetch_19_read_5, op_fetch_19_read_6, op_fetch_19_read_7, op_fetch_19_read_8, op_fetch_19_read_9, op_fetch_19_read_10, op_fetch_19_read_11, op_fetch_19_read_12, op_fetch_19_read_13, op_fetch_19_read_14, op_fetch_19_read_15, op_fetch_19_read_16, op_fetch_19_read_17, op_fetch_19_read_18, op_fetch_19_read_19, op_fetch_19_read_20, op_fetch_19_read_21, op_fetch_19_read_22, op_fetch_19_read_23, op_fetch_19_read_24, op_wait_execute_7, op_execute_7_write_0, op_wait_execute_11, op_execute_11_write_2, op_wait_execute_8, op_execute_8_read_1);
	type ISA_state_t is (st_execute_11, st_execute_7, st_execute_8, st_fetch_18, st_fetch_19);
	type ALUfuncType is (ALU_ADD, ALU_AND, ALU_COPY1, ALU_OR, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_SRA, ALU_SRL, ALU_SUB, ALU_XOR);
	type EncType is (ENC_B, ENC_I_I, ENC_I_J, ENC_I_L, ENC_I_S, ENC_J, ENC_R, ENC_S, ENC_U, ENC_X);
	type InstrType is (INSTR_ADD, INSTR_ADDI, INSTR_AND, INSTR_ANDI, INSTR_AUIPC, INSTR_BEQ, INSTR_BGE, INSTR_BGEU, INSTR_BLT, INSTR_BLTU, INSTR_BNE, INSTR_CSRRC, INSTR_CSRRCI, INSTR_CSRRS, INSTR_CSRRSI, INSTR_CSRRW, INSTR_CSRRWI, INSTR_LB, INSTR_LBU, INSTR_LH, INSTR_LHU, INSTR_LUI, INSTR_LW, INSTR_OR, INSTR_ORI, INSTR_SB, INSTR_SH, INSTR_SLL, INSTR_SLLI, INSTR_SLT, INSTR_SLTI, INSTR_SLTIU, INSTR_SLTU, INSTR_SRA, INSTR_SRAI, INSTR_SRL, INSTR_SRLI, INSTR_SUB, INSTR_SW, INSTR_XOR, INSTR_XORI);

	-- Declare signals
	signal active_state: ISA_state_t;
	signal active_operation: ISA_operation_t;
	signal mcause: unsigned(31 downto 0);
	signal mepc: unsigned(31 downto 0);
	signal mie: unsigned(31 downto 0);
	signal mip: unsigned(31 downto 0);
	signal mstatus: unsigned(31 downto 0);
	signal mtvec: unsigned(31 downto 0);
	signal pcReg: unsigned(31 downto 0);
	signal toMemoryData: CUtoME_IF;
	signal toRegsData: RegfileWriteType;

	-- Declare state signals that are used by ITL properties for OneSpin
	signal execute_7: boolean;
	signal execute_8: boolean;
	signal execute_11: boolean;
	signal fetch_18: boolean;
	signal fetch_19: boolean;


	-- Functions
	function getALUfunc(instr: InstrType) return ALUfuncType;
	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned;
	function getBranchResult(aluResult: unsigned; encodedInstr: unsigned; pcReg: unsigned) return unsigned;
	function getCSR(encodedInstr: unsigned; mcause: unsigned; mepc: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; mtvec: unsigned) return unsigned;
	function getCSRresult(csr: unsigned; instr: InstrType; rs1: unsigned) return unsigned;
	function getEncType(encodedInstr: unsigned) return EncType;
	function getImmediate(encodedInstr: unsigned) return unsigned;
	function getInstrType(encodedInstr: unsigned) return InstrType;
	function getMemoryMask(instr: InstrType) return ME_MaskType;
	function readRegfile(fromRegsData_reg_file_01: unsigned; fromRegsData_reg_file_02: unsigned; fromRegsData_reg_file_03: unsigned; fromRegsData_reg_file_04: unsigned; fromRegsData_reg_file_05: unsigned; fromRegsData_reg_file_06: unsigned; fromRegsData_reg_file_07: unsigned; fromRegsData_reg_file_08: unsigned; fromRegsData_reg_file_09: unsigned; fromRegsData_reg_file_10: unsigned; fromRegsData_reg_file_11: unsigned; fromRegsData_reg_file_12: unsigned; fromRegsData_reg_file_13: unsigned; fromRegsData_reg_file_14: unsigned; fromRegsData_reg_file_15: unsigned; fromRegsData_reg_file_16: unsigned; fromRegsData_reg_file_17: unsigned; fromRegsData_reg_file_18: unsigned; fromRegsData_reg_file_19: unsigned; fromRegsData_reg_file_20: unsigned; fromRegsData_reg_file_21: unsigned; fromRegsData_reg_file_22: unsigned; fromRegsData_reg_file_23: unsigned; fromRegsData_reg_file_24: unsigned; fromRegsData_reg_file_25: unsigned; fromRegsData_reg_file_26: unsigned; fromRegsData_reg_file_27: unsigned; fromRegsData_reg_file_28: unsigned; fromRegsData_reg_file_29: unsigned; fromRegsData_reg_file_30: unsigned; fromRegsData_reg_file_31: unsigned; src: unsigned) return unsigned;
	function updateMCAUSE(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned) return unsigned;
	function updateMEPC(mcause: unsigned; mepc: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; pcReg: unsigned) return unsigned;
	function updateMSTATUS(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned) return unsigned;
	function updatePC(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; mtvec: unsigned; pcReg: unsigned) return unsigned;

	function getALUfunc(instr: InstrType) return ALUfuncType is
	begin
		if (instr = INSTR_LUI) then return ALU_COPY1;
		elsif (((((((((((instr = INSTR_AUIPC) or (instr = INSTR_LB)) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU)) or (instr = INSTR_SB)) or (instr = INSTR_SH)) or (instr = INSTR_SW)) or (instr = INSTR_ADDI)) or (instr = INSTR_ADD)) then return ALU_ADD;
		elsif (((instr = INSTR_BEQ) or (instr = INSTR_BNE)) or (instr = INSTR_SUB)) then return ALU_SUB;
		elsif ((((instr = INSTR_BLT) or (instr = INSTR_BGE)) or (instr = INSTR_SLTI)) or (instr = INSTR_SLT)) then return ALU_SLT;
		elsif ((((instr = INSTR_BLTU) or (instr = INSTR_BGEU)) or (instr = INSTR_SLTIU)) or (instr = INSTR_SLTU)) then return ALU_SLTU;
		elsif ((instr = INSTR_XORI) or (instr = INSTR_XOR)) then return ALU_XOR;
		elsif ((instr = INSTR_ORI) or (instr = INSTR_OR)) then return ALU_OR;
		elsif ((instr = INSTR_ANDI) or (instr = INSTR_AND)) then return ALU_AND;
		elsif ((instr = INSTR_SLLI) or (instr = INSTR_SLL)) then return ALU_SLL;
		elsif ((instr = INSTR_SRLI) or (instr = INSTR_SRL)) then return ALU_SRL;
		else return ALU_SRA;
		end if;
	end getALUfunc;

	function getALUresult(aluFunction: ALUfuncType; operand1: unsigned; operand2: unsigned) return unsigned is
	begin
		if (aluFunction = ALU_COPY1) then return operand1;
		elsif (aluFunction = ALU_ADD) then return (operand1 + operand2);
		elsif (aluFunction = ALU_SUB) then return (operand1 - operand2);
		elsif (aluFunction = ALU_SLT) and (signed(operand1) < signed(operand2)) then return x"00000001";
		elsif (aluFunction = ALU_SLT) then return x"00000000";
		elsif (aluFunction = ALU_SLTU) and (operand1 < operand2) then return x"00000001";
		elsif (aluFunction = ALU_SLTU) then return x"00000000";
		elsif (aluFunction = ALU_XOR) then return (operand1 xor operand2);
		elsif (aluFunction = ALU_OR) then return (operand1 or operand2);
		elsif (aluFunction = ALU_AND) then return (operand1 and operand2);
		elsif (aluFunction = ALU_SLL) then return shift_left(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		elsif (aluFunction = ALU_SRL) then return shift_right(operand1, to_integer(operand2 and to_unsigned(31, 32)));
		else return unsigned(shift_right(signed(operand1), to_integer(signed(operand2 and to_unsigned(31, 32)))));
		end if;
	end getALUresult;

	function getBranchResult(aluResult: unsigned; encodedInstr: unsigned; pcReg: unsigned) return unsigned is
	begin
		if ((((getInstrType(encodedInstr) = INSTR_BEQ) or (getInstrType(encodedInstr) = INSTR_BGE)) or (getInstrType(encodedInstr) = INSTR_BGEU)) and (aluResult = x"00000000")) then return (pcReg + getImmediate(encodedInstr));
		elsif (((getInstrType(encodedInstr) = INSTR_BLT) or (getInstrType(encodedInstr) = INSTR_BLTU)) and (aluResult = x"00000001")) then return (pcReg + getImmediate(encodedInstr));
		elsif ((getInstrType(encodedInstr) = INSTR_BNE) and (aluResult /= x"00000000")) then return (pcReg + getImmediate(encodedInstr));
		else return (pcReg + x"00000004");
		end if;
	end getBranchResult;

	function getCSR(encodedInstr: unsigned; mcause: unsigned; mepc: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; mtvec: unsigned) return unsigned is
	begin
		if (shift_right(encodedInstr, 20) = x"00000300") then return mstatus;
		elsif (shift_right(encodedInstr, 20) = x"00000304") then return mie;
		elsif (shift_right(encodedInstr, 20) = x"00000305") then return mtvec;
		elsif (shift_right(encodedInstr, 20) = x"00000341") then return mepc;
		elsif (shift_right(encodedInstr, 20) = x"00000342") then return mcause;
		else return mip;
		end if;
	end getCSR;

	function getCSRresult(csr: unsigned; instr: InstrType; rs1: unsigned) return unsigned is
	begin
		if ((instr = INSTR_CSRRW) or (instr = INSTR_CSRRWI)) then return rs1;
		elsif ((instr = INSTR_CSRRS) or (instr = INSTR_CSRRSI)) then return (csr or rs1);
		else return (csr and ((not(rs1) + 1) - x"00000001"));
		end if;
	end getCSRresult;

	function getEncType(encodedInstr: unsigned) return EncType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") then return ENC_R;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return ENC_I_I;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return ENC_I_L;
		elsif ((encodedInstr and x"0000007f") = x"00000067") then return ENC_I_J;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return ENC_S;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return ENC_B;
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return ENC_J;
		elsif ((encodedInstr and x"0000007f") = x"00000073") then return ENC_I_S;
		elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return ENC_U;
		else return ENC_X;
		end if;
	end getEncType;

	function getImmediate(encodedInstr: unsigned) return unsigned is
	begin
		if (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return (encodedInstr and x"fffff000");
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f"));
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return (x"fffff000" or ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f")));
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e"));
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return (x"fffff000" or (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e")));
		elsif ((encodedInstr and x"0000007f") = x"0000006f") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe"));
		elsif ((encodedInstr and x"0000007f") = x"0000006f") then return (x"fff00000" or (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe")));
		elsif ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
		else return (x"fffff000" or shift_right(encodedInstr, 20));
		end if;
	end getImmediate;

	function getInstrType(encodedInstr: unsigned) return InstrType is
	begin
		if ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SLL;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SLT;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_SLTU;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_XOR;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_OR;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_AND;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) then return INSTR_ADD;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000020")) then return INSTR_SUB;
		elsif ((encodedInstr and x"0000007f") = x"00000033") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) then return INSTR_SRL;
		elsif ((encodedInstr and x"0000007f") = x"00000033") then return INSTR_SRA;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_ADDI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SLLI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SLTI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_SLTIU;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_XORI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_ORI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_ANDI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) then return INSTR_SRLI;
		elsif ((encodedInstr and x"0000007f") = x"00000013") then return INSTR_SRAI;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_LB;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_LH;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_LW;
		elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_LBU;
		elsif ((encodedInstr and x"0000007f") = x"00000003") then return INSTR_LHU;
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_SB;
		elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SH;
		elsif ((encodedInstr and x"0000007f") = x"00000023") then return INSTR_SW;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_BEQ;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_BNE;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_BLT;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_BGE;
		elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_BLTU;
		elsif ((encodedInstr and x"0000007f") = x"00000063") then return INSTR_BGEU;
		elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) and ((encodedInstr and x"0000007f") = x"00000037") then return INSTR_LUI;
		elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return INSTR_AUIPC;
		elsif ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_CSRRW;
		elsif ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_CSRRS;
		elsif ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_CSRRC;
		elsif ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_CSRRWI;
		elsif ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_CSRRSI;
		else return INSTR_CSRRCI;
		end if;
	end getInstrType;

	function getMemoryMask(instr: InstrType) return ME_MaskType is
	begin
		if ((instr = INSTR_LB) or (instr = INSTR_SB)) then return MT_B;
		elsif ((instr = INSTR_LH) or (instr = INSTR_SH)) then return MT_H;
		elsif ((instr = INSTR_LW) or (instr = INSTR_SW)) then return MT_W;
		elsif (instr = INSTR_LBU) then return MT_BU;
		else return MT_HU;
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

	function updateMCAUSE(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned) return unsigned is
	begin
		if ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000800") /= x"00000000") and ((mip and x"00000800") /= x"00000000")) then return x"8000000b";
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000008") /= x"00000000") and ((mip and x"00000008") /= x"00000000")) then return x"80000003";
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000080") /= x"00000000") and ((mip and x"00000080") /= x"00000000")) then return x"80000007";
		elsif ((mstatus and x"00000008") /= x"00000000") then return mcause;
		else return mcause;
		end if;
	end updateMCAUSE;

	function updateMEPC(mcause: unsigned; mepc: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; pcReg: unsigned) return unsigned is
	begin
		if ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000800") /= x"00000000") and ((mip and x"00000800") /= x"00000000")) then return pcReg;
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000008") /= x"00000000") and ((mip and x"00000008") /= x"00000000")) then return pcReg;
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000080") /= x"00000000") and ((mip and x"00000080") /= x"00000000")) then return pcReg;
		elsif ((mstatus and x"00000008") /= x"00000000") then return mepc;
		else return mepc;
		end if;
	end updateMEPC;

	function updateMSTATUS(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned) return unsigned is
	begin
		if ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000800") /= x"00000000") and ((mip and x"00000800") /= x"00000000")) then return (mstatus and x"fffffff7");
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000008") /= x"00000000") and ((mip and x"00000008") /= x"00000000")) then return (mstatus and x"fffffff7");
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000080") /= x"00000000") and ((mip and x"00000080") /= x"00000000")) then return (mstatus and x"fffffff7");
		elsif ((mstatus and x"00000008") /= x"00000000") and (mcause /= x"00000000") then return (mstatus and x"fffffff7");
		elsif ((mstatus and x"00000008") /= x"00000000") then return mstatus;
		else return mstatus;
		end if;
	end updateMSTATUS;

	function updatePC(mcause: unsigned; mie: unsigned; mip: unsigned; mstatus: unsigned; mtvec: unsigned; pcReg: unsigned) return unsigned is
	begin
		if ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000800") /= x"00000000") and ((mip and x"00000800") /= x"00000000")) then return mtvec;
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000008") /= x"00000000") and ((mip and x"00000008") /= x"00000000")) then return mtvec;
		elsif ((mstatus and x"00000008") /= x"00000000") and (((mie and x"00000080") /= x"00000000") and ((mip and x"00000080") /= x"00000000")) then return mtvec;
		elsif ((mstatus and x"00000008") /= x"00000000") and (mcause /= x"00000000") then return mtvec;
		elsif ((mstatus and x"00000008") /= x"00000000") then return pcReg;
		else return pcReg;
		end if;
	end updatePC;


begin
	-- Combinational logic that selects current operation
	process (active_state, COtoME_port_sync, MEtoCO_port_sync, MEtoCO_port_sig.loadedData)
	begin
		case active_state is
		when st_execute_7 =>
			if (not(COtoME_port_sync)) then 
				active_operation <= op_wait_execute_7;
			else--if(COtoME_port_sync) then 
				active_operation <= op_execute_7_write_0;
			end if;
		when st_execute_8 =>
			if (not(MEtoCO_port_sync)) then 
				active_operation <= op_wait_execute_8;
			else--if(MEtoCO_port_sync) then 
				active_operation <= op_execute_8_read_1;
			end if;
		when st_execute_11 =>
			if (not(COtoME_port_sync)) then 
				active_operation <= op_wait_execute_11;
			else--if(COtoME_port_sync) then 
				active_operation <= op_execute_11_write_2;
			end if;
		when st_fetch_18 =>
			if (not(COtoME_port_sync)) then 
				active_operation <= op_wait_fetch_18;
			else--if(COtoME_port_sync) then 
				active_operation <= op_fetch_18_write_3;
			end if;
		when st_fetch_19 =>
			if (not(MEtoCO_port_sync)) then 
				active_operation <= op_wait_fetch_19;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_4;
			elsif ((getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_5;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_6;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_7;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_8;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_9;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_10;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_11;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_12;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_13;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_14;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_15;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_16;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000342") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_17;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and (((getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI)) or (getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI)) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000342") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_18;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_19;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_20;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_21;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_22;
			elsif (not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000342") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_23;
			else--if(not(getEncType(MEtoCO_port_sig.loadedData) = ENC_U) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_J) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_B) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_L) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_S) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_I_I) and not(getEncType(MEtoCO_port_sig.loadedData) = ENC_R) and (getEncType(MEtoCO_port_sig.loadedData) = ENC_I_S) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRWI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRSI) and not(getInstrType(MEtoCO_port_sig.loadedData) = INSTR_CSRRCI) and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000300") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000304") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000305") and not(getImmediate(MEtoCO_port_sig.loadedData) = x"00000341") and (getImmediate(MEtoCO_port_sig.loadedData) = x"00000342") and MEtoCO_port_sync) then 
				active_operation <= op_fetch_19_read_24;
			end if;
		end case;
	end process;

	-- Main process
	process (clk, rst)
	begin
		if (rst = '1') then
			toMemoryData.addrIn <= x"00000000";
			mepc <= x"00000000";
			mip <= x"00000000";
			COtoME_port_sig.addrIn <= x"00000000";
			mie <= x"00000000";
			pcReg <= x"00000000";
			toRegsData.dst <= x"00000000";
			COtoME_port_sig.dataIn <= x"00000000";
			COtoME_port_sig.req <= ME_RD;
			toMemoryData.req <= ME_RD;
			active_state <= st_fetch_18;
			COtoME_port_notify <= true;
			ISAtoRF_port_notify <= false;
			MEtoCO_port_notify <= false;
			COtoME_port_sig.mask <= MT_W;
			mstatus <= x"00000000";
			toMemoryData.mask <= MT_W;
			mcause <= x"00000000";
			toMemoryData.dataIn <= x"00000000";
			mtvec <= x"00000000";
		elsif (clk = '1' and clk'event) then
			case active_operation is
			when op_wait_fetch_18 =>
				COtoME_port_sig.req <= toMemoryData.req;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when op_fetch_18_write_3 =>
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
				ISAtoRF_port_notify <= false;
				active_state <= st_fetch_19;
			when op_wait_fetch_19 =>
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
				ISAtoRF_port_notify <= false;
				active_state <= st_fetch_19;
			when op_fetch_19_read_4 =>
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_5 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), getImmediate(MEtoCO_port_sig.loadedData), pcReg);
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_6 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + getImmediate(MEtoCO_port_sig.loadedData)));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + getImmediate(MEtoCO_port_sig.loadedData)));
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				ISAtoRF_port_sig.dstData <= pcReg + x"00000004";
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + getImmediate(MEtoCO_port_sig.loadedData)));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + getImmediate(MEtoCO_port_sig.loadedData)));
				toMemoryData.mask <= MT_W;
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_7 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData)));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData)));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData)));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")) + getImmediate(MEtoCO_port_sig.loadedData)));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				ISAtoRF_port_sig.dstData <= pcReg + x"00000004";
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_8 =>
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg));
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, getBranchResult(getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"))), MEtoCO_port_sig.loadedData, pcReg));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_9 =>
				COtoME_port_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				COtoME_port_sig.dataIn <= x"00000000";
				COtoME_port_sig.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				toMemoryData.req <= ME_RD;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				active_state <= st_execute_7;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				toMemoryData.dataIn <= x"00000000";
				toMemoryData.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
			when op_fetch_19_read_10 =>
				active_state <= st_execute_11;
				COtoME_port_sig.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				COtoME_port_sig.req <= ME_WR;
				toMemoryData.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				toMemoryData.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"));
				toMemoryData.mask <= getMemoryMask(getInstrType(MEtoCO_port_sig.loadedData));
				toMemoryData.req <= ME_WR;
				COtoME_port_sig.addrIn <= getALUresult(ALU_ADD, readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.dataIn <= readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f"));
			when op_fetch_19_read_11 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), getImmediate(MEtoCO_port_sig.loadedData));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_12 =>
				ISAtoRF_port_sig.dstData <= getALUresult(getALUfunc(getInstrType(MEtoCO_port_sig.loadedData)), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 20) and x"0000001f")));
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_13 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")));
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mtvec, (pcReg + x"00000004"));
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")));
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mtvec, (pcReg + x"00000004"));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mepc, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_14 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mcause <= updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus);
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				mepc <= updateMEPC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus), mepc, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mie <= getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_15 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				mtvec <= getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"));
				mip <= mip_isa_Port_sig;
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), (pcReg + x"00000004"));
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), (pcReg + x"00000004"));
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_16 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.dataIn <= x"00000000";
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mip <= mip_isa_Port_sig;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_17 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_18 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mepc <= updateMEPC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				mcause <= updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus);
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_19 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))));
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")))), mepc, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))));
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")))), mie, mip_isa_Port_sig, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_20 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mepc <= updateMEPC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus), mepc, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mie <= getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.mask <= MT_W;
				mcause <= updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_21 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				mtvec <= getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f")));
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				toMemoryData.mask <= MT_W;
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_22 =>
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				toMemoryData.mask <= MT_W;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_23 =>
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				toMemoryData.dataIn <= x"00000000";
			when op_fetch_19_read_24 =>
				ISAtoRF_port_sig.dstData <= getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec);
				ISAtoRF_port_sig.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				ISAtoRF_port_notify <= true;
				mcause <= updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mepc <= updateMEPC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				mstatus <= updateMSTATUS(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(getCSRresult(getCSR(MEtoCO_port_sig.loadedData, mip, mepc, mie, mcause, mstatus, mtvec), getInstrType(MEtoCO_port_sig.loadedData), readRegfile(RFtoISA_port_sig.reg_file_01, RFtoISA_port_sig.reg_file_02, RFtoISA_port_sig.reg_file_03, RFtoISA_port_sig.reg_file_04, RFtoISA_port_sig.reg_file_05, RFtoISA_port_sig.reg_file_06, RFtoISA_port_sig.reg_file_07, RFtoISA_port_sig.reg_file_08, RFtoISA_port_sig.reg_file_09, RFtoISA_port_sig.reg_file_10, RFtoISA_port_sig.reg_file_11, RFtoISA_port_sig.reg_file_12, RFtoISA_port_sig.reg_file_13, RFtoISA_port_sig.reg_file_14, RFtoISA_port_sig.reg_file_15, RFtoISA_port_sig.reg_file_16, RFtoISA_port_sig.reg_file_17, RFtoISA_port_sig.reg_file_18, RFtoISA_port_sig.reg_file_19, RFtoISA_port_sig.reg_file_20, RFtoISA_port_sig.reg_file_21, RFtoISA_port_sig.reg_file_22, RFtoISA_port_sig.reg_file_23, RFtoISA_port_sig.reg_file_24, RFtoISA_port_sig.reg_file_25, RFtoISA_port_sig.reg_file_26, RFtoISA_port_sig.reg_file_27, RFtoISA_port_sig.reg_file_28, RFtoISA_port_sig.reg_file_29, RFtoISA_port_sig.reg_file_30, RFtoISA_port_sig.reg_file_31, (shift_right(MEtoCO_port_sig.loadedData, 15) and x"0000001f"))), mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				toRegsData.dst <= shift_right(MEtoCO_port_sig.loadedData, 7) and x"0000001f";
				COtoME_port_sig.mask <= MT_W;
				toMemoryData.mask <= MT_W;
				toMemoryData.dataIn <= x"00000000";
			when op_wait_execute_7 =>
				COtoME_port_sig.req <= toMemoryData.req;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				active_state <= st_execute_7;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when op_execute_7_write_0 =>
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
				ISAtoRF_port_notify <= false;
				active_state <= st_execute_8;
			when op_wait_execute_11 =>
				COtoME_port_sig.req <= toMemoryData.req;
				active_state <= st_execute_11;
				COtoME_port_sig.mask <= toMemoryData.mask;
				COtoME_port_sig.dataIn <= toMemoryData.dataIn;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= toMemoryData.addrIn;
			when op_execute_11_write_2 =>
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				ISAtoRF_port_notify <= false;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.mask <= MT_W;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
				toMemoryData.mask <= MT_W;
				toMemoryData.dataIn <= x"00000000";
			when op_wait_execute_8 =>
				COtoME_port_notify <= false;
				MEtoCO_port_notify <= true;
				ISAtoRF_port_notify <= false;
				active_state <= st_execute_8;
			when op_execute_8_read_1 =>
				ISAtoRF_port_notify <= true;
				pcReg <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				toMemoryData.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.dataIn <= x"00000000";
				mip <= mip_isa_Port_sig;
				ISAtoRF_port_sig.dstData <= MEtoCO_port_sig.loadedData;
				mstatus <= updateMSTATUS(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus);
				COtoME_port_sig.req <= ME_RD;
				toMemoryData.req <= ME_RD;
				active_state <= st_fetch_18;
				COtoME_port_notify <= true;
				MEtoCO_port_notify <= false;
				COtoME_port_sig.addrIn <= updatePC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mie, mip_isa_Port_sig, mstatus, mtvec, (pcReg + x"00000004"));
				COtoME_port_sig.mask <= MT_W;
				mcause <= updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus);
				toMemoryData.mask <= MT_W;
				ISAtoRF_port_sig.dst <= toRegsData.dst;
				toMemoryData.dataIn <= x"00000000";
				mepc <= updateMEPC(updateMCAUSE(mcause, mie, mip_isa_Port_sig, mstatus), mepc, mie, mip_isa_Port_sig, mstatus, (pcReg + x"00000004"));
			end case;
		end if;
	end process;

	-- Assigning state signals that are used by ITL properties for OneSpin
	execute_7 <= active_state = st_execute_7;
	execute_8 <= active_state = st_execute_8;
	execute_11 <= active_state = st_execute_11;
	fetch_18 <= active_state = st_fetch_18;
	fetch_19 <= active_state = st_fetch_19;

end ISA_arch;

