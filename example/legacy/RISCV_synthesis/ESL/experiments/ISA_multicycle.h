//
// Created by PauliusMorku on 06.14.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"

#define OPCODE_U1   0x37 //0110111
#define OPCODE_U2   0x17 //0010111
#define OPCODE_J    0x6F //1101111
#define OPCODE_I_J  0x67 //1100111
#define OPCODE_B    0x63 //1100011
#define OPCODE_I_L  0x03 //0000011
#define OPCODE_S    0x23 //0100011
#define OPCODE_I_I  0x13 //0010011
#define OPCODE_R    0x33 //0110011

#define OPCODE_FIELD(x) ((x) & 0x7F)
#define FUNCT3_FIELD(x) (((x) >> 12) & 0x07)
#define FUNCT7_FIELD(x) (((x) >> 25) & 0x7F)
#define RS1_FIELD(x)    (((x) >> 15) & 0x1F)
#define RS2_FIELD(x)    (((x) >> 20) & 0x1F)
#define RD_FIELD(x)     (((x) >> 7) & 0x1F)
#define SIGN_FIELD(x)   (((x) >> 31) & 0x1)

#define IMM_U_FIELD(x) ((x) & static_cast<unsigned int>(0xFFFFF000))
#define POS_IMM_I_FIELD(x) ((x) >> 20)
#define POS_IMM_S_FIELD(x) ((((x) >> 20) & 0xFE0) | (((x) >> 7) & 0x1F))
#define POS_IMM_B_FIELD(x) ((((x) << 4) & 0x800) | (((x) >> 20) & 0x7E0) | (((x) >> 7) & 0x1E))
#define POS_IMM_J_FIELD(x) (((x) & 0xFF000) | (((x) >> 9) & 0x800) | (((x) >> 20) & 0x7FE))
#define NEG_IMM_I_FIELD(x) (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_I_FIELD(x))
#define NEG_IMM_S_FIELD(x) (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_S_FIELD(x))
#define NEG_IMM_B_FIELD(x) (static_cast<unsigned int>(0xFFFFF000) | POS_IMM_B_FIELD(x))
#define NEG_IMM_J_FIELD(x) (static_cast<unsigned int>(0xFFF00000) | POS_IMM_J_FIELD(x))

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM

enum InstrType {
    INSTR_UNKNOWN,
    INSTR_ADD, INSTR_SUB, INSTR_SLL, INSTR_SLT, INSTR_SLTU, INSTR_XOR, INSTR_SRL, INSTR_SRA, INSTR_OR, INSTR_AND,   // R format
    INSTR_ADDI, INSTR_SLLI, INSTR_SLTI, INSTR_SLTIU, INSTR_XORI, INSTR_SRLI, INSTR_SRAI, INSTR_ORI, INSTR_ANDI,     // I format (I_I)
    INSTR_LB, INSTR_LH, INSTR_LW, INSTR_LBU, INSTR_LHU,                                                             // I format (I_L)
    INSTR_JALR,                                                                                                     // I format (I_J)
    INSTR_SB, INSTR_SH, INSTR_SW,                                                                                   // S format
    INSTR_BEQ, INSTR_BNE, INSTR_BLT, INSTR_BGE, INSTR_BLTU, INSTR_BGEU,                                             // B format
    INSTR_LUI, INSTR_AUIPC,                                                                                         // U format
    INSTR_JAL                                                                                                       // J format
};

enum EncType {
    ENC_R, ENC_I_I, ENC_I_L, ENC_I_J, ENC_S, ENC_B, ENC_U, ENC_J, ENC_ERR
};

enum ALUfuncType {
    ALU_X, ALU_ADD, ALU_SUB, ALU_SLL, ALU_SRL, ALU_SRA, ALU_AND, ALU_OR, ALU_XOR, ALU_SLT, ALU_SLTU, ALU_COPY1
};

struct DecodedInstrType {
    InstrType instr;
    EncType enc;
    ALUfuncType ALUfunc;
    ME_MaskType MEMmask;
    unsigned int rs1_addr; //5-bits
    unsigned int rs2_addr; //5-bits
    unsigned int rd_addr; //5-bits
    unsigned int imm;
};


