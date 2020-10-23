//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 31 Mar, 2018
//

#ifndef PROJECT_CPU_INTERFACES_H
#define PROJECT_CPU_INTERFACES_H

#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Defines.h"


enum EncType {
    ENC_R, ENC_I_I, ENC_I_L, ENC_I_J, ENC_S, ENC_B, ENC_U, ENC_J, ENC_ERR
};

enum PC_SelType {
    PC_4, PC_JR, PC_BR, PC_J //, PC_EXC
};

enum RF_RD_AccessType{
    RF_RD_X, RF_RD
};

enum RF_WR_AccessType{
    RF_WR_X, RF_WR
};

enum RF_WriteDataSelType {
    WB_X, WB_ALU, WB_MEM, WB_PC4
};

enum ALUfuncType {
    ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_XOR, ALU_SRL, ALU_SRA, ALU_OR, ALU_AND, ALU_COPY1
};

enum AL_OperandSelType {
    OP_X, OP_REG, OP_IMM, OP_PC
};


struct DEtoCU_IF {
    PC_SelType pcSel_s2;
    unsigned int imm_s2;
    EncType encType_s2;
    InstrType instrType_s2;
    RF_RD_AccessType regFileReq_s2;
    unsigned int regRs1Addr_s2;
    unsigned int regRs2Addr_s2;
    unsigned int regRdAddr_s2;

    ALUfuncType aluFunc_s3;
    AL_OperandSelType aluOp1Sel_s3;
    AL_OperandSelType aluOp2Sel_s3;
    unsigned int imm_s3;

    ME_AccessType dmemReq_s4;
    ME_MaskType dmemMask_s4;

    RF_WR_AccessType regFileReq_s5;
    RF_WriteDataSelType regFileWriteDataSel_s5;
};

struct CUtoDP_IF {
    bool stallDmemAccess;
    bool prevDmemAccess;
    unsigned int loadedData;

    unsigned int pc_s2;
    EncType encType_s2;
    RF_RD_AccessType regFileReq_s2;
    unsigned int regRs1Addr_s2;
    unsigned int regRs2Addr_s2;
    unsigned int regRdAddr_s2;

    ALUfuncType aluFunc_s3;
    AL_OperandSelType aluOp1Sel_s3;
    AL_OperandSelType aluOp2Sel_s3;
    unsigned int imm_s3;

    ME_AccessType dmemReq_s4;
    ME_MaskType dmemMask_s4;

    RF_WR_AccessType regFileReq_s5;
    RF_WriteDataSelType regFileWriteDataSel_s5;

#ifdef LOGTOFILE
    InstrType instrType_s2;
#endif

};

struct DPtoCU_IF {
    unsigned int reg1Content;
    unsigned int reg2Content;
    ME_AccessType req;
    ME_MaskType mask;
    unsigned int addrIn;
    unsigned int dataIn;
};

struct DPtoRF_IF {
    RF_WR_AccessType wrReq;
    unsigned int dst;
    unsigned int dstData;
};

struct RFtoDP_IF {
    unsigned int reg_file_01;
    unsigned int reg_file_02;
    unsigned int reg_file_03;
    unsigned int reg_file_04;
    unsigned int reg_file_05;
    unsigned int reg_file_06;
    unsigned int reg_file_07;
    unsigned int reg_file_08;
    unsigned int reg_file_09;
    unsigned int reg_file_10;
    unsigned int reg_file_11;
    unsigned int reg_file_12;
    unsigned int reg_file_13;
    unsigned int reg_file_14;
    unsigned int reg_file_15;
    unsigned int reg_file_16;
    unsigned int reg_file_17;
    unsigned int reg_file_18;
    unsigned int reg_file_19;
    unsigned int reg_file_20;
    unsigned int reg_file_21;
    unsigned int reg_file_22;
    unsigned int reg_file_23;
    unsigned int reg_file_24;
    unsigned int reg_file_25;
    unsigned int reg_file_26;
    unsigned int reg_file_27;
    unsigned int reg_file_28;
    unsigned int reg_file_29;
    unsigned int reg_file_30;
    unsigned int reg_file_31;
};

struct DPtoAL_IF {
    ALUfuncType aluFunc;
    unsigned int aluOp1;
    unsigned int aluOp2;
};

struct CUtoDP_S3 {
    ALUfuncType aluFunc_s3;
    AL_OperandSelType aluOp1Sel_s3;
    AL_OperandSelType aluOp2Sel_s3;
    unsigned int imm_s3;
};

struct CUtoDP_S4 {
    ME_AccessType dmemReq_s4;
    ME_MaskType dmemMask_s4;
};

struct CUtoDP_S5 {
    RF_WR_AccessType regFileReq_s5;
    RF_WriteDataSelType regFileWriteDataSel_s5;
};

struct DP_S3 {
    unsigned int pc_s3;
    EncType encType_s3;
    unsigned int regRs1Addr_s3;
    unsigned int regRs2Addr_s3;
    unsigned int regRdAddr_s3;
    unsigned int reg1Content_s3;
    unsigned int reg2Content_s3;

#ifdef LOGTOFILE
    InstrType instrType_s3;
#endif

};

struct DP_S4 {
    bool fwdPrevLoadedData;
    unsigned int prevLoadedData;

    unsigned int pc_s4;
    EncType encType_s4;
    unsigned int regRs2Addr_s4;
    unsigned int regRdAddr_s4;
    unsigned int reg2Content_s4;
    unsigned int aluResult_s4;

#ifdef LOGTOFILE
    InstrType instrType_s4;
#endif

};

struct DP_S5 {
    unsigned int pc_s5;
    EncType encType_s5;
    unsigned int regRdAddr_s5;
    unsigned int aluResult_s5;

#ifdef LOGTOFILE
    InstrType instrType_s5;
#endif

};


#endif // PROJECT_CPU_INTERFACES_H