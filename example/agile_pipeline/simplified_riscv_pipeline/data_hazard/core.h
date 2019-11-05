//
// Created by Paulius Morkunas on 10.07.19.
//

#ifndef PROJECT_SIMPLIFIED_RISCV_ISA_H
#define PROJECT_SIMPLIFIED_RISCV_ISA_H


#include "systemc.h"
#include "../../../Interfaces/Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"

#ifdef SC_SIMULATE
#define REGFILE(x) reg_01 // Needed by SystemC core test bench
#define PCREG PCReg // Needed by SystemC core test bench
#endif

#define OPCODE_U_LUI        0x37 //0110111
#define OPCODE_U_AUIPC      0x17 //0010111
#define OPCODE_J_JAL        0x6F //1101111
#define OPCODE_I_JALR       0x67 //1100111
#define OPCODE_B            0x63 //1100011
#define OPCODE_I_L          0x03 //0000011
#define OPCODE_S            0x23 //0100011
#define OPCODE_I            0x13 //0010011
#define OPCODE_R            0x33 //0110011
#define OPCODE_MEM          0x0F //0001111
#define OPCODE_SYS          0x73 //1110011

#define OPCODE_FIELD(x)     ((x) & 0x7F)
#define FUNCT3_FIELD(x)     (((x) >> 12) & 0x07)
#define FUNCT7_FIELD(x)     (((x) >> 25) & 0x7F)
#define RS1_FIELD(x)        (((x) >> 15) & 0x1F)
#define RS2_FIELD(x)        (((x) >> 20) & 0x1F)
#define RD_FIELD(x)         (((x) >>  7) & 0x1F)
#define SIGN_FIELD(x)       (((x) >> 31) & 0x01)

#define IMM_U_FIELD(x)      ((x) & static_cast<unsigned int>(0xFFFFF000))
#define POS_IMM_I_FIELD(x)  ((x) >> 20)
#define POS_IMM_S_FIELD(x)  ((((x) >> 20) & 0xFE0) | (((x) >> 7) & 0x1F))
#define POS_IMM_B_FIELD(x)  ((((x) << 4) & 0x800) | (((x) >> 20) & 0x7E0) | (((x) >> 7) & 0x1E))
#define POS_IMM_J_FIELD(x)  (((x) & 0xFF000) | (((x) >> 9) & 0x800) | (((x) >> 20) & 0x7FE))
#define NEG_IMM_I_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_I_FIELD(x))
#define NEG_IMM_S_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_S_FIELD(x))
#define NEG_IMM_B_FIELD(x)  (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_B_FIELD(x))
#define NEG_IMM_J_FIELD(x)  (static_cast<unsigned int>(0xFFF00000) | POS_IMM_J_FIELD(x))


// Implementation related defines
#define UNDEFINED_VALUE 0
#define GET_REDUCED_ADDR(x) (x & 0x3)



enum Instr_t {
    INSTR_UNKNOWN,
    // OPCODE_U_LUI /////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_LUI,
    // OPCODE_U_AUIPC ///////////////////////////////////////////////////////////////////////////////////////////
    INSTR_AUIPC,
    // OPCODE_J_JAL /////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_JAL,
    // OPCODE_I_JALR ////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_JALR,
    // OPCODE_B /////////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_BEQ, INSTR_BNE, INSTR_BLT, INSTR_BGE, INSTR_BLTU, INSTR_BGEU,
    // OPCODE_I_L ///////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_LB, INSTR_LH, INSTR_LW, INSTR_LBU, INSTR_LHU,
    // OPCODE_S /////////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_SB, INSTR_SH, INSTR_SW,
    // OPCODE_I /////////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_ADDI, INSTR_SLLI, INSTR_SLTI, INSTR_SLTIU, INSTR_XORI, INSTR_SRLI, INSTR_SRAI, INSTR_ORI, INSTR_ANDI,
    // OPCODE_R /////////////////////////////////////////////////////////////////////////////////////////////////
    INSTR_ADD, INSTR_SUB, INSTR_SLL, INSTR_SLT, INSTR_SLTU, INSTR_XOR, INSTR_SRL, INSTR_SRA, INSTR_OR, INSTR_AND,
    // OPCODE_MEM ///////////////////////////////////////////////////////////////////////////////////////////////
    // Multicore memory mamagement
    INSTR_FENCE, INSTR_FENCEI,
    // OPCODE_SYS ///////////////////////////////////////////////////////////////////////////////////////////////
    // Environment call and breakpoint (privileged)
    INSTR_ECALL, INSTR_EBREAK,
    // Status register
    INSTR_CSRRW, INSTR_CSRRS, INSTR_CSRRC, INSTR_CSRRWI, INSTR_CSRRSI, INSTR_CSRRCI,
    // Trap-Return (privileged)
    INSTR_URET, INSTR_SRET, INSTR_MRET,
    // Interrupt-Management (privileged)
    INSTR_WFI,
    // Memory-Management (privileged)
    INSTR_SFENCEVMA
};

