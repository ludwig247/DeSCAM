--
-- Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 30.11.18
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.SCAM_Model_types.all;

package ISA_functions is


function OPCODE_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function FUNCT3_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function FUNCT7_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function RS1_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function RS2_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function RD_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function SIGN_FIELD (x : in unsigned (31 downto 0)) return unsigned;

function IMM_U_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function POS_IMM_I_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function POS_IMM_S_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function POS_IMM_B_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function POS_IMM_J_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function NEG_IMM_I_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function NEG_IMM_S_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function NEG_IMM_B_FIELD (x : in unsigned (31 downto 0)) return unsigned;
function NEG_IMM_J_FIELD (x : in unsigned (31 downto 0)) return unsigned;

function MSTATUS_MIE (x : in unsigned (31 downto 0)) return unsigned;
function MTRAP_MEI (x : in unsigned (31 downto 0)) return unsigned;
function MTRAP_MSI (x : in unsigned (31 downto 0)) return unsigned;
function MTRAP_MTI (x : in unsigned (31 downto 0)) return unsigned;

constant OPCODE_U1  : unsigned (31 downto 0) := X"00000037";
constant OPCODE_U2  : unsigned (31 downto 0) := X"00000017";
constant OPCODE_J	: unsigned (31 downto 0) := X"0000006F";
constant OPCODE_I_J	: unsigned (31 downto 0) := X"00000067";
constant OPCODE_B	: unsigned (31 downto 0) := X"00000063";
constant OPCODE_I_L	: unsigned (31 downto 0) := X"00000003";
constant OPCODE_S	: unsigned (31 downto 0) := X"00000023";
constant OPCODE_I_I	: unsigned (31 downto 0) := X"00000013";
constant OPCODE_R	: unsigned (31 downto 0) := X"00000033";
constant OPCODE_I_M	: unsigned (31 downto 0) := X"0000000F";
constant OPCODE_I_S	: unsigned (31 downto 0) := X"00000073";

constant PRIVCODE_ECALL	: unsigned (31 downto 0) := X"00000000";
constant PRIVCODE_EBREAK: unsigned (31 downto 0) := X"00000001";
constant PRIVCODE_MRET	: unsigned (31 downto 0) := X"00000302";

constant MCSR_MSTATUS	: unsigned (31 downto 0) := X"00000300";
constant MCSR_MIE	    : unsigned (31 downto 0) := X"00000304";
constant MCSR_MTVEC	    : unsigned (31 downto 0) := X"00000305";
constant MCSR_MEPC	    : unsigned (31 downto 0) := X"00000341";
constant MCSR_MCAUSE	: unsigned (31 downto 0) := X"00000342";
constant MCSR_MIP	    : unsigned (31 downto 0) := X"00000344";


function getEncType (encodedInstr : in unsigned (31 downto 0)) return EncType;
function getInstrType (encodedInstr : in unsigned (31 downto 0)) return InstrType_Complete;
function getRs1Addr (encodedInstr : in unsigned (31 downto 0)) return unsigned;
function getRs2Addr (encodedInstr : in unsigned (31 downto 0)) return unsigned;
function getRdAddr (encodedInstr : in unsigned (31 downto 0)) return unsigned;
function getImmediate (encodedInstr : in unsigned (31 downto 0)) return unsigned;
function getALUfunc (instr : in InstrType_Complete) return ALUfuncType;
function getMemoryMask (instr : in InstrType_Complete) return ME_MaskType;
function readRegfile (src : in Unsigned (31 downto 0); regfile : in RegfileType) return Unsigned;
function getALUresult (
	aluFunction : in ALUfuncType;
	operand1 : in Unsigned (31 downto 0);
	operand2 : in Unsigned (31 downto 0)) return Unsigned;
function getPrivInstrType (encodedInstr : in unsigned (31 downto 0)) return PrivInstrType;
function getCSR (
	encodedInstr	: in Unsigned (31 downto 0);
	mstatus			: in Unsigned (31 downto 0);
	mie				: in Unsigned (31 downto 0);
	mtvec				: in Unsigned (31 downto 0);
	mepc				: in Unsigned (31 downto 0);
	mcause			: in Unsigned (31 downto 0);
	mip				: in Unsigned (31 downto 0)) return unsigned;