class ISA : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA);

    ISA(sc_module_name name) :
            MEMtoISA_port("MEMtoISA_port"),
            ISAtoMEM_port("ISAtoMEM_port"),
            ISAtoRF_port("ISAtoRF_port"),
            RFtoISA_port("RFtoISA_port"),
            section(fetch),
            nextsection(fetch),
            pcReg(0) {
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> ISAtoMEM_port;
    blocking_in<MEtoCU_IF> MEMtoISA_port;

    // ports for communication with register file
    master_in<RFtoISA_IF> RFtoISA_port;
    master_out<ISAtoRF_IF> ISAtoRF_port;

    // data for communication with memory
    CUtoME_IF ISAtoMEM_data;
    MEtoCU_IF MEMtoISA_data;

    // data for communication with register file
    ISAtoRF_IF ISAtoRF_data;
    RFtoISA_IF RFtoISA_data;

    // ISA sections
    enum Sections {
        fetch,              // fetch next instruction from memory
        decode,             // decode instruction
        execute,            // compute result
        memory,             // perform stores and loads
        writeBack           // performs register write back
    };
    Sections section, nextsection;

    // PC register
    unsigned int pcReg;

    // ALU operands
    unsigned int aluOp1;
    unsigned int aluOp2;

    unsigned int result;

    unsigned int encodedInstr;
    DecodedInstrType decodedInstr;

    // thread
    void run();

    //Decoding functions
    EncType getEncType(unsigned int encodedInstr) const;

    InstrType getInstrType(unsigned int encodedInstr) const;

    unsigned int getRs1Addr(unsigned int encodedInstr) const;

    unsigned int getRs2Addr(unsigned int encodedInstr) const;

    unsigned int getRdAddr(unsigned int encodedInstr) const;

    unsigned int getImmediate(unsigned int encodedInstr) const;

    ME_MaskType getMemoryMask(InstrType instr) const;

    ALUfuncType getALUfunc(InstrType instr) const;

    unsigned int readRegfile(unsigned int src, RFtoISA_IF RFtoISA_data) const;

    unsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;
};


