-- External function definition package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.SCAM_Model_types.all;

package core_functions is
    
    -- Types	
    type ALUFunc_t is (ALUF_X, ALUF_ADD, ALUF_AND, ALUF_COPY1, ALUF_OR, ALUF_SLL, ALUF_SLT, ALUF_SLTU, ALUF_SRA, ALUF_SRL, ALUF_SUB, ALUF_XOR);
    type Instr_t is (INSTR_UNKNOWN, INSTR_ADD, INSTR_ADDI, INSTR_AND, INSTR_ANDI, INSTR_AUIPC, INSTR_BEQ, INSTR_BGE, INSTR_BGEU, INSTR_BLT, INSTR_BLTU, INSTR_BNE, INSTR_CSRRC, INSTR_CSRRCI, INSTR_CSRRS, INSTR_CSRRSI, INSTR_CSRRW, INSTR_CSRRWI, INSTR_EBREAK, INSTR_ECALL, INSTR_FENCE, INSTR_FENCEI, INSTR_JAL, INSTR_JALR, INSTR_LB, INSTR_LBU, INSTR_LH, INSTR_LHU, INSTR_LUI, INSTR_LW, INSTR_MRET, INSTR_OR, INSTR_ORI, INSTR_SB, INSTR_SFENCEVMA, INSTR_SH, INSTR_SLL, INSTR_SLLI, INSTR_SLT, INSTR_SLTI, INSTR_SLTIU, INSTR_SLTU, INSTR_SRA, INSTR_SRAI, INSTR_SRET, INSTR_SRL, INSTR_SRLI, INSTR_SUB, INSTR_SW, INSTR_URET, INSTR_WFI, INSTR_XOR, INSTR_XORI);
    type ALUSrc_t is (ALUS_X, ALUS_RS2, ALUS_IMM);
    type RegSrc_t is (RS_X, RS_ALU, RS_MEM);
    type MemAction_t is (MA_NONE, MA_READ, MA_WRITE);

    -- Constants
    constant OPCODE_U_LUI:      unsigned := x"00000037"; --0110111
    constant OPCODE_U_AUIPC:    unsigned := x"00000017"; --0010111
    constant OPCODE_J_JAL:      unsigned := x"0000006F"; --1101111
    constant OPCODE_I_JALR:     unsigned := x"00000067"; --1100111
    constant OPCODE_B:          unsigned := x"00000063"; --1100011
    constant OPCODE_I_L:        unsigned := x"00000003"; --0000011
    constant OPCODE_S:          unsigned := x"00000023"; --0100011
    constant OPCODE_I:          unsigned := x"00000013"; --0010011
    constant OPCODE_R:          unsigned := x"00000033"; --0110011
    constant OPCODE_MEM:        unsigned := x"0000000F"; --0001111
    constant OPCODE_SYS:        unsigned := x"00000073"; --1110011

	-- Functions
    function getALUFunc(instr: Instr_t) return ALUFunc_t;
    function getALUResult(func: ALUFunc_t; op1: unsigned; op2: unsigned) return unsigned;
    function getBranchResult(ALUResult: unsigned; PCReg: unsigned; encodedInstr: unsigned) return unsigned;
    function getFunct3(encodedInstr: unsigned) return unsigned;
    function getFunct7(encodedInstr: unsigned) return unsigned;
    function getImmediate(encodedInstr: unsigned) return unsigned;
    function getInstr(encodedInstr: unsigned) return Instr_t;
    function getMemoryMask(instr: Instr_t) return ME_MaskType;
    function getOpcode(encodedInstr: unsigned) return unsigned;
    function getRDAddr(encodedInstr: unsigned) return unsigned;
    function getRS1Addr(encodedInstr: unsigned) return unsigned;
    function getRS2Addr(encodedInstr: unsigned) return unsigned;
	
end package core_functions;
	
