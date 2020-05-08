#ifndef PROJECT_CPU_INTERFACES_H
#define PROJECT_CPU_INTERFACES_H


enum class InstrType {
    Unknown,
    addI,
    andI,
    orI,
    xorI,
    sltI,
    sltIu,
    sllI,
    srlI,
    sraI,
    add,
    sub,
    sll_Instr,
    slt,
    sltu,
    Xor_Instr,
    srl_Instr,
    sra_Instr,
    Or_Instr,
    And_Instr,
    beq,
    bne,
    blt,
    bge,
    bltu,
    bgeu,
    lb,
    lh,
    lw,
    lbu,
    lhu,
    lui,
    auipc,
    jal,
    jalr,
    sb,
    sh,
    sw
};

enum EncType {
    R, I, S, B, U, J, Error_Type
};

// cpath sections

enum AccessType_Mem {
    MEM_WRITE,
    MEM_READ
};

enum MemMaskType {
    MT_B,
    MT_H,
    MT_W,
    MT_BU,
    MT_HU,
    MT_X
};

struct MemoryAccess {

    unsigned int dataIn;                     //FIXME: Changed from unsigned int
    unsigned int addrIn;                     //FIXME: Changed from unsigned int

 MemMaskType mask;

    AccessType_Mem req;
};


struct DecodedInstr {

    InstrType instrType;
    EncType encType;

    unsigned int rs1_addr;
    unsigned int rs2_addr;
    unsigned int rd_addr;

    unsigned int imm;
};

enum AccessType_Reg {
    REG_RD,   // read from regfile
    REG_WR    // write to regfile
};

// register file input interface
struct CtlToRegs_IF {
    unsigned int src1;
    unsigned int src2;
    unsigned int dst;
    unsigned int dst_data;

 AccessType_Reg req;
};

// register file output interface
struct RegsToCtl_IF {
    unsigned int contents1;
    unsigned int contents2;
};

enum ALUopType {
    OP_REG,
    OP_IMM,
    OP_PC,
    OP_X
};

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
};

// Control to ALU interface
struct CtlToALU_IF {

 ALUopType op1_sel, op2_sel;

 ALU_function alu_fun;

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