void ISA::run() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wmissing-noreturn"
    while (true) {
        if (section == Sections::fetch) {
            // set up memory access
            ISAtoMEM_data.req = ME_AccessType::ME_RD;
            ISAtoMEM_data.mask = ME_MaskType::MT_W; // always for instructions
            ISAtoMEM_data.addrIn = pcReg;
            //ISAtoMEM_data.dataIn = 0; // not relevant

            ISAtoMEM_port->write(ISAtoMEM_data); // send request to memory
            MEMtoISA_port->read(MEMtoISA_data); // read encoded instruction from decoder

            encodedInstr = MEMtoISA_data.loadedData;

            nextsection = Sections::decode; // set next section
#ifdef NOSCAM
            // terminate if: Addi $0,$0,0 (NOP) is read (just for debug)
            if (encodedInstr == 0XF93 || encodedInstr == 0x13) {
                sc_stop();
                wait(SC_ZERO_TIME);
            }
#endif
        } else if (section == Sections::decode) {
            decodedInstr.imm = getImmediate(encodedInstr);
            decodedInstr.enc = getEncType(encodedInstr);
            decodedInstr.instr = getInstrType(encodedInstr);
            decodedInstr.rd_addr = getRdAddr(encodedInstr);
            decodedInstr.rs1_addr = getRs1Addr(encodedInstr);
            decodedInstr.rs2_addr = getRs2Addr(encodedInstr);
            decodedInstr.ALUfunc = getALUfunc(decodedInstr.instr);
            decodedInstr.MEMmask = getMemoryMask(decodedInstr.instr);

            nextsection = Sections::execute; // set next section
        } else if (section == Sections::execute) {
            if (decodedInstr.enc == ENC_R) {
                RFtoISA_port->read(RFtoISA_data); // read register contents
                // set-up operands for alu by reading register file
                aluOp1 = readRegfile(decodedInstr.rs1_addr, RFtoISA_data);
                aluOp2 = readRegfile(decodedInstr.rs2_addr, RFtoISA_data);
                result = getALUresult(decodedInstr.ALUfunc, readRegfile(decodedInstr.rs1_addr, RFtoISA_data), aluOp2); // compute result

                pcReg = pcReg + 4; // set-up PC
                nextsection = Sections::writeBack; // set next section
            } else if (decodedInstr.enc == ENC_B) {
                RFtoISA_port->read(RFtoISA_data); // read register contents

                // set-up operands for alu by reading register file
                aluOp1 = readRegfile(decodedInstr.rs1_addr, RFtoISA_data);
                aluOp2 = readRegfile(decodedInstr.rs2_addr, RFtoISA_data);
                result = getALUresult(decodedInstr.ALUfunc, aluOp1, aluOp2); // compute result

                // set-up PC
                if (decodedInstr.instr == INSTR_BEQ && result == 0) {
                    pcReg = pcReg + decodedInstr.imm;
                } else if (decodedInstr.instr == INSTR_BNE && result != 0) {
                    pcReg = pcReg + decodedInstr.imm;
                } else if (decodedInstr.instr == INSTR_BLT && result == 1) {
                    pcReg = pcReg + decodedInstr.imm;
                } else if (decodedInstr.instr == INSTR_BGE && result == 0) {
                    pcReg = pcReg + decodedInstr.imm;
                } else if (decodedInstr.instr == INSTR_BLTU && result == 1) {
                    pcReg = pcReg + decodedInstr.imm;
                } else if (decodedInstr.instr == INSTR_BGEU && result == 0) {
                    pcReg = pcReg + decodedInstr.imm;
                } else pcReg = pcReg + 4;

                nextsection = Sections::fetch; // set next section
            } else if (decodedInstr.enc == ENC_S) {
                RFtoISA_port->read(RFtoISA_data); // read register contents

                // set-up operands for alu by reading register file
                aluOp1 = readRegfile(decodedInstr.rs1_addr, RFtoISA_data);
                aluOp2 = decodedInstr.imm;
                result = getALUresult(decodedInstr.ALUfunc, aluOp1, aluOp2); // always ALU_ADD

                pcReg = pcReg + 4; // set-up PC
                nextsection = Sections::memory; // set next section
            } else if (decodedInstr.enc == ENC_U) {
                if (decodedInstr.instr == INSTR_LUI) {
                    aluOp1 = decodedInstr.imm;
                    result = getALUresult(decodedInstr.ALUfunc, aluOp1, 0); // always ALU_COPY1
                } else { // INSTR_AUIPC
                    aluOp1 = pcReg;
                    aluOp2 = decodedInstr.imm;
                    result = getALUresult(decodedInstr.ALUfunc, aluOp1, aluOp2); // always ALU_ADD
                }

                pcReg = pcReg + 4; // set-up PC
                nextsection = Sections::writeBack; // set next section
            } else if (decodedInstr.enc == ENC_J) { // INSTR_JAL
                result = pcReg + 4; // compute result

                // set-up PC
                pcReg = pcReg + decodedInstr.imm;
                nextsection = Sections::writeBack;
            } else if (decodedInstr.enc == ENC_I_J) { // INSTR_JALR
                RFtoISA_port->read(RFtoISA_data); // read register contents
                result = pcReg + 4; // compute result

                pcReg = readRegfile(decodedInstr.rs1_addr, RFtoISA_data) + decodedInstr.imm; // set-up PC
                nextsection = Sections::writeBack; // set next section
            } else if (decodedInstr.enc == ENC_I_I) {
                RFtoISA_port->read(RFtoISA_data); // read register contents

                // set-up operands for ALU by reading register file
                aluOp1 = readRegfile(decodedInstr.rs1_addr, RFtoISA_data);
                aluOp2 = decodedInstr.imm;
                result = getALUresult(decodedInstr.ALUfunc, aluOp1, aluOp2); //Compute result

                pcReg = pcReg + 4; // set-up PC
                nextsection = Sections::writeBack; // set next section
            } else if (decodedInstr.enc == ENC_I_L) { // loads
                RFtoISA_port->read(RFtoISA_data); // read register contents

                // set-up operands for ALU by reading register file
                aluOp1 = readRegfile(decodedInstr.rs1_addr, RFtoISA_data);
                aluOp2 = decodedInstr.imm;
                result = getALUresult(decodedInstr.ALUfunc, aluOp1, aluOp2); // always ALU_ADD

                pcReg = pcReg + 4; // set-up PC
                nextsection = Sections::memory; // set next section
            } else {
                nextsection = Sections::fetch; // set next section
#ifdef NOSCAM
                // Terminate if INSTR_UNKNOWN
                if (decodedInstr.instr == INSTR_UNKNOWN) {
                    std::cout << "INSTR_UNKNOWN" << std::endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
                }
#endif
            }
        } else if (section == Sections::memory) {
            if (decodedInstr.enc == ENC_S) {
                ISAtoMEM_data.req = ME_WR;
                ISAtoMEM_data.mask = decodedInstr.MEMmask; // set memory access mask
                ISAtoMEM_data.addrIn = result; // set address for stores
                ISAtoMEM_data.dataIn = readRegfile(decodedInstr.rs2_addr, RFtoISA_data); // set data for stores, rs2 = source for store
                ISAtoMEM_port->write(ISAtoMEM_data);// write to memory

                nextsection = Sections::fetch; // set next section
            } else { //ENC_I_L
                ISAtoMEM_data.req = ME_RD;
                ISAtoMEM_data.mask = decodedInstr.MEMmask; // set memory access mask
                ISAtoMEM_data.addrIn = result; // set address for loads
                //ISAtoMEM_data.dataIn = 0; // not relevant for loads
                ISAtoMEM_port->write(ISAtoMEM_data); // send request to memory
                MEMtoISA_port->read(MEMtoISA_data); // read from memory
                result = MEMtoISA_data.loadedData;

                nextsection = Sections::writeBack; // set next section
            }
        } else if (section == Sections::writeBack) {
            ISAtoRF_data.dst = decodedInstr.rd_addr;
            ISAtoRF_data.dstData = result;
            ISAtoRF_port->write(ISAtoRF_data);
            nextsection = Sections::fetch; // set next section
        }
        section = nextsection; // set next section
    }