enum ALUFunc_t {
    ALUF_X, ALUF_ADD, ALUF_SUB, ALUF_SLL, ALUF_SRL, ALUF_SRA, ALUF_AND, ALUF_OR, ALUF_XOR, ALUF_SLT, ALUF_SLTU, ALUF_COPY1
};

class Core : public sc_module {
public:

    // Constructor
    SC_HAS_PROCESS(Core);

    // Ports (Memory Interface)
    blocking_out<CUtoME_IF> COtoME_port;
    blocking_in<MEtoCU_IF> MEtoCO_port;

    Core(sc_module_name name) :
            COtoME_port("COtoME_port"),
            MEtoCO_port("MEtoCO_port"),
            PCReg(0) {
        SC_THREAD(fsm);
    }

    CUtoME_IF COtoME_data;
    MEtoCU_IF MEtoCO_data;


    // Functions
    unsigned int getOpcode(unsigned int encodedInstr) const;

    unsigned int getFunct3(unsigned int encodedInstr) const;

    unsigned int getFunct7(unsigned int encodedInstr) const;

    unsigned int getRS1Addr(unsigned int encodedInstr) const;

    unsigned int getRS2Addr(unsigned int encodedInstr) const;

    unsigned int getRDAddr(unsigned int encodedInstr) const;

    Instr_t getInstr(unsigned int encodedInstr) const;

    unsigned int getImmediate(unsigned int encodedInstr) const;

    unsigned int getBranchResult(unsigned int encodedInstr, unsigned int ALUResult, unsigned int PCReg) const;

    ALUFunc_t getALUFunc(Instr_t instr) const;

    ME_MaskType getMemoryMask(Instr_t instr) const;

    unsigned int getALUResult(ALUFunc_t func, unsigned int op1, unsigned int op2) const;

    unsigned int PCReg;
    unsigned int encodedInstr;
    unsigned int reg_01;
    unsigned int reg_02;
    unsigned int reg_03;
    unsigned int RS1;
    unsigned int RS1Addr;
    unsigned int RS2;
    unsigned int RS2Addr;
    unsigned int RDAddr;
    unsigned int imm;
    ALUFunc_t ALUFunc;
    unsigned int ALUResult;
    unsigned int loadedData;

