#ifndef GOLDEN_CPU_INTERFACES_H
#define GOLDEN_CPU_INTERFACES_H


enum G_InstrType {
    G_INSTR_UNKNOWN,
    G_INSTR_ADD, G_INSTR_SUB, G_INSTR_SLL, G_INSTR_SLT, G_INSTR_SLTU, G_INSTR_XOR, G_INSTR_SRL, G_INSTR_SRA, G_INSTR_OR, G_INSTR_AND,   // R format
    G_INSTR_ADDI, G_INSTR_SLLI, G_INSTR_SLTI, G_INSTR_SLTUI, G_INSTR_XORI, G_INSTR_SRLI, G_INSTR_SRAI, G_INSTR_ORI, G_INSTR_ANDI,       // I format (I_I)
    G_INSTR_LB, G_INSTR_LH, G_INSTR_LW, G_INSTR_LBU, G_INSTR_LHU,                                                                       // I format (I_L)
    G_INSTR_JALR,                                                                                                                       // I format (I_J)
    G_INSTR_FENCE, G_INSTR_FENCEI,                                                                                                      // I format (I_M)
    G_INSTR_PRIV, G_INSTR_CSRRW, G_INSTR_CSRRS, G_INSTR_CSRRC, G_INSTR_CSRRWI, G_INSTR_CSRRSI, G_INSTR_CSRRCI,                          // I format (I_S)
    G_INSTR_SB, G_INSTR_SH, G_INSTR_SW,                                                                                                 // S format
    G_INSTR_BEQ, G_INSTR_BNE, G_INSTR_BLT, G_INSTR_BGE, G_INSTR_BLTU, G_INSTR_BGEU,                                                     // B format
    G_INSTR_LUI, G_INSTR_AUIPC,                                                                                                         // U format
    G_INSTR_JAL                                                                                                                         // J format
};

enum G_PrivInstrType {
    G_INSTR_PRIV_UNKNOWN,
    G_INSTR_ECALL, G_INSTR_EBREAK, G_INSTR_MRET//, G_INSTR_WFI, G_INSTR_SFENCEVMA //, URET, SRET
};

enum G_EncType {
    G_ENC_R, G_ENC_I_I, G_ENC_I_L, G_ENC_I_J, G_ENC_I_M, G_ENC_I_S, G_ENC_S, G_ENC_B, G_ENC_U, G_ENC_J, G_ENC_ERR
};

enum G_ALUfuncType {
    G_ALU_X, G_ALU_ADD, G_ALU_SUB, G_ALU_SLL, G_ALU_SRL, G_ALU_SRA, G_ALU_AND, G_ALU_OR, G_ALU_XOR, G_ALU_SLT, G_ALU_SLTU, G_ALU_COPY1
};


// register file input interface
struct G_RegfileWriteType {
    unsigned int G_dst;
    unsigned int G_dstData;
};

// register file output interface
struct G_RegfileType {
    unsigned int G_reg_file_01;
    unsigned int G_reg_file_02;
    unsigned int G_reg_file_03;
    unsigned int G_reg_file_04;
    unsigned int G_reg_file_05;
    unsigned int G_reg_file_06;
    unsigned int G_reg_file_07;
    unsigned int G_reg_file_08;
    unsigned int G_reg_file_09;
    unsigned int G_reg_file_10;
    unsigned int G_reg_file_11;
    unsigned int G_reg_file_12;
    unsigned int G_reg_file_13;
    unsigned int G_reg_file_14;
    unsigned int G_reg_file_15;
    unsigned int G_reg_file_16;
    unsigned int G_reg_file_17;
    unsigned int G_reg_file_18;
    unsigned int G_reg_file_19;
    unsigned int G_reg_file_20;
    unsigned int G_reg_file_21;
    unsigned int G_reg_file_22;
    unsigned int G_reg_file_23;
    unsigned int G_reg_file_24;
    unsigned int G_reg_file_25;
    unsigned int G_reg_file_26;
    unsigned int G_reg_file_27;
    unsigned int G_reg_file_28;
    unsigned int G_reg_file_29;
    unsigned int G_reg_file_30;
    unsigned int G_reg_file_31;
};

// register file output interface
struct G_RegfileSyscallType {
    unsigned int G_reg_file_10;
    unsigned int G_reg_file_11;
    unsigned int G_reg_file_12;
    unsigned int G_reg_file_17;
};

struct G_CSRfileType {
    unsigned int G_mstatus;
//    unsigned int G_misa;
    unsigned int G_mie;
    unsigned int G_mtvec;
//    unsigned int G_mscratch;
    unsigned int G_mepc;
    unsigned int G_mcause;
//    unsigned int G_mtval;
    unsigned int G_mip;
//    unsigned int G_mvendorid;
//    unsigned int G_marchid;
//    unsigned int G_mimpid;
//    unsigned int G_mhartid;
};



struct G_DecodedInstr {
    G_EncType G_encType;
    G_InstrType G_instrType;
    G_PrivInstrType G_privInstrType;
    unsigned int G_rd_addr;
    unsigned int G_rs1_addr;
    unsigned int G_rs2_addr;
    unsigned int G_imm;

};

#endif // GOLDEN_CPU_INTERFACES_H