#pragma clang diagnostic pop
}


EncType ISA::getEncType(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return ENC_R;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        return ENC_I_I;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return ENC_I_L;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return ENC_I_J;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return ENC_S;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return ENC_B;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return ENC_U;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return ENC_J;
    } else {
        return ENC_ERR;
    }
}


InstrType ISA::getInstrType(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_ADD;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SUB;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRA;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_AND;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_ADDI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SLLI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SLTI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_SLTIU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_XORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return INSTR_SRLI;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return INSTR_SRAI;
            } else {
                return INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_ORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_ANDI;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_LB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_LH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_LW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_LBU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_LHU;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return INSTR_JALR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_SB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_SH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_SW;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_BEQ;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_BNE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return INSTR_BLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_BGE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_BLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_BGEU;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return INSTR_LUI;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return INSTR_AUIPC;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return INSTR_JAL;
    } else {
        return INSTR_UNKNOWN;
    }
}


unsigned int ISA::getRs1Addr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return RS1_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        return RS1_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return RS1_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return RS1_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return RS1_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS1_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getRs2Addr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return RS2_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return RS2_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS2_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getRdAddr(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return RD_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return RD_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getImmediate(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_I_FIELD(encodedInstr);
        else
            return NEG_IMM_I_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_I_FIELD(encodedInstr);
        else
            return NEG_IMM_I_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_B_FIELD(encodedInstr);
        else
            return NEG_IMM_B_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_I_FIELD(encodedInstr);
        else
            return NEG_IMM_I_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_S_FIELD(encodedInstr);
        else
            return NEG_IMM_S_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return IMM_U_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return IMM_U_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_J_FIELD(encodedInstr);
        else
            return NEG_IMM_J_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


ALUfuncType ISA::getALUfunc(InstrType instr) const {
    if (instr == INSTR_ADD || instr == INSTR_ADDI) {
        return ALU_ADD;
    } else if (instr == INSTR_SUB) {
        return ALU_SUB;
    } else if (instr == INSTR_SLL || instr == INSTR_SLLI) {
        return ALU_SLL;
    } else if (instr == INSTR_SLT || instr == INSTR_SLTI) {
        return ALU_SLT;
    } else if (instr == INSTR_SLTU || instr == INSTR_SLTIU) {
        return ALU_SLTU;
    } else if (instr == INSTR_XOR || instr == INSTR_XORI) {
        return ALU_XOR;
    } else if (instr == INSTR_SRL || instr == INSTR_SRLI) {
        return ALU_SRL;
    } else if (instr == INSTR_SRA || instr == INSTR_SRAI) {
        return ALU_SRA;
    } else if (instr == INSTR_OR || instr == INSTR_ORI) {
        return ALU_OR;
    } else if (instr == INSTR_AND || instr == INSTR_ANDI) {
        return ALU_AND;
    } else if (instr == INSTR_LB || instr == INSTR_LH || instr == INSTR_LW || instr == INSTR_LBU || instr == INSTR_LHU) {
        return ALU_ADD;
    } else if (instr == INSTR_JALR || instr == INSTR_JAL) {
        return ALU_X;
    } else if (instr == INSTR_BEQ || instr == INSTR_BNE) {
        return ALU_SUB;
    } else if (instr == INSTR_BLT || instr == INSTR_BGE) {
        return ALU_SLT;
    } else if (instr == INSTR_BLTU || instr == INSTR_BGEU) {
        return ALU_SLTU;
    } else if (instr == INSTR_SB || instr == INSTR_SH || instr == INSTR_SW) {
        return ALU_ADD;
    } else if (instr == INSTR_AUIPC) {
        return ALU_ADD;
    } else if (instr == INSTR_LUI) {
        return ALU_COPY1;
    } else return ALU_X;
}


ME_MaskType ISA::getMemoryMask(InstrType instr) const {
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


unsigned int ISA::readRegfile(unsigned int src, RFtoISA_IF RFtoISA_data) const {
    if (src == 0) {
        return 0;
    } else if (src == 1) {
        return RFtoISA_data.reg_file_01;
    } else if (src == 2) {
        return RFtoISA_data.reg_file_02;
    } else if (src == 3) {
        return RFtoISA_data.reg_file_03;
    } else if (src == 4) {
        return RFtoISA_data.reg_file_04;
    } else if (src == 5) {
        return RFtoISA_data.reg_file_05;
    } else if (src == 6) {
        return RFtoISA_data.reg_file_06;
    } else if (src == 7) {
        return RFtoISA_data.reg_file_07;
    } else if (src == 8) {
        return RFtoISA_data.reg_file_08;
    } else if (src == 9) {
        return RFtoISA_data.reg_file_09;
    } else if (src == 10) {
        return RFtoISA_data.reg_file_10;
    } else if (src == 11) {
        return RFtoISA_data.reg_file_11;
    } else if (src == 12) {
        return RFtoISA_data.reg_file_12;
    } else if (src == 13) {
        return RFtoISA_data.reg_file_13;
    } else if (src == 14) {
        return RFtoISA_data.reg_file_14;
    } else if (src == 15) {
        return RFtoISA_data.reg_file_15;
    } else if (src == 16) {
        return RFtoISA_data.reg_file_16;
    } else if (src == 17) {
        return RFtoISA_data.reg_file_17;
    } else if (src == 18) {
        return RFtoISA_data.reg_file_18;
    } else if (src == 19) {
        return RFtoISA_data.reg_file_19;
    } else if (src == 20) {
        return RFtoISA_data.reg_file_20;
    } else if (src == 21) {
        return RFtoISA_data.reg_file_21;
    } else if (src == 22) {
        return RFtoISA_data.reg_file_22;
    } else if (src == 23) {
        return RFtoISA_data.reg_file_23;
    } else if (src == 24) {
        return RFtoISA_data.reg_file_24;
    } else if (src == 25) {
        return RFtoISA_data.reg_file_25;
    } else if (src == 26) {
        return RFtoISA_data.reg_file_26;
    } else if (src == 27) {
        return RFtoISA_data.reg_file_27;
    } else if (src == 28) {
        return RFtoISA_data.reg_file_28;
    } else if (src == 29) {
        return RFtoISA_data.reg_file_29;
    } else if (src == 30) {
        return RFtoISA_data.reg_file_30;
    } else {
        return RFtoISA_data.reg_file_31;
    }
}


unsigned int ISA::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {
    if (aluFunction == ALU_ADD) {
        return operand1 + operand2;
    } else if (aluFunction == ALU_SUB) {
        return operand1 - operand2;
    } else if (aluFunction == ALU_AND) {
        return operand1 & operand2;
    } else if (aluFunction == ALU_OR) {
        return operand1 | operand2;
    } else if (aluFunction == ALU_XOR) {
        return operand1 ^ operand2;
    } else if (aluFunction == ALU_SLT) {
        if (static_cast<int>(operand1) < static_cast<int>(operand2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (aluFunction == ALU_SLTU) {
        if (operand1 < operand2) {
            return 1;
        } else {
            return 0;
        }
    } else if (aluFunction == ALU_SLL) {
        return operand1 << (operand2 & 0x1F);
    } else if (aluFunction == ALU_SRA) {
        return static_cast<unsigned int>(static_cast<int>(operand1) >> static_cast<int>(operand2 & 0x1F));
    } else if (aluFunction == ALU_SRL) {
        return operand1 >> (operand2 & 0x1F);
    } else if (aluFunction == ALU_COPY1) {
        return operand1;
    } else {
        return 0;
    }
}

#endif //RISCV_ISA_H_