    void fsm() {
        while (true) {
            COtoME_data.req = ME_RD;
            COtoME_data.mask = MT_W;
            COtoME_data.dataIn = UNDEFINED_VALUE;
            COtoME_data.addrIn = PCReg;
            COtoME_port->write(COtoME_data);
            MEtoCO_port->read(MEtoCO_data);
            encodedInstr = MEtoCO_data.loadedData;
            PCReg = PCReg + 4;

            RS1Addr = GET_REDUCED_ADDR(getRS1Addr(encodedInstr));
            if (RS1Addr == 0)
                RS1 = 0;
            else if (RS1Addr == 1)
                RS1 = reg_01;
            else if (RS1Addr == 2)
                RS1 = reg_02;
            else if (RS1Addr == 3)
                RS1 = reg_03;

            RS2Addr = GET_REDUCED_ADDR(getRS2Addr(encodedInstr));
            if (RS2Addr == 0)
                RS2 = 0;
            else if (RS2Addr == 1)
                RS2 = reg_01;
            else if (RS2Addr == 2)
                RS2 = reg_02;
            else if (RS2Addr == 3)
                RS2 = reg_03;

            imm = getImmediate(encodedInstr);
            RDAddr = GET_REDUCED_ADDR(getRDAddr(encodedInstr));
            ALUFunc = getALUFunc(getInstr(encodedInstr));

            if (getOpcode(encodedInstr) == OPCODE_R) {
                ALUResult = getALUResult(ALUFunc, RS1, RS2);

                if (RDAddr == 1)
                    reg_01 = ALUResult;
                else if (RDAddr == 2)
                    reg_02 = ALUResult;
                else if (RDAddr == 3)
                    reg_03 = ALUResult;

            } else if (getOpcode(encodedInstr) == OPCODE_I_L) {
                ALUResult = getALUResult(ALUFunc, RS1, imm);

                COtoME_data.req = ME_RD;
                COtoME_data.mask = MT_W;
                COtoME_data.addrIn = ALUResult;
                COtoME_data.dataIn = UNDEFINED_VALUE;
                COtoME_port->write(COtoME_data);
                MEtoCO_port->read(MEtoCO_data);
                loadedData = MEtoCO_data.loadedData;

                if (RDAddr == 1)
                    reg_01 = loadedData;
                else if (RDAddr == 2)
                    reg_02 = loadedData;
                else if (RDAddr == 3)
                    reg_03 = loadedData;

            } else if (getOpcode(encodedInstr) == OPCODE_S) {
                ALUResult = getALUResult(ALUFunc, RS1, imm);

                COtoME_data.req = ME_WR;
                COtoME_data.mask = MT_W;
                COtoME_data.addrIn = ALUResult;
                COtoME_data.dataIn = RS2;
                COtoME_port->write(COtoME_data);
            }
        }
    }
};

unsigned int Core::getOpcode(unsigned int encodedInstr) const {
    return OPCODE_FIELD(encodedInstr);
}

unsigned int Core::getFunct3(unsigned int encodedInstr) const {
    return FUNCT3_FIELD(encodedInstr);
}

unsigned int Core::getFunct7(unsigned int encodedInstr) const {
    return FUNCT7_FIELD(encodedInstr);
}

unsigned int Core::getRS1Addr(unsigned int encodedInstr) const {
    return RS1_FIELD(encodedInstr);
}

unsigned int Core::getRS2Addr(unsigned int encodedInstr) const {
    return RS2_FIELD(encodedInstr);
}

unsigned int Core::getRDAddr(unsigned int encodedInstr) const {
    return RD_FIELD(encodedInstr);
}

unsigned int Core::getImmediate(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_JALR) {
        if (getInstr(encodedInstr) == INSTR_SRAI) {
            return POS_IMM_I_FIELD(encodedInstr) & 0x01F; // Handle special immediate case occurring in SRAI instruction
        } else {
            if (SIGN_FIELD(encodedInstr) == 0)
                return POS_IMM_I_FIELD(encodedInstr);
            else
                return NEG_IMM_I_FIELD(encodedInstr);
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_S_FIELD(encodedInstr);
        else
            return NEG_IMM_S_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_B_FIELD(encodedInstr);
        else
            return NEG_IMM_B_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U_LUI ||
               OPCODE_FIELD(encodedInstr) == OPCODE_U_AUIPC) {
        return IMM_U_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J_JAL) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_J_FIELD(encodedInstr);
        else
            return NEG_IMM_J_FIELD(encodedInstr);
    } else {
        return UNDEFINED_VALUE;
    }
}


