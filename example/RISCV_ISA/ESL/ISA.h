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
#define SCAM 0


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

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCP_IF> fromMemoryPort;

    // ports for communication with register file
    master_in<RegfileType> fromRegsPort;
    master_out<RegfileWriteType> toRegsPort;

    // data for communication with memory
    CUtoME_IF memoryAccess;
    MEtoCP_IF fromMemoryData;

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

    unsigned int opcode;
    unsigned int funct3;
    unsigned int funct7;

    unsigned int aluOp1;
    unsigned int aluOp2;
    unsigned int aluResult;

    unsigned int pcReg;

    void run(); // thread

    //Decoding functions
    unsigned int getOpcode(unsigned int encodedInstr) const;

    unsigned int getFunct3(unsigned int encodedInstr) const;

    unsigned int getFunct7(unsigned int encodedInstr) const;

    EncType getEncType(unsigned int opcode) const;

    InstrType getInstrType(unsigned int opcode, unsigned int funct3, unsigned int funct7) const;

    unsigned int getRs1Addr(unsigned int encodedInstr, unsigned int opcode) const;

    unsigned int getRs2Addr(unsigned int encodedInstr, unsigned int opcode) const;

    unsigned int getRdAddr(unsigned int encodedInstr, unsigned int opcode) const;

    unsigned int getImmediate(unsigned int encodedInstr, unsigned int opcode) const;

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
            if (fromMemoryData.loadedData == 0X00000F93 || fromMemoryData.loadedData == 0x13) {
                sc_stop();
                wait(SC_ZERO_TIME);
            }
#endif
            nextsection = Sections::execute;
        }

        if (section == Sections::execute) {

            // Decode instruction
            opcode = getOpcode(encodedInstr);
            funct3 = getFunct3(encodedInstr);
            funct7 = getFunct7(encodedInstr);

#ifdef LOGTOFILE
            fromRegsPort->read(regfile);
            cout << "                                                                       Instruction Type:   " << stringInstrType(getInstrType(opcode, funct3, funct7)) << endl;
            cout << "S2: @RF: Reading registers x" << dec << getRs1Addr(encodedInstr, opcode) << hex << " = "
                 << readRegfile(getRs1Addr(encodedInstr, opcode), regfile) << " , x" << dec << getRs2Addr(encodedInstr, opcode) << hex << " = " << readRegfile(getRs2Addr(encodedInstr, opcode), regfile) << endl;
#endif

            if (getEncType(opcode) == ENC_R) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr, opcode), regfile);
                aluOp2 = readRegfile(getRs2Addr(encodedInstr, opcode), regfile);

                aluResult = getALUresult(getALUfunc(getInstrType(opcode, funct3, funct7)), aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr, opcode);
                regfileWrite.dstData = aluResult;

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(opcode) == ENC_B) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr, opcode), regfile);
                aluOp2 = readRegfile(getRs2Addr(encodedInstr, opcode), regfile);

                aluResult = getALUresult(getALUfunc(getInstrType(opcode, funct3, funct7)), aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set-up PC
                pcReg = branchPCcalculation(encodedInstr, aluResult, pcReg);

            } else if (getEncType(opcode) == ENC_S) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr, opcode), regfile);
                aluOp2 = getImmediate(encodedInstr, opcode);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //prepare memory access
                memoryAccess.req = ME_WR;
                memoryAccess.mask = getMemoryMask(getInstrType(opcode, funct3, funct7)); // set memory access mask
                memoryAccess.addrIn = aluResult; // Set address (getALUresult result) for stores
                memoryAccess.dataIn = readRegfile(getRs2Addr(encodedInstr, opcode), regfile); // Set data for stores, rs2 = source for store

                toMemoryPort->write(memoryAccess); // Request store

                // Store done
                fromMemoryPort->read(fromMemoryData); //Fixme: Why do we need this read? For store a write should be sufficient

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(opcode) == ENC_U) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