function getCSRresult (
	instr	: in InstrType_Complete;
	rs1	: in Unsigned (31 downto 0);
	csr	: in Unsigned (31 downto 0)) return Unsigned;
function updateMCAUSE (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0)) return Unsigned;
function updateMSTATUS (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0)) return Unsigned;
function updateMEPC (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0);
	mepc		: in Unsigned (31 downto 0);
	pcReg		: in Unsigned (31 downto 0)) return Unsigned;
function updatePC (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0);
	mtvec		: in Unsigned (31 downto 0);
	pcReg		: in Unsigned (31 downto 0)) return Unsigned;
function getBranchresult (
	encodedInstr	: in Unsigned (31 downto 0);
	aluResult		: in Unsigned (31 downto 0);
	pcReg				: in Unsigned (31 downto 0)) return Unsigned;
function getALUresult_U (
	encodedInstr	: in Unsigned (31 downto 0);
	pcReg				: in Unsigned (31 downto 0);
	imm				: in Unsigned (31 downto 0)) return Unsigned;

end package ISA_functions;

package body ISA_functions is

function OPCODE_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (x and X"0000007F");
end function OPCODE_FIELD;

function FUNCT3_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 12) and (X"00000007"));
end function FUNCT3_FIELD;

function FUNCT7_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 25) and (X"0000007F"));
end function FUNCT7_FIELD;

function RS1_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 15) and (X"0000001F"));
end function RS1_FIELD;

function RS2_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 20) and (X"0000001F"));
end function RS2_FIELD;

function RD_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 7) and (X"0000001F"));
end function RD_FIELD;

function SIGN_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (shift_right(x, 31) and (X"00000001"));
end function SIGN_FIELD;

function IMM_U_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return (x) and (X"FFFFF000");
end function IMM_U_FIELD;

function POS_IMM_I_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return shift_right(x, 20);
end function POS_IMM_I_FIELD;

function POS_IMM_S_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (shift_right(x, 20) and (X"00000FE0")) or (shift_right(x, 7) and (X"0000001F")) );
end function POS_IMM_S_FIELD;

function POS_IMM_B_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (shift_left(x, 4) and (X"00000800")) or (shift_right(x, 20) and (X"000007E0")) or (shift_right(x, 7) and (X"0000001E")) );
end function POS_IMM_B_FIELD;

function POS_IMM_J_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( ((x) and (X"000FF000")) or (shift_right(x, 9) and (X"00000800")) or (shift_right(x, 20) and (X"000007FE")) );
end function POS_IMM_J_FIELD;

function NEG_IMM_I_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( POS_IMM_I_FIELD(x) or (X"FFFFF000") );
end function NEG_IMM_I_FIELD;

function NEG_IMM_S_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( POS_IMM_S_FIELD(x) or (X"FFFFF000") );
end function NEG_IMM_S_FIELD;

function NEG_IMM_B_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( POS_IMM_B_FIELD(x) or (X"FFFFF000") );
end function NEG_IMM_B_FIELD;

function NEG_IMM_J_FIELD (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( POS_IMM_J_FIELD(x) or (X"FFF00000") );
end function NEG_IMM_J_FIELD;

function MSTATUS_MIE (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (x) and (X"00000008") );
end function MSTATUS_MIE;

function MTRAP_MEI (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (x) and (X"00000800") );
end function MTRAP_MEI;

function MTRAP_MSI (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (x) and (X"00000008") );
end function MTRAP_MSI;

function MTRAP_MTI (x : in unsigned (31 downto 0)) return unsigned is
begin
	return ( (x) and (X"00000080") );
end function MTRAP_MTI;






function getEncType (encodedInstr : in unsigned (31 downto 0)) return EncType is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_R) then
			return ENC_R;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_I) then
			return ENC_I_I;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_L) then
			return ENC_I_L;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_J) then
			return ENC_I_J;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_M) then
			return ENC_I_M;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_S) then
			return ENC_I_S;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_S) then
			return ENC_S;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_B) then
			return ENC_B;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_U1 or OPCODE_FIELD(encodedInstr) = OPCODE_U2) then
			return ENC_U;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_J) then
			return ENC_J;
	else 
			return ENC_ERR;
	end if;