Instr_t Core::getInstr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_U_LUI) {
        return INSTR_LUI;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U_AUIPC) {
        return INSTR_AUIPC;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J_JAL) {
        return INSTR_JAL;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_JALR) {
        return INSTR_JALR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0) {
            return INSTR_BEQ;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_BNE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x4) {
            return INSTR_BLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x5) {
            return INSTR_BGE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x6) {
            return INSTR_BLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x7) {
            return INSTR_BGEU;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0) {
            return INSTR_LB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_LH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x2) {
            return INSTR_LW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x4) {
            return INSTR_LBU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x5) {
            return INSTR_LHU;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0) {
            return INSTR_SB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_SH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x2) {
            return INSTR_SW;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0) {
            return INSTR_ADDI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_SLLI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x2) {
            return INSTR_SLTI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x3) {
            return INSTR_SLTIU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x4) {
            return INSTR_XORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x5) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRLI;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRAI;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x6) {
            return INSTR_ORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x7) {
            return INSTR_ANDI;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_ADD;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SUB;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x2) {
            return INSTR_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x3) {
            return INSTR_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x4) {
            return INSTR_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x5) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRA;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x6) {
            return INSTR_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x7) {
            return INSTR_AND;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_MEM) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0 && (encodedInstr & static_cast<unsigned int>(0xF00F8F80)) == 0x00000000) {
            return INSTR_FENCE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1 && (encodedInstr & static_cast<unsigned int>(0xFFFF8F80)) == 0x00000000) {
            return INSTR_FENCEI;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_SYS) {
        if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00 &&
            RS2_FIELD(encodedInstr) == 0x0 && RS1_FIELD(encodedInstr) == 0x0 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_ECALL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00 &&
                   RS2_FIELD(encodedInstr) == 0x1 && RS1_FIELD(encodedInstr) == 0x0 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_EBREAK;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x1) {
            return INSTR_CSRRW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x2) {
            return INSTR_CSRRS;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x3) {
            return INSTR_CSRRC;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x5) {
            return INSTR_CSRRWI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x6) {
            return INSTR_CSRRSI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x7) {
            return INSTR_CSRRCI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x00 &&
                   RS2_FIELD(encodedInstr) == 0x02 && RS1_FIELD(encodedInstr) == 0x00 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_URET;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x08 &&
                   RS2_FIELD(encodedInstr) == 0x02 && RS1_FIELD(encodedInstr) == 0x00 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_SRET;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x18 &&
                   RS2_FIELD(encodedInstr) == 0x02 && RS1_FIELD(encodedInstr) == 0x00 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_MRET;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x08 &&
                   RS2_FIELD(encodedInstr) == 0x05 && RS1_FIELD(encodedInstr) == 0x00 && RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_WFI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x0 && FUNCT7_FIELD(encodedInstr) == 0x09 &&
                   RD_FIELD(encodedInstr) == 0x00) {
            return INSTR_SFENCEVMA;
        }
    }
    return INSTR_UNKNOWN;
}