#ifdef LOGTOFILE
                if (getInstrType(opcode, funct3, funct7) == InstrType::INSTR_LUI) {
                    //Set-up operands for alu by reading from regfile
                    aluOp1 = getImmediate(encodedInstr, opcode);
                    aluOp2 = 0;

                    aluResult = getALUresult(ALU_COPY1, aluOp1, 0); //Compute result

                } else { //(getInstrType(opcode, funct3, funct7) == InstrType::INSTR_AUIPC)
                    // Set-up operands for alu by reading from regfile
                    aluOp1 = pcReg;
                    aluOp2 = getImmediate(encodedInstr, opcode);

                    aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result
                }

                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                regfileWrite.dst = getRdAddr(encodedInstr, opcode); //Compute destination
                regfileWrite.dstData = getEncUALUresult(encodedInstr, pcReg);

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(opcode) == ENC_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr, opcode);
                regfileWrite.dstData = pcReg + 4; //Compute result

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + getImmediate(encodedInstr, opcode);

            } else if (getEncType(opcode) == ENC_I_I) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr, opcode), regfile);
                aluOp2 = getImmediate(encodedInstr, opcode);

                aluResult = getALUresult(getALUfunc(getInstrType(opcode, funct3, funct7)), aluOp1, aluOp2);

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr, opcode);
                regfileWrite.dstData = aluResult; //Compute result

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(opcode) == ENC_I_L) { // loads
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |  ID (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr, opcode), regfile);
                aluOp2 = getImmediate(encodedInstr, opcode);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);

#ifdef LOGTOFILE
                cout << "S3: @AL: Result = 0x" << hex << aluResult << "(hex) = " << dec << aluResult << "(dec)" << endl;