end function getEncType;

function getInstrType (encodedInstr : in unsigned (31 downto 0)) return InstrType_Complete is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_R) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			if (FUNCT7_FIELD(encodedInstr) = X"00") then
				return INSTR_ADD;
			elsif (FUNCT7_FIELD(encodedInstr) = X"20") then
				return INSTR_SUB;
			else
				return INSTR_UNKNOWN;
			end if;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_SLL;
		elsif (FUNCT3_FIELD(encodedInstr) = X"02") then
			return INSTR_SLT;
		elsif (FUNCT3_FIELD(encodedInstr) = X"03") then
			return INSTR_SLTU;
		elsif (FUNCT3_FIELD(encodedInstr) = X"04") then
			return INSTR_XOR;
		elsif (FUNCT3_FIELD(encodedInstr) = X"05") then
			if (FUNCT7_FIELD(encodedInstr) = X"00") then
				return INSTR_SRL;
			elsif (FUNCT7_FIELD(encodedInstr) = X"20") then
				return INSTR_SRA;
			else
				return INSTR_UNKNOWN;
			end if;
		elsif (FUNCT3_FIELD(encodedInstr) = X"06") then
			return INSTR_OR;
		elsif (FUNCT3_FIELD(encodedInstr) = X"07") then
			return INSTR_AND;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_I) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_ADDI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_SLLI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"02") then
			return INSTR_SLTI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"03") then
			return INSTR_SLTUI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"04") then
			return INSTR_XORI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"05") then
			if (FUNCT7_FIELD(encodedInstr) = X"00") then
				return INSTR_SRLI;
			elsif (FUNCT7_FIELD(encodedInstr) = X"20") then
				return INSTR_SRAI;
			else
				return INSTR_UNKNOWN;
			end if;
		elsif (FUNCT3_FIELD(encodedInstr) = X"06") then
			return INSTR_ORI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"07") then
			return INSTR_ANDI;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_L) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_LB;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_LH;
		elsif (FUNCT3_FIELD(encodedInstr) = X"02") then
			return INSTR_LW;
		elsif (FUNCT3_FIELD(encodedInstr) = X"04") then
			return INSTR_LBU;
		elsif (FUNCT3_FIELD(encodedInstr) = X"05") then
			return INSTR_LHU;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_J) then
		return INSTR_JALR;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_M) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_FENCE;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_FENCEI;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_I_S) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_PRIV;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_CSRRW;
		elsif (FUNCT3_FIELD(encodedInstr) = X"02") then
			return INSTR_CSRRS;
		elsif (FUNCT3_FIELD(encodedInstr) = X"03") then
			return INSTR_CSRRC;
		elsif (FUNCT3_FIELD(encodedInstr) = X"05") then
			return INSTR_CSRRWI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"06") then
			return INSTR_CSRRSI;
		elsif (FUNCT3_FIELD(encodedInstr) = X"07") then
			return INSTR_CSRRCI;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_S) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_SB;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_SH;
		elsif (FUNCT3_FIELD(encodedInstr) = X"02") then
			return INSTR_SW;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_B) then
		if (FUNCT3_FIELD(encodedInstr) = X"00") then
			return INSTR_BEQ;
		elsif (FUNCT3_FIELD(encodedInstr) = X"01") then
			return INSTR_BNE;
		elsif (FUNCT3_FIELD(encodedInstr) = X"04") then
			return INSTR_BLT;
		elsif (FUNCT3_FIELD(encodedInstr) = X"05") then
			return INSTR_BGE;
		elsif (FUNCT3_FIELD(encodedInstr) = X"06") then
			return INSTR_BLTU;
		elsif (FUNCT3_FIELD(encodedInstr) = X"07") then
			return INSTR_BGEU;
		else
			return INSTR_UNKNOWN;
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_U1) then
		return INSTR_LUI;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_U2) then
		return INSTR_AUIPC;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_J) then
		return INSTR_JAL;
	else
		return INSTR_UNKNOWN;
	end if;
