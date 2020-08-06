//
// Created by PauliusMorku on 06.14.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"
#include "../../RISCV_commons/Memory_Interfaces.h"

// Adjusts code to be appropriate for the SCAM tool
// 0 : Working ESL-Description
// 1 : Properties can be generated
#define SCAM 1


class ISA : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA);

    ISA(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort"),
            section(fetch),
            nextsection(fetch),
            pcReg(0) {
        SC_THREAD(run);
    }

    // ports for communication with memory
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCU_IF> fromMemoryPort;

    // ports for communication with register file
    master_in<RegfileType> fromRegsPort;
    master_out<RegfileWriteType> toRegsPort;

    // data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCU_IF fromMemoryData;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    RegfileType regfile;
    
    // ISA sections
    enum Sections {
        fetch,              // fetch next instruction from memory
        execute             // decode the fetched instruction and do all the manipulations till writing back to the register file
    };
    Sections section, nextsection;

    // Other control signals:
    unsigned int encodedInstr;

    unsigned int aluOp1;
    unsigned int aluOp2;
    unsigned int aluResult;

    unsigned int pcReg;

    unsigned int temp_dst;

    void run(); // thread

    EncType getEncType(unsigned int encodedInstr) const;

    InstrType getInstrType(unsigned int encodedInstr) const;

    unsigned int getRs1Addr(unsigned int encodedInstr) const;

    unsigned int getRs2Addr(unsigned int encodedInstr) const;

    unsigned int getRdAddr(unsigned int encodedInstr) const;

    unsigned int getImmediate(unsigned int encodedInstr) const;

    ALUfuncType getALUfunc(InstrType instr) const;

    ME_MaskType getMemoryMask(InstrType instr) const;

    unsigned int readRegfile(unsigned int src, RegfileType regfile) const; //! Return the value of a register of the input regfile

    unsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;

    unsigned int branchPCcalculation(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const;

    unsigned int getEncUALUresult(unsigned int encodedInstr, unsigned int pcReg) const;
};


void ISA::run() {

    while (true) {

        // fetch next instruction 
        if (section == Sections::fetch) {
            
            // Set up memory access
            memoryAccess.req = ME_RD;
            memoryAccess.mask = MT_W; // always for instructions
            memoryAccess.addrIn = pcReg;
            memoryAccess.dataIn = 0;    // not relevant
            
            toMemoryPort->write(memoryAccess); //Send request to memory
            
            fromMemoryPort->read(fromMemoryData); //Read encoded instruction from memory
            
            encodedInstr = fromMemoryData.loadedData;

#if SCAM == 0
            // Terminate if: Addi $0,$0,0 (NOP) is read. Just for debug
            if (fromMemoryData.loadedData == 0x13) {
                sc_stop();
                wait(SC_ZERO_TIME);
            }
#endif
            nextsection = Sections::execute;
        }

        if (section == Sections::execute) {

#ifdef LOGTOFILE
            fromRegsPort->read(regfile);
            cout << "S2: @DE:                                                                                                               Instruction Type:   " << stringInstrType(getInstrType(encodedInstr)) << endl;
            cout << "S2: @RF: Reading registers x" << dec << getRs1Addr(encodedInstr) << hex << " = "
                 << readRegfile(getRs1Addr(encodedInstr), regfile) << " , x" << dec << getRs2Addr(encodedInstr) << hex << " = " << readRegfile(getRs2Addr(encodedInstr), regfile) << endl;
#endif

            if (getEncType(encodedInstr) == ENC_R) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr);
                regfileWrite.dstData = aluResult;

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_B) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set-up PC
                pcReg = branchPCcalculation(encodedInstr, aluResult, pcReg);

            } else if (getEncType(encodedInstr) == ENC_S) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //prepare memory access
                memoryAccess.req = ME_WR;
                memoryAccess.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                memoryAccess.addrIn = aluResult; // Set address (getALUresult result) for stores
                memoryAccess.dataIn = readRegfile(getRs2Addr(encodedInstr), regfile); // Set data for stores, rs2 = source for store

                //Set-up PC
                pcReg = pcReg + 4;

                toMemoryPort->write(memoryAccess); // Request store

                // Store done
                fromMemoryPort->read(fromMemoryData); //Fixme: Why do we need this read? For store a write should be sufficient


            } else if (getEncType(encodedInstr) == ENC_U) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << getEncUALUresult(encodedInstr, pcReg) << "(hex) = " << dec << getEncUALUresult(encodedInstr, pcReg) << "(dec)" << endl;
