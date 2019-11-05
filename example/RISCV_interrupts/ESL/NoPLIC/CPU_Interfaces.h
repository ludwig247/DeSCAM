#ifndef PROJECT_CPU_INTERFACES_H
#define PROJECT_CPU_INTERFACES_H


//enum InstrType {
//    INSTR_UNKNOWN,
//    INSTR_ADD, INSTR_SUB, INSTR_SLL, INSTR_SLT, INSTR_SLTU, INSTR_XOR, INSTR_SRL, INSTR_SRA, INSTR_OR, INSTR_AND,   // R format
//    INSTR_ADDI, INSTR_SLLI, INSTR_SLTI, INSTR_SLTUI, INSTR_XORI, INSTR_SRLI, INSTR_SRAI, INSTR_ORI, INSTR_ANDI,     // I format (I_I)
//    INSTR_LB, INSTR_LH, INSTR_LW, INSTR_LBU, INSTR_LHU,                                                             // I format (I_L)
//    INSTR_JALR,                                                                                                     // I format (I_J)
//    INSTR_FENCE, INSTR_FENCEI,                                                                                      // I format (I_M)
//    INSTR_PRIV, INSTR_CSRRW, INSTR_CSRRS, INSTR_CSRRC, INSTR_CSRRWI, INSTR_CSRRSI, INSTR_CSRRCI,                    // I format (I_S)
//    INSTR_SB, INSTR_SH, INSTR_SW,                                                                                   // S format
//    INSTR_BEQ, INSTR_BNE, INSTR_BLT, INSTR_BGE, INSTR_BLTU, INSTR_BGEU,                                             // B format
//    INSTR_LUI, INSTR_AUIPC,                                                                                         // U format
//    INSTR_JAL                                                                                                       // J format
//};

enum PrivInstrType {
    INSTR_PRIV_UNKNOWN,
    INSTR_ECALL, INSTR_EBREAK, INSTR_MRET//, INSTR_WFI, INSTR_SFENCEVMA //, URET, SRET
};

enum EncType {
    ENC_R, ENC_I_I, ENC_I_L, ENC_I_J, ENC_I_M, ENC_I_S, ENC_S, ENC_B, ENC_U, ENC_J, ENC_ERR
};

enum ALUfuncType {
    ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SRL, ALU_SRA, ALU_AND, ALU_OR, ALU_XOR, ALU_SLT, ALU_SLTU, ALU_COPY1
};


// register file input interface
struct RegfileWriteType {
    unsigned int dst;
    unsigned int dstData;
};

// register file output interface
struct RegfileType {
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

// register file output interface
struct RegfileSyscallType {
    unsigned int reg_file_10;
    unsigned int reg_file_11;
    unsigned int reg_file_12;
    unsigned int reg_file_17;
};

struct CSRfileType {
    unsigned int mstatus;
//    unsigned int misa;
    unsigned int mie;
    unsigned int mtvec;
//    unsigned int mscratch;
    unsigned int mepc;
    unsigned int mcause;
//    unsigned int mtval;
    unsigned int mip;
//    unsigned int mvendorid;
//    unsigned int marchid;
//    unsigned int mimpid;
//    unsigned int mhartid;
};

#endif // PROJECT_CPU_INTERFACES_H