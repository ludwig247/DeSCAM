//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 29 Jan, 2019
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

enum RF_WriteDataSelType {
    WB_X, WB_ALU, WB_MEM, WB_PC4
};

enum ALUfuncType {
    ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SLT, ALU_SLTU, ALU_XOR, ALU_SRL, ALU_SRA, ALU_OR, ALU_AND, ALU_COPY1
};

enum AL_OperandSelType {
    OP_X, OP_REG, OP_IMM, OP_PC
};


struct CUtoRF_IF {
    unsigned int dst;
    unsigned int dstData;
};

struct RFtoCU_IF {
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

struct DEtoCU_IF {
    PC_SelType pcSel_s1;
    unsigned int imm_s1;
    EncType encType_s1;
    InstrType instrType_s1;
    bool regfileRead_s1;
    unsigned int regRs1Addr_s1;
    unsigned int regRs2Addr_s1;
    unsigned int regRdAddr_s1;

    ALUfuncType aluFunc_s2;
    AL_OperandSelType aluOp1Sel_s2;
    AL_OperandSelType aluOp2Sel_s2;

    bool regfileWrite_s3;
    RF_WriteDataSelType writeDataSel_s3;

    ME_MaskType dmemMask;
};

struct CUtoAL_IF {
    ALUfuncType aluFunc;
    unsigned int aluOp1;
    unsigned int aluOp2;
};

struct ControlSignals_s2 {
    ALUfuncType aluFunc;
    AL_OperandSelType aluOp1Sel;
    AL_OperandSelType aluOp2Sel;
};

struct ControlSignals_s3 {
    bool regfileWrite;
    RF_WriteDataSelType writeDataSel;
};

struct DataSignals_s2 {

#ifdef LOGTOFILE
    InstrType instrType;
#endif

    EncType encType;
    unsigned int regRdAddr;
    unsigned int reg1content;
    unsigned int reg2content;
    unsigned int imm;
    unsigned int pc;
};

struct DataSignals_s3 {

#ifdef LOGTOFILE
    InstrType instrType;
#endif

    EncType encType;
    unsigned int regRdAddr;
    unsigned int aluResult;
    unsigned int pc;
};


#endif // PROJECT_CPU_INTERFACES_H
