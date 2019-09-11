--
-- CREATED BY: SALAHEDDIN HETALANI (salaheddinhetalani@gmail.com) ON 23 OCT, 2018
--

library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

package SCAM_Model_types is

    constant MEM_SIZE : integer := 65536;

    subtype bool is Boolean;
    subtype int  is Integer;

    type ram_type is array (0 to (MEM_SIZE-1)) of Unsigned (7 downto 0);

    type CU_SECTIONS  is (writeMem, readMem);
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
    type ME_AccessType       is (ME_RD, ME_WR, ME_X);
    type ME_MaskType         is (MT_B, MT_H, MT_W, MT_BU, MT_HU, MT_X);
    type PC_SelType          is (PC_4, PC_JR, PC_BR, PC_J, PC_EXC);
    type RF_RD_AccessType    is (RF_RD, RF_RD_X);
    type RF_WR_AccessType    is (RF_WR, RF_WR_X);
    type RF_WriteDataSelType is (WB_ALU, WB_MEM, WB_PC4, WB_X);
    type ALUfuncType         is (ALU_ADD, ALU_SUB, ALU_SLL, ALU_SRL, ALU_SRA, ALU_AND, ALU_OR, ALU_XOR, ALU_SLT, ALU_SLTU, ALU_COPY1, ALU_X);
    type AL_OperandSelType   is (OP_REG, OP_IMM, OP_PC, OP_X);

    type CUtoME_IF is record
        req    : ME_AccessType;
        mask   : ME_MaskType;
        addrIn : Unsigned (31 downto 0);
        dataIn : Unsigned (31 downto 0);
    end record;

    type MEtoCU_IF is record
        loadedData : Unsigned (31 downto 0);
    end record;

    type CUtoDE_IF is record
        encodedInstr : Unsigned (31 downto 0);
    end record;

    type DEtoCU_IF is record
        pcSel_s2               : PC_SelType;
        imm_s2                 : Unsigned (31 downto 0);
        encType_s2             : EncType;
        instrType_s2           : InstrType;
        regFileReq_s2          : RF_RD_AccessType;
        regRs1Addr_s2          : Unsigned ( 4 downto 0);
        regRs2Addr_s2          : Unsigned ( 4 downto 0);
        regRdAddr_s2           : Unsigned ( 4 downto 0);
        aluFunc_s3             : ALUfuncType;
        aluOp1Sel_s3           : AL_OperandSelType;
        aluOp2Sel_s3           : AL_OperandSelType;
        imm_s3                 : Unsigned (31 downto 0);
        dmemReq_s4             : ME_AccessType;
        dmemMask_s4            : ME_MaskType;
        regFileReq_s5          : RF_WR_AccessType;
        regFileWriteDataSel_s5 : RF_WriteDataSelType;
    end record;

    type CUtoDP_IF is record
        stallDmemAccess        : bool;
        prevDmemAccess         : bool;
        loadedData             : Unsigned (31 downto 0);
        pc_s2                  : Unsigned (31 downto 0);
        encType_s2             : EncType;
        regFileReq_s2          : RF_RD_AccessType;
        regRs1Addr_s2          : Unsigned ( 4 downto 0);
        regRs2Addr_s2          : Unsigned ( 4 downto 0);
        regRdAddr_s2           : Unsigned ( 4 downto 0);
        aluFunc_s3             : ALUfuncType;
        aluOp1Sel_s3           : AL_OperandSelType;
        aluOp2Sel_s3           : AL_OperandSelType;
        imm_s3                 : Unsigned (31 downto 0);
        dmemReq_s4             : ME_AccessType;
        dmemMask_s4            : ME_MaskType;
        regFileReq_s5          : RF_WR_AccessType;
        regFileWriteDataSel_s5 : RF_WriteDataSelType;
    end record;

    type DPtoCU_IF is record
        reg1Content : Unsigned (31 downto 0);
        reg2Content : Unsigned (31 downto 0);
        req         : ME_AccessType;
        mask        : ME_MaskType;
        addrIn      : Unsigned (31 downto 0);
        dataIn      : Unsigned (31 downto 0);
    end record;

    type DPtoRF_IF is record
        rdReq   : RF_RD_AccessType;
        src1    : Unsigned ( 4 downto 0);
        src2    : Unsigned ( 4 downto 0);
        wrReq   : RF_WR_AccessType;
        dst     : Unsigned ( 4 downto 0);
        dstData : Unsigned (31 downto 0);
    end record;

    type RFtoDP_IF is record
        reg1Content : Unsigned (31 downto 0);
        reg2Content : Unsigned (31 downto 0);
    end record;

    type DPtoAL_IF is record
        aluFunc : ALUfuncType;
        aluOp1  : Unsigned (31 downto 0);
        aluOp2  : Unsigned (31 downto 0);
    end record;

    type ALtoDP_IF is record
        aluResult : Unsigned (31 downto 0);
    end record;

    type CUtoDP_S3 is record
        aluFunc_s3   : ALUfuncType;
        aluOp1Sel_s3 : AL_OperandSelType;
        aluOp2Sel_s3 : AL_OperandSelType;
        imm_s3       : Unsigned (31 downto 0);
    end record;

    type CUtoDP_S4 is record
        dmemReq_s4  : ME_AccessType;
        dmemMask_s4 : ME_MaskType;
    end record;

    type CUtoDP_S5 is record
        regFileReq_s5          : RF_WR_AccessType;
        regFileWriteDataSel_s5 : RF_WriteDataSelType;
    end record;

    type DP_S3 is record
        pc_s3          : Unsigned (31 downto 0);
        encType_s3     : EncType;
        regRs1Addr_s3  : Unsigned ( 4 downto 0);
        regRs2Addr_s3  : Unsigned ( 4 downto 0);
        regRdAddr_s3   : Unsigned ( 4 downto 0);
        reg1Content_s3 : Unsigned (31 downto 0);
        reg2Content_s3 : Unsigned (31 downto 0);
    end record;

    type DP_S4 is record
        fwdPrevLoadedData : bool;
        prevLoadedData    : Unsigned (31 downto 0);
        pc_s4             : Unsigned (31 downto 0);
        encType_s4        : EncType;
        regRs2Addr_s4     : Unsigned ( 4 downto 0);
        regRdAddr_s4      : Unsigned ( 4 downto 0);
        reg2Content_s4    : Unsigned (31 downto 0);
        aluResult_s4      : Unsigned (31 downto 0);
    end record;

    type DP_S5 is record
        pc_s5        : Unsigned (31 downto 0);
        encType_s5   : EncType;
        regRdAddr_s5 : Unsigned ( 4 downto 0);
        aluResult_s5 : Unsigned (31 downto 0);
    end record;

end package SCAM_Model_types;
