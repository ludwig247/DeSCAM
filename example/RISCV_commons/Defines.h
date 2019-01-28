#ifndef PROJECT_DEFINES_H
#define PROJECT_DEFINES_H

#define MEM_START_ADDR 0x0
#define MEM_DEPTH MEM_START_ADDR + 0x10000

#define RD_MSB  11
#define RD_LSB  7
#define RS1_MSB 19
#define RS1_LSB 15
#define RS2_MSB 24
#define RS2_LSB 20

#define Fill(amt) ((1 << amt) - 1)
#define Cat(a, sz1, b, sz2) (((Fill(sz1) << sz2) & (a << sz2)) | (Fill(sz2) & b))
#define Sub(a, i1, i2) ((a >> i2) & Fill(i1 - i2 + 1))

#define Set(a,i) (a ^ ((-1 ^ a) & (1UL << i)) )
#define Clr(a,i) (a ^ ((-0 ^ a) & (1UL << i)) )


enum class InstrType {
    INSTR_UNKNOWN,
    INSTR_ADD, INSTR_SUB, INSTR_SLL, INSTR_SLT, INSTR_SLTU, INSTR_XOR, INSTR_SRL, INSTR_SRA, INSTR_OR, INSTR_AND,   // R format
    INSTR_ADDI, INSTR_SLLI, INSTR_SLTI, INSTR_SLTUI, INSTR_XORI, INSTR_SRLI, INSTR_SRAI, INSTR_ORI, INSTR_ANDI,     // I format (I_I)
    INSTR_LB, INSTR_LH, INSTR_LW, INSTR_LBU, INSTR_LHU,                                                             // I format (I_L)
    INSTR_JALR,                                                                                                     // I format (I_J)
    INSTR_SB, INSTR_SH, INSTR_SW,                                                                                   // S format
    INSTR_BEQ, INSTR_BNE, INSTR_BLT, INSTR_BGE, INSTR_BLTU, INSTR_BGEU,                                             // B format
    INSTR_LUI, INSTR_AUIPC,                                                                                         // U format
    INSTR_JAL                                                                                                       // J format
};


enum class InstrTypeOld {
    Unknown,  addI,  andI,  orI,
    xorI, sltI, sltIu, sllI, srlI, sraI, add, sub, sll_Instr, slt, sltu, Xor_Instr,
    srl_Instr, sra_Instr, Or_Instr, And_Instr, beq, bne,
    blt, bge, bltu, bgeu, lb, lh, lw, lbu, lhu, lui, auipc, jal, jalr, sb, sh, sw};
#endif // PROJECT_DEFINES_H