end function getInstrType;

function getRs1Addr (encodedInstr : in unsigned (31 downto 0)) return unsigned is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_R or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_I or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_L or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_J or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_S or
		OPCODE_FIELD(encodedInstr) = OPCODE_S or
		OPCODE_FIELD(encodedInstr) = OPCODE_B) then
		return RS1_FIELD(encodedInstr);
	else
		return to_unsigned(0, 32);
	end if;
end function getRs1Addr;

function getRs2Addr (encodedInstr : in unsigned (31 downto 0)) return unsigned is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_R or
		OPCODE_FIELD(encodedInstr) = OPCODE_S or
		OPCODE_FIELD(encodedInstr) = OPCODE_B) then
		return RS2_FIELD(encodedInstr);
	else
		return to_unsigned(0, 32);
	end if;
end function getRs2Addr;

function getRdAddr (encodedInstr : in unsigned (31 downto 0)) return unsigned is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_R or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_I or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_L or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_J or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_S or
		OPCODE_FIELD(encodedInstr) = OPCODE_U1 or
		OPCODE_FIELD(encodedInstr) = OPCODE_U2 or
		OPCODE_FIELD(encodedInstr) = OPCODE_J) then
		return RD_FIELD(encodedInstr);
	else
		return to_unsigned(0, 32);
	end if;
end function getRdAddr;

function getImmediate (encodedInstr : in unsigned (31 downto 0)) return unsigned is
begin
	if (OPCODE_FIELD(encodedInstr) = OPCODE_I_I or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_L or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_M or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_S or
		OPCODE_FIELD(encodedInstr) = OPCODE_I_J) then
		if (SIGN_FIELD(encodedInstr) = 0) then
			return POS_IMM_I_FIELD(encodedInstr);
		else
			return NEG_IMM_I_FIELD(encodedInstr);
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_S) then
		if (SIGN_FIELD(encodedInstr) = 0) then
			return POS_IMM_S_FIELD(encodedInstr);
		else
			return NEG_IMM_S_FIELD(encodedInstr);
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_B) then
		if (SIGN_FIELD(encodedInstr) = 0) then
			return POS_IMM_B_FIELD(encodedInstr);
		else
			return NEG_IMM_B_FIELD(encodedInstr);
		end if;
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_U1 or
			OPCODE_FIELD(encodedInstr) = OPCODE_U2) then
			return IMM_U_FIELD(encodedInstr);
	elsif (OPCODE_FIELD(encodedInstr) = OPCODE_J) then
		if (SIGN_FIELD(encodedInstr) = 0) then
			return POS_IMM_J_FIELD(encodedInstr);
		else
			return NEG_IMM_J_FIELD(encodedInstr);
		end if;
	else
		return to_unsigned(0, 32);
	end if;
end function getImmediate;

function getALUfunc (instr : in InstrType_Complete) return ALUfuncType is
begin
	if (instr = INSTR_ADD or instr = INSTR_ADDI or
		instr = INSTR_LB or instr = INSTR_LH or instr = INSTR_LW or instr = INSTR_LBU or instr = INSTR_LHU or
		instr = INSTR_SB or instr = INSTR_SH or instr = INSTR_SW or
		instr = INSTR_AUIPC) then
		return ALU_ADD;
	elsif (instr = INSTR_SUB or
		instr = INSTR_BEQ or instr = INSTR_BNE) then
		return ALU_SUB;
	elsif (instr = INSTR_SLL or instr = INSTR_SLLI) then
		return ALU_SLL;
	elsif (instr = INSTR_SLT or instr = INSTR_SLTI or
		instr = INSTR_BLT or instr = INSTR_BGE) then
		return ALU_SLT;
	elsif (instr = INSTR_SLTU or instr = INSTR_SLTUI or
		instr = INSTR_BLTU or instr = INSTR_BGEU) then
		return ALU_SLTU;
	elsif (instr = INSTR_XOR or instr = INSTR_XORI) then
		return ALU_XOR;
	elsif (instr = INSTR_SRL or instr = INSTR_SRLI) then
		return ALU_SRL;
	elsif (instr = INSTR_SRA or instr = INSTR_SRAI) then
		return ALU_SRA;
	elsif (instr = INSTR_OR or instr = INSTR_ORI) then
		return ALU_OR;
	elsif (instr = INSTR_AND or instr = INSTR_ANDI) then
		return ALU_AND;
	elsif (instr = INSTR_JALR or instr = INSTR_JAL) then
		return ALU_X;
	elsif (instr = INSTR_BLT or instr = INSTR_BGE) then
		return ALU_SLT;
	elsif (instr = INSTR_LUI) then
		return ALU_COPY1;
	else 
		return ALU_X;
	end if;