#endif
                //prepare memory access
                memoryAccess.req = ME_RD;
                memoryAccess.mask = getMemoryMask(getInstrType(opcode, funct3, funct7)); // set memory access mask
                memoryAccess.addrIn = aluResult; // Set address (getALUresult result) for loads
                memoryAccess.dataIn = 0; // (not relevant for loads)

                regfileWrite.dst = getRdAddr(encodedInstr, opcode);

                // Request load
                toMemoryPort->write(memoryAccess);

                // Load done
                fromMemoryPort->read(fromMemoryData);

                //Set up write back
                regfileWrite.dstData = fromMemoryData.loadedData;

                //Perform write back
                toRegsPort->write(regfileWrite);

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(opcode) == ENC_I_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////

                fromRegsPort->read(regfile); //Read register contents
                
                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr, opcode);
                regfileWrite.dstData = pcReg + 4; //Compute result

                //Perform write back
                toRegsPort->write(regfileWrite);

                //Set-up PC
                pcReg = readRegfile(getRs1Addr(encodedInstr, opcode), regfile) + getImmediate(encodedInstr, opcode);

            } else {

#if SCAM == 0
                // Terminate if Unknown instr
                if (getInstrType(opcode, funct3, funct7) == InstrType::INSTR_UNKNOWN) {
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


unsigned int ISA::getOpcode(unsigned int encodedInstr) const {
    return Sub(encodedInstr, 6, 0);
}

unsigned int ISA::getFunct3(unsigned int encodedInstr) const {
    return Sub(encodedInstr, 14, 12);
}

unsigned int ISA::getFunct7(unsigned int encodedInstr) const {
    return Sub(encodedInstr, 31, 25);
}

EncType ISA::getEncType(unsigned int opcode) const {

    if (opcode == 0x33) {
        return ENC_R;
    } else if (opcode == 0x13) {
        return ENC_I_I;
    } else if (opcode == 0x03) {
        return ENC_I_L;
    } else if (opcode == 0x67) {
        return ENC_I_J;
    } else if (opcode == 0x23) {
        return ENC_S;
    } else if (opcode == 0x63) {
        return ENC_B;
    } else if (opcode == 0x37 || opcode == 0x17) {
        return ENC_U;
    } else if (opcode == 0x6F) {
        return ENC_J;
    } else {
        return ENC_ERR;
    }
}

InstrType ISA::getInstrType(unsigned int opcode, unsigned int funct3, unsigned int funct7) const {

    if (opcode == 0x33) {
        if (funct3 == 0x00) {
            if (funct7 == 0x00) {
                return InstrType::INSTR_ADD;
            } else if (funct7 == 0x20) {
                return InstrType::INSTR_SUB;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (funct3 == 0x01) {
            return InstrType::INSTR_SLL;
        } else if (funct3 == 0x02) {
            return InstrType::INSTR_SLT;
        } else if (funct3 == 0x03) {
            return InstrType::INSTR_SLTU;
        } else if (funct3 == 0x04) {
            return InstrType::INSTR_XOR;
        } else if (funct3 == 0x05) {
            if (funct7 == 0x00) {
                return InstrType::INSTR_SRL;
            } else if (funct7 == 0x20) {
                return InstrType::INSTR_SRA;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (funct3 == 0x06) {
            return InstrType::INSTR_OR;
        } else if (funct3 == 0x07) {
            return InstrType::INSTR_AND;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (opcode == 0x13) {
        if (funct3 == 0x00) {
            return InstrType::INSTR_ADDI;
        } else if (funct3 == 0x01) {
            return InstrType::INSTR_SLLI;
        } else if (funct3 == 0x02) {
            return InstrType::INSTR_SLTI;
        } else if (funct3 == 0x03) {
            return InstrType::INSTR_SLTUI;
        } else if (funct3 == 0x04) {
            return InstrType::INSTR_XORI;
        } else if (funct3 == 0x05) {
            if (funct7 == 0x00) {
                return InstrType::INSTR_SRLI;
            } else if (funct7 == 0x20) {
                return InstrType::INSTR_SRAI;
            } else {
                return InstrType::INSTR_UNKNOWN;
            }
        } else if (funct3 == 0x06) {
            return InstrType::INSTR_ORI;
        } else if (funct3 == 0x07) {
            return InstrType::INSTR_ANDI;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (opcode == 0x03) {
        if (funct3 == 0x00) {
            return InstrType::INSTR_LB;
        } else if (funct3 == 0x01) {
            return InstrType::INSTR_LH;
        } else if (funct3 == 0x02) {
            return InstrType::INSTR_LW;
        } else if (funct3 == 0x04) {
            return InstrType::INSTR_LBU;
        } else if (funct3 == 0x05) {
            return InstrType::INSTR_LHU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (opcode == 0x67) {
        return InstrType::INSTR_JALR;
    } else if (opcode == 0x23) {
        if (funct3 == 0x00) {
            return InstrType::INSTR_SB;
        } else if (funct3 == 0x01) {
            return InstrType::INSTR_SH;
        } else if (funct3 == 0x02) {
            return InstrType::INSTR_SW;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (opcode == 0x63) {
        if (funct3 == 0x00) {
            return InstrType::INSTR_BEQ;
        } else if (funct3 == 0x01) {
            return InstrType::INSTR_BNE;
        } else if (funct3 == 0x04) {
            return InstrType::INSTR_BLT;
        } else if (funct3 == 0x05) {
            return InstrType::INSTR_BGE;
        } else if (funct3 == 0x06) {
            return InstrType::INSTR_BLTU;
        } else if (funct3 == 0x07) {
            return InstrType::INSTR_BGEU;
        } else {
            return InstrType::INSTR_UNKNOWN;
        }
    } else if (opcode == 0x37) {
        return InstrType::INSTR_LUI;
    } else if (opcode == 0x17) {
        return InstrType::INSTR_AUIPC;
    } else if (opcode == 0x6F) {
        return InstrType::INSTR_JAL;
    } else {
        return InstrType::INSTR_UNKNOWN;
    }
}

unsigned int ISA::getRs1Addr(unsigned int encodedInstr, unsigned int opcode) const {

    if (opcode == 0x33) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else if (opcode == 0x13) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else if (opcode == 0x03) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else if (opcode == 0x67) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else if (opcode == 0x23) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else if (opcode == 0x63) {
        return Sub(encodedInstr, RS1_MSB, RS1_LSB);
    } else {
        return 0;
    }
}

unsigned int ISA::getRs2Addr(unsigned int encodedInstr, unsigned int opcode) const {

    if (opcode == 0x33) {
        return Sub(encodedInstr, RS2_MSB, RS2_LSB);
    } else if (opcode == 0x23) {
        return Sub(encodedInstr, RS2_MSB, RS2_LSB);
    } else if (opcode == 0x63) {
        return Sub(encodedInstr, RS2_MSB, RS2_LSB);
    } else {
        return 0;
    }
}

unsigned int ISA::getRdAddr(unsigned int encodedInstr, unsigned int opcode) const {

    if (opcode == 0x33) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x13) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x03) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x67) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x37) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x17) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else if (opcode == 0x6F) {
        return Sub(encodedInstr, RD_MSB, RD_LSB);
    } else {
        return 0;
    }
}

unsigned int ISA::getImmediate(unsigned int encodedInstr, unsigned int opcode) const {

    if (opcode == 0x13) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Fill(20), 20, Sub(encodedInstr, 31, 20), 12);
        } else {
            return Sub(encodedInstr, 31, 20);
        }
    } else if (opcode == 0x03) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Fill(20), 20, Sub(encodedInstr, 31, 20), 12);
        } else {
            return Sub(encodedInstr, 31, 20);
        }
    } else if (opcode == 0x63) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Cat(Fill(19), 19, Cat(Cat(Sub(encodedInstr, 31, 31), 1, Sub(encodedInstr, 7, 7), 1), 2, Cat(Sub(encodedInstr, 30, 25), 6, Sub(encodedInstr, 11, 8), 4), 10), 12), 31, 0, 1);
        } else {
            return Cat(Cat(Cat(Sub(encodedInstr, 31, 31), 1, Sub(encodedInstr, 7, 7), 1), 2, Cat(Sub(encodedInstr, 30, 25), 6, Sub(encodedInstr, 11, 8), 4), 10), 31, 0, 1);
        }
    } else if (opcode == 0x67) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Fill(20), 20, Sub(encodedInstr, 31, 20), 12);
        } else {
            return Sub(encodedInstr, 31, 20);
        }
    } else if (opcode == 0x23) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Fill(20), 20, Cat(Sub(encodedInstr, 31, 25), 7, Sub(encodedInstr, 11, 7), 5), 12);
        } else {
            return Cat(Sub(encodedInstr, 31, 25), 7, Sub(encodedInstr, 11, 7), 5);
        }
    } else if (opcode == 0x37) {
        return Cat(Sub(encodedInstr, 31, 12), 20, 0, 12);
    } else if (opcode == 0x17) {
        return Cat(Sub(encodedInstr, 31, 12), 20, 0, 12);
    } else if (opcode == 0x6F) {
        if (Sub(encodedInstr, 31, 31) == 1) {
            return Cat(Cat(Fill(11), 11, Cat(Cat(Sub(encodedInstr, 31, 31), 1, Sub(encodedInstr, 19, 12), 8), 9, Cat(Sub(encodedInstr, 20, 20), 1, Sub(encodedInstr, 30, 21), 10), 11), 20), 31, 0, 1);
        } else {
            return Cat(Cat(Cat(Sub(encodedInstr, 31, 31), 1, Sub(encodedInstr, 19, 12), 8), 9, Cat(Sub(encodedInstr, 20, 20), 1, Sub(encodedInstr, 30, 21), 10), 11), 31, 0, 1);
        }
    } else {
        return 0;
    }
}