#endif
                regfileWrite.dst = getRdAddr(encodedInstr); //Compute destination
                regfileWrite.dstData = getEncUALUresult(encodedInstr, pcReg);

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr);
                regfileWrite.dstData = pcReg + 4; //Compute result

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + getImmediate(encodedInstr);

            } else if (getEncType(encodedInstr) == ENC_I_I) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2);

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr);
                regfileWrite.dstData = aluResult; //Compute result

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_I_L) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |  ID (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //prepare memory access
                memoryAccess.req = ME_RD;
                memoryAccess.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                memoryAccess.addrIn = aluResult; // Set address (getALUresult result) for loads
                memoryAccess.dataIn = 0; // (not relevant for loads)

                temp_dst = getRdAddr(encodedInstr);

                //Set-up PC
                pcReg = pcReg + 4;

                // Request load
                toMemoryPort->write(memoryAccess);

                // Load done
                fromMemoryPort->read(fromMemoryData);

                regfileWrite.dst = temp_dst;
                temp_dst = 0;

                //Set up write back
                regfileWrite.dstData = fromMemoryData.loadedData;

                //Perform write back
                toRegsPort->write(regfileWrite);

            } else if (getEncType(encodedInstr) == ENC_I_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr);
                regfileWrite.dstData = pcReg + 4; //Compute result

                //Perform write back
                toRegsPort->write(regfileWrite);

                //Set-up PC
                pcReg = readRegfile(getRs1Addr(encodedInstr), regfile) + getImmediate(encodedInstr);

            } else {

                pcReg = pcReg + 4;
#if SCAM == 0
                // Terminate if Unknown instr
                if (getInstrType(encodedInstr) == InstrType::INSTR_UNKNOWN) {
                    std::cout << "Unknown INST" << std::endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
                }
#endif
            }

            nextsection = Sections::fetch; // Fetch next instruction
        }

        section = nextsection; // Set next section
    }
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
    }  else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
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
                return InstrType::INSTR_ADD;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return InstrType::INSTR_SUB;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return InstrType::INSTR_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return InstrType::INSTR_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return InstrType::INSTR_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return InstrType::INSTR_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return InstrType::INSTR_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return InstrType::INSTR_SRA;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return InstrType::INSTR_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return InstrType::INSTR_AND;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return InstrType::INSTR_ADDI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return InstrType::INSTR_SLLI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return InstrType::INSTR_SLTI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return InstrType::INSTR_SLTUI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return InstrType::INSTR_XORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return InstrType::INSTR_SRLI;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return InstrType::INSTR_SRAI;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return InstrType::INSTR_ORI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return InstrType::INSTR_ANDI;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return InstrType::INSTR_LB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return InstrType::INSTR_LH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return InstrType::INSTR_LW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return InstrType::INSTR_LBU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return InstrType::INSTR_LHU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return InstrType::INSTR_JALR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return InstrType::INSTR_SB;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return InstrType::INSTR_SH;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return InstrType::INSTR_SW;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return InstrType::INSTR_BEQ;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return InstrType::INSTR_BNE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return InstrType::INSTR_BLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return InstrType::INSTR_BGE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return InstrType::INSTR_BLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return InstrType::INSTR_BGEU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return InstrType::INSTR_LUI;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return InstrType::INSTR_AUIPC;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return InstrType::INSTR_JAL;
    } else {
        return InstrType::INSTR_UNKNOWN;
    }
}

unsigned int ISA::getRs1Addr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS1_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

unsigned int ISA::getRs2Addr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS2_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

unsigned int ISA::getRdAddr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return RD_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

unsigned int ISA::getImmediate(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        if (SIGN_FIELD(encodedInstr) == 0)
            return POS_IMM_I_FIELD(encodedInstr);
        else
            return NEG_IMM_I_FIELD(encodedInstr);
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
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

    if (instr == InstrType::INSTR_ADD  ||
        instr == InstrType::INSTR_ADDI ||
        instr == InstrType::INSTR_LB || instr == InstrType::INSTR_LH || instr == InstrType::INSTR_LW || instr == InstrType::INSTR_LBU || instr == InstrType::INSTR_LHU ||
        instr == InstrType::INSTR_SB || instr == InstrType::INSTR_SH || instr == InstrType::INSTR_SW ||
        instr == InstrType::INSTR_AUIPC) {
        return ALU_ADD;
    } else if (instr == InstrType::INSTR_SUB ||
               instr == InstrType::INSTR_BEQ || instr == InstrType::INSTR_BNE) {
        return ALU_SUB;
    } else if (instr == InstrType::INSTR_SLL || instr == InstrType::INSTR_SLLI) {
        return ALU_SLL;
    } else if (instr == InstrType::INSTR_SLT || instr == InstrType::INSTR_SLTI ||
               instr == InstrType::INSTR_BLT || instr == InstrType::INSTR_BGE) {
        return ALU_SLT;
    } else if (instr == InstrType::INSTR_SLTU || instr == InstrType::INSTR_SLTUI ||
               instr == InstrType::INSTR_BLTU || instr == InstrType::INSTR_BGEU) {
        return ALU_SLTU;
    } else if (instr == InstrType::INSTR_XOR || instr == InstrType::INSTR_XORI) {
        return ALU_XOR;
    } else if (instr == InstrType::INSTR_SRL || instr == InstrType::INSTR_SRLI) {
        return ALU_SRL;
    } else if (instr == InstrType::INSTR_SRA || instr == InstrType::INSTR_SRAI) {
        return ALU_SRA;
    } else if (instr == InstrType::INSTR_OR || instr == InstrType::INSTR_ORI) {
        return ALU_OR;
    } else if (instr == InstrType::INSTR_AND || instr == InstrType::INSTR_ANDI) {
        return ALU_AND;
    } else if (instr == InstrType::INSTR_JALR || instr == InstrType::INSTR_JAL) {
        return ALU_X;
    } else if (instr == InstrType::INSTR_LUI) {
        return ALU_COPY1;
    } else return ALU_X;
}

