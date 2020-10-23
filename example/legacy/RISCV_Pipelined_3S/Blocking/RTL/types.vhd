--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 21 Jan, 2019
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

    constant MEM_SIZE : Integer := 65536;

    subtype bool is Boolean;
    subtype int  is Integer;

    type ram_type is array (0 to (MEM_SIZE-1)) of Unsigned (7 downto 0);

    type CU_SECTIONS  is (writeMem, readMem, writeDmem, readDmem);
    type MEM_SECTIONS is (read, write);

    type InstrType           is (INSTR_ADD, INSTR_SUB, INSTR_SLL, INSTR_SLT, INSTR_SLTU, INSTR_XOR, INSTR_SRL, INSTR_SRA, INSTR_OR, INSTR_AND,
                                 INSTR_ADDI, INSTR_SLLI, INSTR_SLTI, INSTR_SLTUI, INSTR_XORI, INSTR_SRLI, INSTR_SRAI, INSTR_ORI, INSTR_ANDI,
                                 INSTR_LB, INSTR_LH, INSTR_LW, INSTR_LBU, INSTR_LHU,
                                 INSTR_JALR,
                                 INSTR_SB, INSTR_SH, INSTR_SW,
                                 INSTR_BEQ, INSTR_BNE, INSTR_BLT, INSTR_BGE, INSTR_BLTU, INSTR_BGEU,
                                 INSTR_LUI, INSTR_AUIPC,
                                 INSTR_JAL,
                                 INSTR_UNKNOWN);
    type EncType             is (ENC_R, ENC_I_I, ENC_I_L, ENC_I_J, ENC_S, ENC_B, ENC_U, ENC_J, ENC_ERR);
    type ME_AccessType       is (ME_X, ME_RD, ME_WR);
    type ME_MaskType         is (MT_X, MT_B, MT_H, MT_W, MT_BU, MT_HU);
    type PC_SelType          is (PC_4, PC_JR, PC_BR, PC_J, PC_EXC);
    type RF_WriteDataSelType is (WB_X, WB_ALU, WB_MEM, WB_PC4);
    type ALUfuncType         is (ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SRL, ALU_SRA, ALU_AND, ALU_OR, ALU_XOR, ALU_SLT, ALU_SLTU, ALU_COPY1);
    type AL_OperandSelType   is (OP_X, OP_REG, OP_IMM, OP_PC);

    type COtoME_IF is record
        req    : ME_AccessType;
        mask   : ME_MaskType;
        addrIn : Unsigned (31 downto 0);
        dataIn : Unsigned (31 downto 0);
    end record;

    type MEtoCO_IF is record
        loadedData : Unsigned (31 downto 0);
    end record;

    type CUtoDE_IF is record
        encodedInstr : Unsigned (31 downto 0);
    end record;

    type DEtoCU_IF is record
        pcSel_s1        : PC_SelType;
        imm_s1          : Unsigned (31 downto 0);
        encType_s1      : EncType;
        instrType_s1    : InstrType;
        regRs1Addr_s1   : Unsigned ( 4 downto 0);
        regRs2Addr_s1   : Unsigned ( 4 downto 0);
        regRdAddr_s1    : Unsigned ( 4 downto 0);
        aluFunc_s2      : ALUfuncType;
        aluOp1Sel_s2    : AL_OperandSelType;
        aluOp2Sel_s2    : AL_OperandSelType;
        regfileWrite_s3 : bool;
        writeDataSel_s3 : RF_WriteDataSelType;
	dmemMask        : ME_MaskType;
    end record;

    type CUtoRF_IF is record
        src1    : Unsigned ( 4 downto 0);
        src2    : Unsigned ( 4 downto 0);
        dst     : Unsigned ( 4 downto 0);
        dstData : Unsigned (31 downto 0);
    end record;

    type RFtoCU_IF is record
        reg1Content : Unsigned (31 downto 0);
        reg2Content : Unsigned (31 downto 0);
    end record;

    type CUtoAL_IF is record
        aluFunc : ALUfuncType;
        aluOp1  : Unsigned (31 downto 0);
        aluOp2  : Unsigned (31 downto 0);
    end record;

    type ALtoCU_IF is record
        aluResult : Unsigned (31 downto 0);
    end record;

    type ControlSignals_s2 is record
        aluFunc   : ALUfuncType;
        aluOp1Sel : AL_OperandSelType;
        aluOp2Sel : AL_OperandSelType;
    end record;

    type ControlSignals_s3 is record
        regfileWrite : bool;
        writeDataSel : RF_WriteDataSelType;
    end record;

    type DataSignals_s2 is record
        encType     : EncType;
        regRdAddr   : Unsigned ( 4 downto 0);
        reg1Content : Unsigned (31 downto 0);
        reg2Content : Unsigned (31 downto 0);
	imm 	    : Unsigned (31 downto 0);
        pc          : Unsigned (31 downto 0);
    end record;

    type DataSignals_s3 is record
        encType   : EncType;
        regRdAddr : Unsigned ( 4 downto 0);
        aluResult : Unsigned (31 downto 0);
        pc        : Unsigned (31 downto 0);
    end record;

end package SCAM_Model_types;