package body core_functions is

    function getALUFunc(instr: Instr_t) return ALUFunc_t is
    begin
        if ((instr = INSTR_ADD) or (instr = INSTR_ADDI)) then return ALUF_ADD;
        elsif (instr = INSTR_SUB) then return ALUF_SUB;
        elsif ((instr = INSTR_SLL) or (instr = INSTR_SLLI)) then return ALUF_SLL;
        elsif ((instr = INSTR_SLT) or (instr = INSTR_SLTI)) then return ALUF_SLT;
        elsif ((instr = INSTR_SLTU) or (instr = INSTR_SLTIU)) then return ALUF_SLTU;
        elsif ((instr = INSTR_XOR) or (instr = INSTR_XORI)) then return ALUF_XOR;
        elsif ((instr = INSTR_SRL) or (instr = INSTR_SRLI)) then return ALUF_SRL;
        elsif ((instr = INSTR_SRA) or (instr = INSTR_SRAI)) then return ALUF_SRA;
        elsif ((instr = INSTR_OR) or (instr = INSTR_ORI)) then return ALUF_OR;
        elsif ((instr = INSTR_AND) or (instr = INSTR_ANDI)) then return ALUF_AND;
        elsif (((((instr = INSTR_LB) or (instr = INSTR_LH)) or (instr = INSTR_LW)) or (instr = INSTR_LBU)) or (instr = INSTR_LHU)) then return ALUF_ADD;
        elsif ((instr = INSTR_JALR) or (instr = INSTR_JAL)) then return ALUF_X;
        elsif ((instr = INSTR_BEQ) or (instr = INSTR_BNE)) then return ALUF_SUB;
        elsif ((instr = INSTR_BLT) or (instr = INSTR_BGE)) then return ALUF_SLT;
        elsif ((instr = INSTR_BLTU) or (instr = INSTR_BGEU)) then return ALUF_SLTU;
        elsif (((instr = INSTR_SB) or (instr = INSTR_SH)) or (instr = INSTR_SW)) then return ALUF_ADD;
        elsif (instr = INSTR_AUIPC) then return ALUF_ADD;
        elsif (instr = INSTR_LUI) then return ALUF_COPY1;
        else return ALUF_X;
        end if;
    end getALUFunc;

    function getALUResult(func: ALUFunc_t; op1: unsigned; op2: unsigned) return unsigned is
    begin
        if (func = ALUF_ADD) then return (op1 + op2);
        elsif (func = ALUF_SUB) then return (op1 - op2);
        elsif (func = ALUF_AND) then return (op1 and op2);
        elsif (func = ALUF_OR) then return (op1 or op2);
        elsif (func = ALUF_XOR) then return (op1 xor op2);
        elsif (func = ALUF_SLT) and (signed(op1) < signed(op2)) then return x"00000001";
        elsif (func = ALUF_SLT) then return x"00000000";
        elsif (func = ALUF_SLTU) and (op1 < op2) then return x"00000001";
        elsif (func = ALUF_SLTU) then return x"00000000";
        elsif (func = ALUF_SLL) then return shift_left(op1, to_integer(op2 and to_unsigned(31, 32)));
        elsif (func = ALUF_SRA) then return unsigned(shift_right(signed(op1), to_integer(signed(op2 and to_unsigned(31, 32)))));
        elsif (func = ALUF_SRL) then return shift_right(op1, to_integer(op2 and to_unsigned(31, 32)));
        elsif (func = ALUF_COPY1) then return op1;
        else return x"00000000";
        end if;
    end getALUResult;

    function getBranchResult(ALUResult: unsigned; PCReg: unsigned; encodedInstr: unsigned) return unsigned is
    begin
        if ((getInstr(encodedInstr) = INSTR_BEQ) and (ALUResult = x"00000000")) then return (PCReg + getImmediate(encodedInstr));
        elsif ((getInstr(encodedInstr) = INSTR_BNE) and (ALUResult /= x"00000000")) then return (PCReg + getImmediate(encodedInstr));
        elsif ((getInstr(encodedInstr) = INSTR_BLT) and (ALUResult = x"00000001")) then return (PCReg + getImmediate(encodedInstr));
        elsif ((getInstr(encodedInstr) = INSTR_BGE) and (ALUResult = x"00000000")) then return (PCReg + getImmediate(encodedInstr));
        elsif ((getInstr(encodedInstr) = INSTR_BLTU) and (ALUResult = x"00000001")) then return (PCReg + getImmediate(encodedInstr));
        elsif ((getInstr(encodedInstr) = INSTR_BGEU) and (ALUResult = x"00000000")) then return (PCReg + getImmediate(encodedInstr));
        else return (PCReg + x"00000004");
        end if;
    end getBranchResult;

    function getFunct3(encodedInstr: unsigned) return unsigned is
    begin
        return (shift_right(encodedInstr, 12) and x"00000007");
    end getFunct3;

    function getFunct7(encodedInstr: unsigned) return unsigned is
    begin
        return (shift_right(encodedInstr, 25) and x"0000007f");
    end getFunct7;

    function getImmediate(encodedInstr: unsigned) return unsigned is
    begin
        if ((((encodedInstr and x"0000007f") = x"00000013") or ((encodedInstr and x"0000007f") = x"00000003")) or ((encodedInstr and x"0000007f") = x"00000067")) and (getInstr(encodedInstr) = INSTR_SRAI) then return (shift_right(encodedInstr, 20) and x"0000001f");
        elsif ((((encodedInstr and x"0000007f") = x"00000013") or ((encodedInstr and x"0000007f") = x"00000003")) or ((encodedInstr and x"0000007f") = x"00000067")) and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return shift_right(encodedInstr, 20);
        elsif ((((encodedInstr and x"0000007f") = x"00000013") or ((encodedInstr and x"0000007f") = x"00000003")) or ((encodedInstr and x"0000007f") = x"00000067")) then return (x"fffff000" or shift_right(encodedInstr, 20));
        elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f"));
        elsif ((encodedInstr and x"0000007f") = x"00000023") then return (x"fffff000" or ((shift_right(encodedInstr, 20) and x"00000fe0") or (shift_right(encodedInstr, 7) and x"0000001f")));
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e"));
        elsif ((encodedInstr and x"0000007f") = x"00000063") then return (x"fffff000" or (((shift_left(encodedInstr, 4) and x"00000800") or (shift_right(encodedInstr, 20) and x"000007e0")) or (shift_right(encodedInstr, 7) and x"0000001e")));
        elsif (((encodedInstr and x"0000007f") = x"00000037") or ((encodedInstr and x"0000007f") = x"00000017")) then return (encodedInstr and x"fffff000");
        elsif ((encodedInstr and x"0000007f") = x"0000006f") and ((shift_right(encodedInstr, 31) and x"00000001") = x"00000000") then return (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe"));
        elsif ((encodedInstr and x"0000007f") = x"0000006f") then return (x"fff00000" or (((encodedInstr and x"000ff000") or (shift_right(encodedInstr, 9) and x"00000800")) or (shift_right(encodedInstr, 20) and x"000007fe")));
        else return x"00000000";
        end if;
    end getImmediate;

    function getInstr(encodedInstr: unsigned) return Instr_t is
    begin
        if ((encodedInstr and x"0000007f") = x"00000037") then return INSTR_LUI;
        elsif ((encodedInstr and x"0000007f") = x"00000017") then return INSTR_AUIPC;
        elsif ((encodedInstr and x"0000007f") = x"0000006f") then return INSTR_JAL;
        elsif ((encodedInstr and x"0000007f") = x"00000067") then return INSTR_JALR;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_BEQ;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_BNE;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_BLT;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_BGE;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_BLTU;
        elsif ((encodedInstr and x"0000007f") = x"00000063") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_BGEU;
        elsif ((encodedInstr and x"0000007f") = x"00000063") then return INSTR_UNKNOWN;
        elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_LB;
        elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_LH;
        elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_LW;
        elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000004") then return INSTR_LBU;
        elsif ((encodedInstr and x"0000007f") = x"00000003") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_LHU;
        elsif ((encodedInstr and x"0000007f") = x"00000003") then return INSTR_UNKNOWN;
        elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") then return INSTR_SB;
        elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_SH;
        elsif ((encodedInstr and x"0000007f") = x"00000023") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_SW;
        elsif ((encodedInstr and x"0000007f") = x"00000023") then return INSTR_UNKNOWN;
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
        elsif ((encodedInstr and x"0000007f") = x"00000033") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000") then return INSTR_ADD;
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
        elsif ((encodedInstr and x"0000007f") = x"0000000f") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((encodedInstr and x"f00f8f80") = x"00000000")) then return INSTR_FENCE;
        elsif ((encodedInstr and x"0000007f") = x"0000000f") and (((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") and ((encodedInstr and x"ffff8f80") = x"00000000")) then return INSTR_FENCEI;
        elsif ((encodedInstr and x"0000007f") = x"0000000f") then return INSTR_UNKNOWN;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_ECALL;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000001")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_EBREAK;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000001") then return INSTR_CSRRW;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000002") then return INSTR_CSRRS;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000003") then return INSTR_CSRRC;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000005") then return INSTR_CSRRWI;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000006") then return INSTR_CSRRSI;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((shift_right(encodedInstr, 12) and x"00000007") = x"00000007") then return INSTR_CSRRCI;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000000")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000002")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_URET;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000008")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000002")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_SRET;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000018")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000002")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_MRET;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000008")) and ((shift_right(encodedInstr, 20) and x"0000001f") = x"00000005")) and ((shift_right(encodedInstr, 15) and x"0000001f") = x"00000000")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_WFI;
        elsif ((encodedInstr and x"0000007f") = x"00000073") and ((((shift_right(encodedInstr, 12) and x"00000007") = x"00000000") and ((shift_right(encodedInstr, 25) and x"0000007f") = x"00000009")) and ((shift_right(encodedInstr, 7) and x"0000001f") = x"00000000")) then return INSTR_SFENCEVMA;
        elsif ((encodedInstr and x"0000007f") = x"00000073") then return INSTR_UNKNOWN;
        else return INSTR_UNKNOWN;
        end if;
    end getInstr;

    function getMemoryMask(instr: Instr_t) return ME_MaskType is
    begin
        if ((instr = INSTR_LW) or (instr = INSTR_SW)) then return MT_W;
        elsif ((instr = INSTR_LH) or (instr = INSTR_SH)) then return MT_H;
        elsif ((instr = INSTR_LB) or (instr = INSTR_SB)) then return MT_B;
        elsif (instr = INSTR_LHU) then return MT_HU;
        elsif (instr = INSTR_LBU) then return MT_BU;
        else return MT_X;
        end if;
    end getMemoryMask;

    function getOpcode(encodedInstr: unsigned) return unsigned is
    begin
        return (encodedInstr and x"0000007f");
    end getOpcode;

    function getRDAddr(encodedInstr: unsigned) return unsigned is
    begin
        return (shift_right(encodedInstr, 7) and x"0000001f");
    end getRDAddr;

    function getRS1Addr(encodedInstr: unsigned) return unsigned is
    begin
        return (shift_right(encodedInstr, 15) and x"0000001f");
    end getRS1Addr;

    function getRS2Addr(encodedInstr: unsigned) return unsigned is
    begin
        return (shift_right(encodedInstr, 20) and x"0000001f");
    end getRS2Addr;
    
end package body core_functions;