end function getALUfunc;

function getMemoryMask (instr : in InstrType_Complete) return ME_MaskType is
begin
	if (instr = INSTR_LW or instr = INSTR_SW) then
		return MT_W;
	elsif (instr = INSTR_LH or instr = INSTR_SH) then
		return MT_H;
	elsif (instr = INSTR_LB or instr = INSTR_SB) then
		return MT_B;
	elsif (instr = INSTR_LHU) then
		return MT_HU;
	elsif (instr = INSTR_LBU) then
		return MT_BU;
	else
		return MT_X;
	end if;
end function getMemoryMask;

function readRegfile (src : in Unsigned (31 downto 0); regfile : in RegfileType) return Unsigned is
begin
	if    (src = 0) then
		return to_unsigned(0, 32);
	elsif (src = 1) then
		return regfile.reg_file_01;
	elsif (src = 2) then
		return regfile.reg_file_02;
	elsif (src = 3) then
		return regfile.reg_file_03;
	elsif (src = 4) then
		return regfile.reg_file_04;
	elsif (src = 5) then
		return regfile.reg_file_05;
	elsif (src = 6) then
		return regfile.reg_file_06;
	elsif (src = 7) then
		return regfile.reg_file_07;
	elsif (src = 8) then
		return regfile.reg_file_08;
	elsif (src = 9) then
		return regfile.reg_file_09;
	elsif (src = 10) then
		return regfile.reg_file_10;
	elsif (src = 11) then
		return regfile.reg_file_11;
	elsif (src = 12) then
		return regfile.reg_file_12;
	elsif (src = 13) then
		return regfile.reg_file_13;
	elsif (src = 14) then
		return regfile.reg_file_14;
	elsif (src = 15) then
		return regfile.reg_file_15;
	elsif (src = 16) then
		return regfile.reg_file_16;
	elsif (src = 17) then
		return regfile.reg_file_17;
	elsif (src = 18) then
		return regfile.reg_file_18;
	elsif (src = 19) then
		return regfile.reg_file_19;
	elsif (src = 20) then
		return regfile.reg_file_20;
	elsif (src = 21) then
		return regfile.reg_file_21;
	elsif (src = 22) then
		return regfile.reg_file_22;
	elsif (src = 23) then
		return regfile.reg_file_23;
	elsif (src = 24) then
		return regfile.reg_file_24;
	elsif (src = 25) then
		return regfile.reg_file_25;
	elsif (src = 26) then
		return regfile.reg_file_26;
	elsif (src = 27) then
		return regfile.reg_file_27;
	elsif (src = 28) then
		return regfile.reg_file_28;
	elsif (src = 29) then
		return regfile.reg_file_29;
	elsif (src = 30) then
		return regfile.reg_file_30;
	else
		return regfile.reg_file_31;
	end if;
end function readRegfile;

function getALUresult (
	aluFunction : in ALUfuncType;
	operand1 : in Unsigned (31 downto 0);
	operand2 : in Unsigned (31 downto 0)) return Unsigned is