ALUfuncType ISA::getALUfunc(InstrType instr) const {

    if (instr == InstrType::INSTR_ADD || instr == InstrType::INSTR_ADDI) {
        return ALU_ADD;
    } else if (instr == InstrType::INSTR_SUB) {
        return ALU_SUB;
    } else if (instr == InstrType::INSTR_SLL || instr == InstrType::INSTR_SLLI) {
        return ALU_SLL;
    } else if (instr == InstrType::INSTR_SLT || instr == InstrType::INSTR_SLTI) {
        return ALU_SLT;
    } else if (instr == InstrType::INSTR_SLTU || instr == InstrType::INSTR_SLTUI) {
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
    } else if (instr == InstrType::INSTR_LB || instr == InstrType::INSTR_LH || instr == InstrType::INSTR_LW || instr == InstrType::INSTR_LBU || instr == InstrType::INSTR_LHU) {
        return ALU_ADD;
    } else if (instr == InstrType::INSTR_JALR || instr == InstrType::INSTR_JAL) {
        return ALU_X;
    } else if (instr == InstrType::INSTR_BEQ || instr == InstrType::INSTR_BNE) {
        return ALU_SUB;
    } else if (instr == InstrType::INSTR_BLT || instr == InstrType::INSTR_BGE) {
        return ALU_SLT;
    } else if (instr == InstrType::INSTR_BLTU || instr == InstrType::INSTR_BGEU) {
        return ALU_SLTU;
    } else if (instr == InstrType::INSTR_SB || instr == InstrType::INSTR_SH || instr == InstrType::INSTR_SW) {
        return ALU_ADD;
    } else if (instr == InstrType::INSTR_AUIPC) {
        return ALU_ADD;
    } else if (instr == InstrType::INSTR_LUI) {
        return ALU_COPY1;
    } else return ALU_X;
}

