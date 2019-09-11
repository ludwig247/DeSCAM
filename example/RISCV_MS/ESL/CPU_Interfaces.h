#ifndef PROJECT_CPU_INTERFACES_H
#define PROJECT_CPU_INTERFACES_H

#include "Defines.h"

enum EncType {
    R, I, S, B, U, J, Error_Type
};



struct DecodedInstr {

    InstrTypeOld instrType;
    EncType encType;

    unsigned int rs1_addr;
    unsigned int rs2_addr;
    unsigned int rd_addr;

    unsigned int imm;
};


// register file input interface
struct CtlToRegs_IF {
    unsigned int src1;
    unsigned int src2;
    unsigned int dst;
    unsigned int dst_data;

    enum AccessType_Reg {
        REG_RD,   // read from regfile
        REG_WR    // write to regfile
    } req;
};

// register file output interface
struct RegsToCtl_IF {
    unsigned int contents1;
    unsigned int contents2;
};


// Control to ALU interface
struct CtlToALU_IF {

    enum ALUopType {
        OP_REG,
        OP_IMM,
        OP_PC,
        OP_X
    } op1_sel, op2_sel;

    enum ALU_function {
        ALU_ADD,
        ALU_SUB,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLT,
        ALU_SLTU,
        ALU_COPY1,
        ALU_X,
    } alu_fun;

    unsigned int reg1_contents;
    unsigned int reg2_contents;
    unsigned int imm;
    unsigned int pc_reg;
};

// ALU to control interface
struct ALUtoCtl_IF {
    unsigned int ALU_result;
};

enum class WBselType {
    WB_ALU,
    WB_MEM,
    WB_PC4,
    WB_X
};

enum class PCselType {
    PC_4,
    PC_BR,
    PC_J,
    PC_JR,
    PC_EXC,
};


#endif // PROJECT_CPU_INTERFACES_H