ALUFunc_t Core::getALUFunc(Instr_t instr) const {
    if (instr == INSTR_ADD || instr == INSTR_ADDI) {
        return ALUF_ADD;
    } else if (instr == INSTR_SUB) {
        return ALUF_SUB;
    } else if (instr == INSTR_SLL || instr == INSTR_SLLI) {
        return ALUF_SLL;
    } else if (instr == INSTR_SLT || instr == INSTR_SLTI) {
        return ALUF_SLT;
    } else if (instr == INSTR_SLTU || instr == INSTR_SLTIU) {
        return ALUF_SLTU;
    } else if (instr == INSTR_XOR || instr == INSTR_XORI) {
        return ALUF_XOR;
    } else if (instr == INSTR_SRL || instr == INSTR_SRLI) {
        return ALUF_SRL;
    } else if (instr == INSTR_SRA || instr == INSTR_SRAI) {
        return ALUF_SRA;
    } else if (instr == INSTR_OR || instr == INSTR_ORI) {
        return ALUF_OR;
    } else if (instr == INSTR_AND || instr == INSTR_ANDI) {
        return ALUF_AND;
    } else if (instr == INSTR_LB || instr == INSTR_LH || instr == INSTR_LW || instr == INSTR_LBU ||
               instr == INSTR_LHU) {
        return ALUF_ADD;
    } else if (instr == INSTR_JALR || instr == INSTR_JAL) {
        return ALUF_X;
    } else if (instr == INSTR_BEQ || instr == INSTR_BNE) {
        return ALUF_SUB;
    } else if (instr == INSTR_BLT || instr == INSTR_BGE) {
        return ALUF_SLT;
    } else if (instr == INSTR_BLTU || instr == INSTR_BGEU) {
        return ALUF_SLTU;
    } else if (instr == INSTR_SB || instr == INSTR_SH || instr == INSTR_SW) {
        return ALUF_ADD;
    } else if (instr == INSTR_AUIPC) {
        return ALUF_ADD;
    } else if (instr == INSTR_LUI) {
        return ALUF_COPY1;
    } else return ALUF_X;
}

ME_MaskType Core::getMemoryMask(Instr_t instr) const {
    if (instr == INSTR_LW || instr == INSTR_SW) {
        return MT_W;
    } else if (instr == INSTR_LH || instr == INSTR_SH) {
        return MT_H;
    } else if (instr == INSTR_LB || instr == INSTR_SB) {
        return MT_B;
    } else if (instr == INSTR_LHU) {
        return MT_HU;
    } else if (instr == INSTR_LBU) {
        return MT_BU;
    } else return MT_X;
}

unsigned int Core::getALUResult(ALUFunc_t func, unsigned int op1, unsigned int op2) const {
    if (func == ALUF_ADD) {
        return op1 + op2;
    } else if (func == ALUF_SUB) {
        return op1 - op2;
    } else if (func == ALUF_AND) {
        return op1 & op2;
    } else if (func == ALUF_OR) {
        return op1 | op2;
    } else if (func == ALUF_XOR) {
        return op1 ^ op2;
    } else if (func == ALUF_SLT) {
        if (static_cast<int>(op1) < static_cast<int>(op2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (func == ALUF_SLTU) {
        if (op1 < op2) {
            return 1;
        } else {
            return 0;
        }
    } else if (func == ALUF_SLL) {
        return op1 << (op2 & 0x1F);
    } else if (func == ALUF_SRA) {
        return static_cast<unsigned int>(static_cast<int>(op1) >> static_cast<int>(op2 & 0x1F));
    } else if (func == ALUF_SRL) {
        return op1 >> (op2 & 0x1F);
    } else if (func == ALUF_COPY1) {
        return op1;
    } else {
        return UNDEFINED_VALUE;
    }
}

unsigned int Core::getBranchResult(unsigned int encodedInstr, unsigned int ALUResult, unsigned int PCReg) const {
    if (getInstr(encodedInstr) == INSTR_BEQ && ALUResult == 0) {
        return PCReg + getImmediate(encodedInstr);
    } else if (getInstr(encodedInstr) == INSTR_BNE && ALUResult != 0) {
        return PCReg + getImmediate(encodedInstr);
    } else if (getInstr(encodedInstr) == INSTR_BLT && ALUResult == 1) {
        return PCReg + getImmediate(encodedInstr);
    } else if (getInstr(encodedInstr) == INSTR_BGE && ALUResult == 0) {
        return PCReg + getImmediate(encodedInstr);
    } else if (getInstr(encodedInstr) == INSTR_BLTU && ALUResult == 1) {
        return PCReg + getImmediate(encodedInstr);
    } else if (getInstr(encodedInstr) == INSTR_BGEU && ALUResult == 0) {
        return PCReg + getImmediate(encodedInstr);
    } else {
        return PCReg + 4;
    }
}

#endif //PROJECT_SIMPLIFIED_RISCV_ISA_H