begin
	if (aluFunction = ALU_ADD) then
		return (operand1 + operand2);
	elsif (aluFunction = ALU_SUB) then
		return (operand1 - operand2);
	elsif (aluFunction = ALU_AND) then
		return (operand1 and operand2);
	elsif (aluFunction = ALU_OR) then
		return (operand1 or operand2);
	elsif (aluFunction = ALU_XOR) then
		return (operand1 xor operand2);
	elsif (aluFunction = ALU_SLT) then
		if (signed(operand1) < signed(operand2)) then
			return to_unsigned(1, 32);
		else
			return to_unsigned(0, 32);
		end if;
	elsif (aluFunction = ALU_SLTU) then
		if (operand1 < operand2) then
			return to_unsigned(1, 32);
		else 
			return to_unsigned(0, 32);
		end if;
	elsif (aluFunction = ALU_SLL) then
		return shift_left(operand1, to_integer(operand2 and to_unsigned(31, 32)));
	elsif (aluFunction = ALU_SRA) then
		return unsigned(shift_right(signed(operand1), to_integer(operand2 and to_unsigned(31, 32))));   
	elsif (aluFunction = ALU_SRL) then
		return shift_right(operand1, to_integer(operand2 and to_unsigned(31, 32)));
	elsif (aluFunction = ALU_COPY1) then
		return operand2;
	else 
		return to_unsigned(0, 32);
	end if;
end function getALUresult;

function getPrivInstrType (encodedInstr : in unsigned (31 downto 0)) return PrivInstrType is
begin
	if(POS_IMM_I_FIELD(encodedInstr) = PRIVCODE_ECALL) then
		return INSTR_ECALL;
	elsif (POS_IMM_I_FIELD(encodedInstr) = PRIVCODE_EBREAK) then
		return INSTR_EBREAK;
	elsif (POS_IMM_I_FIELD(encodedInstr) = PRIVCODE_MRET) then
		return INSTR_MRET;
	else
		return INSTR_PRIV_UNKNOWN;
	end if;
end function getPrivInstrType;

function getCSR (
	encodedInstr	: in Unsigned (31 downto 0);
	mstatus			: in Unsigned (31 downto 0);
	mie				: in Unsigned (31 downto 0);
	mtvec				: in Unsigned (31 downto 0);
	mepc				: in Unsigned (31 downto 0);
	mcause			: in Unsigned (31 downto 0);
	mip				: in Unsigned (31 downto 0) ) return unsigned is
begin
	if(POS_IMM_I_FIELD(encodedInstr) = MCSR_MSTATUS) then
		return mstatus;
	elsif (POS_IMM_I_FIELD(encodedInstr) = MCSR_MIE) then
		return mie;
	elsif (POS_IMM_I_FIELD(encodedInstr) = MCSR_MTVEC) then
		return mtvec;
	elsif (POS_IMM_I_FIELD(encodedInstr) = MCSR_MEPC) then
		return mepc;
	elsif (POS_IMM_I_FIELD(encodedInstr) = MCSR_MCAUSE) then
		return mcause;
	elsif (POS_IMM_I_FIELD(encodedInstr) = MCSR_MIP) then
		return mip;
	else
		return to_unsigned(0, 32);
	end if;
end function getCSR;

function getCSRresult (
	instr	: in InstrType_Complete;
	rs1	: in Unsigned (31 downto 0);
	csr	: in Unsigned (31 downto 0)) return Unsigned is
begin
	if ( (instr = INSTR_CSRRW) or (instr = INSTR_CSRRWI) ) then
		return rs1;
	elsif ( (instr = INSTR_CSRRS) or (instr = INSTR_CSRRSI) ) then
		return ( csr or rs1 );
	elsif ( (instr = INSTR_CSRRC) or (instr = INSTR_CSRRCI) ) then
		return ( csr and not(rs1) );
	else
		return to_unsigned(0, 32);
	end if;
end function getCSRresult;