ME_MaskType ISA::getMemoryMask(InstrType instr) const {

    if (instr == InstrType::INSTR_LB || instr == InstrType::INSTR_SB) {
        return MT_B;
    } else if (instr == InstrType::INSTR_LH || instr == InstrType::INSTR_SH) {
        return MT_H;
    } else if (instr == InstrType::INSTR_LW || instr == InstrType::INSTR_SW) {
        return MT_W;
    } else if (instr == InstrType::INSTR_LBU) {
        return MT_BU;
    } else if (instr == InstrType::INSTR_LHU) {
        return MT_HU;
    } else return MT_X;
}

unsigned int ISA::readRegfile(unsigned int src, RegfileType regfile) const {

    if (src == 0) {
        return 0;
    } else if (src == 1) {
        return regfile.reg_file_01;
    } else if (src == 2) {
        return regfile.reg_file_02;
    } else if (src == 3) {
        return regfile.reg_file_03;
    } else if (src == 4) {
        return regfile.reg_file_04;
    } else if (src == 5) {
        return regfile.reg_file_05;
    } else if (src == 6) {
        return regfile.reg_file_06;
    } else if (src == 7) {
        return regfile.reg_file_07;
    } else if (src == 8) {
        return regfile.reg_file_08;
    } else if (src == 9) {
        return regfile.reg_file_09;
    } else if (src == 10) {
        return regfile.reg_file_10;
    } else if (src == 11) {
        return regfile.reg_file_11;
    } else if (src == 12) {
        return regfile.reg_file_12;
    } else if (src == 13) {
        return regfile.reg_file_13;
    } else if (src == 14) {
        return regfile.reg_file_14;
    } else if (src == 15) {
        return regfile.reg_file_15;
    } else if (src == 16) {
        return regfile.reg_file_16;
    } else if (src == 17) {
        return regfile.reg_file_17;
    } else if (src == 18) {
        return regfile.reg_file_18;
    } else if (src == 19) {
        return regfile.reg_file_19;
    } else if (src == 20) {
        return regfile.reg_file_20;
    } else if (src == 21) {
        return regfile.reg_file_21;
    } else if (src == 22) {
        return regfile.reg_file_22;
    } else if (src == 23) {
        return regfile.reg_file_23;
    } else if (src == 24) {
        return regfile.reg_file_24;
    } else if (src == 25) {
        return regfile.reg_file_25;
    } else if (src == 26) {
        return regfile.reg_file_26;
    } else if (src == 27) {
        return regfile.reg_file_27;
    } else if (src == 28) {
        return regfile.reg_file_28;
    } else if (src == 29) {
        return regfile.reg_file_29;
    } else if (src == 30) {
        return regfile.reg_file_30;
    } else {
        return regfile.reg_file_31;
    }
}

unsigned int ISA::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {

#ifdef LOGTOFILE
    cout << "S3: @AL: Operand1 = 0x" << hex << operand1 << "(hex) = " << dec << operand1 << "(dec), Operand2 = 0x" << hex << operand2
         << "(hex) = " << dec << operand2 << "(dec)" << endl;
#endif

    if (aluFunction == ALU_ADD) {
        return operand1 + operand2;
    } else if (aluFunction == ALU_SUB) {
        return operand1 + (-operand2);
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

unsigned int ISA::branchPCcalculation(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {

    if (getInstrType(encodedInstr) == InstrType::INSTR_BEQ && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType::INSTR_BNE && aluResult != 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType::INSTR_BLT && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType::INSTR_BGE && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType::INSTR_BLTU && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType::INSTR_BGEU && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else {
        return pcReg + 4;
    }
}

unsigned int ISA::getEncUALUresult(unsigned int encodedInstr, unsigned int pcReg) const {

    if (getInstrType(encodedInstr) == InstrType::INSTR_LUI) {
        return getALUresult(ALU_COPY1, getImmediate(encodedInstr), 0);
    } else { // InstrType::INSTR_AUIPC)
        return getALUresult(ALU_ADD, pcReg, getImmediate(encodedInstr));
    }
}


#endif //RISCV_ISA_H_