ME_MaskType ISA::getMemoryMask(InstrType instr) const {

    if (instr == InstrType::INSTR_LW || instr == InstrType::INSTR_SW) {
        return MT_W;
    } else if (instr == InstrType::INSTR_LH || instr == InstrType::INSTR_SH) {
        return MT_H;
    } else if (instr == InstrType::INSTR_LB || instr == InstrType::INSTR_SB) {
        return MT_B;
    } else if (instr == InstrType::INSTR_LHU) {
        return MT_HU;
    } else if (instr == InstrType::INSTR_LBU) {
        return MT_BU;
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
    cout << "S3: @AL: Decoded getALUresult operands: OP1 = 0x" << hex << operand1 << "(hex) = " << dec << operand1 << "(dec), OP2 = 0x" << hex << operand2
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
        return operand1 << (operand2 & 0x1F); // shamt in aluOp2 (imm)!
    } else if (aluFunction == ALU_SRA) {
        return static_cast<unsigned int>(static_cast<int>(operand1) >> static_cast<int>(operand2 & 0x1F)); // shamt in aluOp2 (imm)!
    } else if (aluFunction == ALU_SRL) {
        return operand1 >> (operand2 & 0x1F); // shamt in aluOp2 (imm)!
    } else if (aluFunction == ALU_COPY1) {
        return operand1;
    } else {
        return 0;
    }
}

unsigned int ISA::branchPCcalculation(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {
    if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BEQ && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BNE && aluResult != 0) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BLT && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BGE && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BLTU && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_BGEU && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr, getOpcode(encodedInstr));
    } else {
        return pcReg + 4;
    }
}

unsigned int ISA::getEncUALUresult(unsigned int encodedInstr, unsigned int pcReg) const {
    if (getInstrType(getOpcode(encodedInstr), getFunct3(encodedInstr), getFunct7(encodedInstr)) == InstrType::INSTR_LUI) {
        return getALUresult(ALU_COPY1, getImmediate(encodedInstr, getOpcode(encodedInstr)), 0); //Compute result
    } else { // InstrType::INSTR_AUIPC)
        return getALUresult(ALU_ADD, pcReg, getImmediate(encodedInstr, getOpcode(encodedInstr))); //Compute result
    }
}

#endif //RISCV_ISA_H_