function updateMCAUSE (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (MSTATUS_MIE(mstatus) /= 0) then
		if ((MTRAP_MEI(mie) /= 0) and (MTRAP_MEI(mip) /= 0)) then
			return X"8000000B";
		elsif ((MTRAP_MSI(mie) /= 0) and (MTRAP_MSI(mip) /= 0)) then
			return X"80000003";
		elsif ((MTRAP_MTI(mie) /= 0) and (MTRAP_MTI(mip) /= 0)) then
			return X"80000007";
		elsif (mcause /= 0) then
			return mcause;
		else
			return mcause;
		end if;
	else
		return mcause;
	end if;
end function updateMCAUSE;

function updateMSTATUS (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (MSTATUS_MIE(mstatus) /= 0) then
		if ((MTRAP_MEI(mie) /= 0) and (MTRAP_MEI(mip) /= 0)) then
			return mstatus and X"FFFFFFF7";
		elsif ((MTRAP_MSI(mie) /= 0) and (MTRAP_MSI(mip) /= 0)) then
			return mstatus and X"FFFFFFF7";
		elsif ((MTRAP_MTI(mie) /= 0) and (MTRAP_MTI(mip) /= 0)) then
			return mstatus and X"FFFFFFF7";
		elsif (mcause /= 0) then
			return mstatus and X"FFFFFFF7";
		else
			return mstatus;
		end if;
	else
		return mstatus;
	end if;
end function updateMSTATUS;

function updateMEPC (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0);
	mepc		: in Unsigned (31 downto 0);
	pcReg		: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (MSTATUS_MIE(mstatus) /= 0) then
		if ((MTRAP_MEI(mie) /= 0) and (MTRAP_MEI(mip) /= 0)) then
			return pcReg;
		elsif ((MTRAP_MSI(mie) /= 0) and (MTRAP_MSI(mip) /= 0)) then
			return pcReg;
		elsif ((MTRAP_MTI(mie) /= 0) and (MTRAP_MTI(mip) /= 0)) then
			return pcReg;
		elsif (mcause /= 0) then
			return mepc;
		else
			return mepc;
		end if;
	else
		return mepc;
	end if;
end function updateMEPC;

function updatePC (
	mstatus	: in Unsigned (31 downto 0);
	mie		: in Unsigned (31 downto 0);
	mip		: in Unsigned (31 downto 0);
	mcause	: in Unsigned (31 downto 0);
	mtvec		: in Unsigned (31 downto 0);
	pcReg		: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (MSTATUS_MIE(mstatus) /= 0) then
		if ((MTRAP_MEI(mie) /= 0) and (MTRAP_MEI(mip) /= 0)) then
			return mtvec;
		elsif ((MTRAP_MSI(mie) /= 0) and (MTRAP_MSI(mip) /= 0)) then
			return mtvec;
		elsif ((MTRAP_MTI(mie) /= 0) and (MTRAP_MTI(mip) /= 0)) then
			return mtvec;
		elsif (mcause /= 0) then
			return mtvec;
		else
			return pcReg;
		end if;
	else
		return pcReg;
	end if;
end function updatePC;

function getBranchresult (
	encodedInstr	: in Unsigned (31 downto 0);
	aluResult		: in Unsigned (31 downto 0);
	pcReg				: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (getInstrType(encodedInstr) = INSTR_BEQ and aluResult = 0) then
		return pcReg + getImmediate(encodedInstr);
	elsif (getInstrType(encodedInstr) = INSTR_BNE and aluResult /= 0) then
		return pcReg + getImmediate(encodedInstr);
	elsif (getInstrType(encodedInstr) = INSTR_BLT and aluResult = 1) then
		return pcReg + getImmediate(encodedInstr);
	elsif (getInstrType(encodedInstr) = INSTR_BGE and aluResult = 0) then
		return pcReg + getImmediate(encodedInstr);
	elsif (getInstrType(encodedInstr) = INSTR_BLTU and aluResult = 1) then
		return pcReg + getImmediate(encodedInstr);
	elsif (getInstrType(encodedInstr) = INSTR_BGEU and aluResult = 0) then
		return pcReg + getImmediate(encodedInstr);
	else
		return pcReg + 4;
	end if;
end function getBranchresult;

function getALUresult_U (
	encodedInstr	: in Unsigned (31 downto 0);
	pcReg				: in Unsigned (31 downto 0);
	imm				: in Unsigned (31 downto 0)) return Unsigned is
begin
	if (getInstrType(encodedInstr) = INSTR_LUI) then
		return getALUresult(ALU_COPY1, pcReg, imm);
	else
		return getALUresult(ALU_ADD, pcReg, imm);
	end if;
end function getALUresult_U;

end ISA_functions;
