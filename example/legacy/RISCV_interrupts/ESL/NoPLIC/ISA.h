//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_ISA_H_
#define RISCV_ISA_H_

#include "systemc.h"
#include "Interfaces.h"
#include "../../../RISCV_commons/Memory_Interfaces.h"
#include "../../../RISCV_commons/Defines.h"
#include "CPU_Interfaces.h"

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> #define NOSCAM
// Properties can be generated -> //#define NOSCAM
//#define NOSCAM

#define PRIVCODE_ECALL      0x000
#define PRIVCODE_EBREAK     0x001
#define PRIVCODE_URET       0x002
#define PRIVCODE_SRET       0x102
#define PRIVCODE_MRET       0x302
#define PRIVCODE_WFI        0x105
#define PRIVCODE_SFENCEVMA  0x009


#define MCSR_MSTATUS    0x300
#define MCSR_MISA       0x301
#define MCSR_MIE        0x304
#define MCSR_MTVEC      0x305
#define MCSR_MSCRATCH   0x340
#define MCSR_MEPC       0x341
#define MCSR_MCAUSE     0x342
#define MCSR_MTVAL      0x343
#define MCSR_MIP        0x344
#define MCSR_MVENDORID  0xF11
#define MCSR_MARCHID    0xF12
#define MCSR_MIMPID     0xF13
#define MCSR_MHARTID    0xF14

#define MSTATUS_MIE(x)  ((x) & 0x00000008)
#define MTRAP_ML12I(x)  ((x) & 0x00001000)
#define MTRAP_MEI(x)    ((x) & 0x00000800)
#define MTRAP_MSI(x)    ((x) & 0x00000008)
#define MTRAP_MTI(x)    ((x) & 0x00000080)

class ISA : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISA);

    ISA(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort"),
            isa_syscall_Port("isa_syscall_Port"),
            syscall_isa_Port("syscall_isa_Port"),
            mip_isa_Port("mip_isa_Port"),
            isaREQ(false),
            sysRES(true),
//            mip(0),
            section(fetch),
            nextsection(fetch),
            pcReg(0) {
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCU_IF> fromMemoryPort;

    // ports for communication with register file
    master_in<RegfileType> fromRegsPort;
    master_out<RegfileWriteType> toRegsPort;

    // ports for communication with syscallHandler
    blocking_out<bool> isa_syscall_Port;
    blocking_in<bool> syscall_isa_Port;

    // port for communication with mip
    master_in<unsigned int> mip_isa_Port;

    // data for communication with memory
    CUtoME_IF toMemoryData;
    MEtoCU_IF fromMemoryData;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    RegfileType regfile;

    // data for communication with syscallHandler
    bool isaREQ;
    bool sysRES;

    // data for communication with mip
//    unsigned int mip;

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

    CSRfileType csrfile;

    void run(); // thread

    //Decoding functions
    EncType getEncType(unsigned int encodedInstr) const;

    InstrType_Complete getInstrType(unsigned int encodedInstr) const;

    unsigned int getRs1Addr(unsigned int encodedInstr) const;

    unsigned int getRs2Addr(unsigned int encodedInstr) const;

    unsigned int getRdAddr(unsigned int encodedInstr) const;

    unsigned int getImmediate(unsigned int encodedInstr) const;

    ME_MaskType getMemoryMask(InstrType_Complete instr) const;

    ALUfuncType getALUfunc(InstrType_Complete instr) const;

    unsigned int readRegfile(unsigned int src, RegfileType regfile) const;

    unsigned int getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const;

    PrivInstrType getPrivInstrType(unsigned int encodedInstr) const;

    unsigned int getCSR(CSRfileType csrfile, unsigned int encodedInstr) const;

    unsigned int getCSRresult(InstrType_Complete instr, unsigned int rs1, unsigned int csr) const;

    unsigned int getBranchresult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const;

    unsigned int updateMCAUSE(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const;

    unsigned int updateMSTATUS(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const;

    unsigned int updateMEPC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mepc, unsigned int pcReg) const;

    unsigned int updatePC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mtvec, unsigned int pcReg) const;

    unsigned int getALUresult_U(unsigned int encodedInstr, unsigned int pcReg, unsigned int imm) const;
};


void ISA::run() {
    while (true) {

        // fetch next instruction 
        if (section == Sections::fetch) {
            // Set up memory access
            toMemoryData.req = ME_RD;
            toMemoryData.mask = MT_W; // always for instructions
            toMemoryData.addrIn = pcReg;
            toMemoryData.dataIn = 0;    // not relevant

            toMemoryPort->write(toMemoryData); //Send request to memory

            fromMemoryPort->read(fromMemoryData); //Read encoded instruction from memory

            encodedInstr = fromMemoryData.loadedData;
//                std::cout << "----------------------------------- instr: " << hex << (pcReg) << ", instruction: " << hex
//                          << encodedInstr << " ------- addr: " << toMemoryData.addrIn << "\n";

#ifndef NOSCAM
            /// Termination happens through a proper EBREAK or ECALL(SYS_exit)
//            if (fromMemoryData.loadedData == 0x6f) {
//                std::cout << "terminating instruction" << std::endl;
//                sc_stop();
//                wait(SC_ZERO_TIME);
//            }
#endif
            nextsection = Sections::execute;
        }

        if (section == Sections::execute) {

            // Decode instruction
            if (getEncType(encodedInstr) == ENC_R) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = readRegfile(getRs2Addr(encodedInstr), regfile);

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

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

                //Set-up PC
                pcReg = getBranchresult(encodedInstr, aluResult, pcReg);

            } else if (getEncType(encodedInstr) == ENC_S) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result

                //prepare memory access
                toMemoryData.req = ME_WR;
                toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                toMemoryData.addrIn = aluResult; // Set address (getALUresult result) for stores
                toMemoryData.dataIn = readRegfile(getRs2Addr(encodedInstr),
                                                  regfile); // Set data for stores, rs2 = source for store

                toMemoryPort->write(toMemoryData); // Store

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_U) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                aluOp1 = pcReg;
                aluOp2 = getImmediate(encodedInstr);
                aluResult = getALUresult_U(encodedInstr, aluOp1, aluOp2);

                regfileWrite.dst = getRdAddr(encodedInstr); //Compute destination
                regfileWrite.dstData = aluResult; //Compute result

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

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                //Set up write back
                regfileWrite.dst = getRdAddr(encodedInstr);
                regfileWrite.dstData = aluResult; //Compute result

                toRegsPort->write(regfileWrite); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_I_L) { // loads
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |  ID (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->read(regfile); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);

                //prepare memory access
                toMemoryData.req = ME_RD;
                toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                toMemoryData.addrIn = aluResult; // Set address (getALUresult result) for loads
                toMemoryData.dataIn = 0; // (not relevant for loads)

                regfileWrite.dst = getRdAddr(encodedInstr);

                // Request load
                toMemoryPort->write(toMemoryData);

                // Load done
                fromMemoryPort->read(fromMemoryData);

                //Set up write back
                regfileWrite.dstData = fromMemoryData.loadedData;

                //Perform write back
                toRegsPort->write(regfileWrite);

                //Set-up PC
                pcReg = pcReg + 4;

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

            } else if (getEncType(encodedInstr) == ENC_I_M) {
                /////////////////////////////////////////////////////////////////////////////
                //|  -------   |        -------       |       --------       |  --------  |//
                /////////////////////////////////////////////////////////////////////////////
                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_I_S) {
                if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRW ||
                    getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRS ||
                    getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRC) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|  ID (RF_READ)   |       ------     |     ------     |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    fromRegsPort->read(regfile); //Read register contents

                    //get operand for next csr by reading from regfile and read current csr value
                    aluOp1 = readRegfile(getRs1Addr(encodedInstr), regfile);
                    aluOp2 = getCSR(csrfile, encodedInstr);
                    aluResult = getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);

                    // write back to csr
                    if (getImmediate(encodedInstr) == MCSR_MSTATUS) {
                        csrfile.mstatus = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MIE) {
                        csrfile.mie = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MTVEC) {
                        csrfile.mtvec = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MEPC) {
                        csrfile.mepc = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MCAUSE) {
                        csrfile.mcause = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MIP) {
                        csrfile.mip = aluResult;
                    }

                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = aluOp2; //Compute result

                    toRegsPort->write(regfileWrite); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;
                } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRWI ||
                           getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRSI ||
                           getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRCI) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|    ------    |       ------      |       ------     |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    //get operand for next csr by reading from regfile and read current csr value
                    aluOp1 = getRs1Addr(encodedInstr);
                    aluOp2 = getCSR(csrfile, encodedInstr);
                    aluResult = getCSRresult(getInstrType(encodedInstr), aluOp1, aluOp2);

                    // write back to csr
                    if (getImmediate(encodedInstr) == MCSR_MSTATUS) {
                        csrfile.mstatus = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MIE) {
                        csrfile.mie = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MTVEC) {
                        csrfile.mtvec = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MEPC) {
                        csrfile.mepc = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MCAUSE) {
                        csrfile.mcause = aluResult;
                    } else if (getImmediate(encodedInstr) == MCSR_MIP) {
                        csrfile.mip = aluResult;
                    }

                    //Set up write back
                    regfileWrite.dst = getRdAddr(encodedInstr);
                    regfileWrite.dstData = aluOp2; //Compute result

                    toRegsPort->write(regfileWrite); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;
                } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_PRIV) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|    ------     |       ------      |       ------      |    ------     |//
                    /////////////////////////////////////////////////////////////////////////////
                    if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_ECALL) {
//                        isaREQ = true; // FIXME: no need for this variable
                        isa_syscall_Port->write(true);
                        // wait for syscall to finish processing the ecall
                        syscall_isa_Port->read(sysRES);
#ifndef NOSCAM
                        if(!sysRES) {
                            std::cout << "ECALL exit" << std::endl;
                            sc_stop();
                            wait(SC_ZERO_TIME);
                        }
#endif
                        pcReg = pcReg + 4;
                    } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_EBREAK) {
#ifndef NOSCAM
                        std::cout << "EBREAK" << std::endl;
                        sc_stop();
                        wait(SC_ZERO_TIME);
#endif
                    } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_MRET) {
                        csrfile.mstatus = csrfile.mstatus | 0x00000008; // set MIE
                        csrfile.mcause = 0;
                        pcReg = csrfile.mepc;
                    } else
                        pcReg = pcReg + 4;
                }
            } else {
#ifndef NOSCAM
                // Terminate if Unknown instr
                if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_UNKNOWN) {
                    std::cout << "Unknown INST" << std::endl;
                    sc_stop();
                    wait(SC_ZERO_TIME);
                }
#endif
            }

            mip_isa_Port->read(csrfile.mip); //Read mip status // FIXME: no need for the variable "mip"
            csrfile.mcause = updateMCAUSE(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause);
            csrfile.mepc = updateMEPC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mepc, pcReg);
            pcReg = updatePC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mtvec, pcReg);
            csrfile.mstatus = updateMSTATUS(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause);

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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_M) {
        return ENC_I_M;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_S) {
        return ENC_I_S;
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


InstrType_Complete ISA::getInstrType(unsigned int encodedInstr) const {
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
            return INSTR_SLTUI;
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_M) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_FENCE;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_FENCEI;
        } else {
            return INSTR_UNKNOWN;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return INSTR_PRIV;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return INSTR_CSRRW;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return INSTR_CSRRS;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return INSTR_CSRRC;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return INSTR_CSRRWI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return INSTR_CSRRSI;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return INSTR_CSRRCI;
        } else {
            return INSTR_UNKNOWN;
        }
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
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S ||
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
    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
            OPCODE_FIELD(encodedInstr) == OPCODE_U1 ||
            OPCODE_FIELD(encodedInstr) == OPCODE_U2 ||
            OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return RD_FIELD(encodedInstr);
    } else {
        return 0;
    }
}


unsigned int ISA::getImmediate(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_M ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_S ||
            OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 ||
                OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
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


ALUfuncType ISA::getALUfunc(InstrType_Complete instr) const {
    if (instr == INSTR_ADD || instr == INSTR_ADDI ||
            instr == INSTR_LB || instr == INSTR_LH || instr == INSTR_LW || instr == INSTR_LBU || instr == INSTR_LHU ||
            instr == INSTR_SB || instr == INSTR_SH || instr == INSTR_SW ||
            instr == INSTR_AUIPC) {
        return ALU_ADD;
    } else if (instr == INSTR_SUB ||
            instr == INSTR_BEQ || instr == INSTR_BNE) {
        return ALU_SUB;
    } else if (instr == INSTR_SLL || instr == INSTR_SLLI) {
        return ALU_SLL;
    } else if (instr == INSTR_SLT || instr == INSTR_SLTI ||
            instr == INSTR_BLT || instr == INSTR_BGE) {
        return ALU_SLT;
    } else if (instr == INSTR_SLTU || instr == INSTR_SLTUI ||
            instr == INSTR_BLTU || instr == INSTR_BGEU) {
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
    } else if (instr == INSTR_JALR || instr == INSTR_JAL) {
        return ALU_X;
    } else if (instr == INSTR_LUI) {
        return ALU_COPY1;
    } else return ALU_X;
}


ME_MaskType ISA::getMemoryMask(InstrType_Complete instr) const {
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
        return operand2;
    } else {
        return 0;
    }
}


PrivInstrType ISA::getPrivInstrType(unsigned int encodedInstr) const {
    if(POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_ECALL) {
        return PrivInstrType::INSTR_ECALL;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_EBREAK) {
        return PrivInstrType::INSTR_EBREAK;
//    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_URET) {
//        return PrivInstrType::INSTR_URET;
//    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_SRET) {
//        return PrivInstrType::INSTR_SRET;
    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_MRET) {
        return PrivInstrType::INSTR_MRET;
//    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_WFI) {
//        return PrivInstrType::INSTR_WFI;
//    } else if (POS_IMM_I_FIELD(encodedInstr) == PRIVCODE_SFENCEVMA) {
//        return PrivInstrType::INSTR_SFENCEVMA;
    } else {
        return PrivInstrType::INSTR_PRIV_UNKNOWN;
    }
}


unsigned int ISA::getCSR(CSRfileType csrfile, unsigned int encodedInstr) const {
    if(POS_IMM_I_FIELD(encodedInstr) == MCSR_MSTATUS) {
        return csrfile.mstatus;
    } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIE) {
        return csrfile.mie;
    } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MTVEC) {
        return csrfile.mtvec;
    } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MEPC) {
        return csrfile.mepc;
    } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MCAUSE) {
        return csrfile.mcause;
    } else if (POS_IMM_I_FIELD(encodedInstr) == MCSR_MIP) {
        return csrfile.mip;
    } else {
        return 0;
    }
}


unsigned int ISA::getCSRresult(InstrType_Complete instr, unsigned int rs1, unsigned int csr) const {
    if (instr == InstrType_Complete::INSTR_CSRRW || instr == InstrType_Complete::INSTR_CSRRWI) {
        return rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRS || instr == InstrType_Complete::INSTR_CSRRSI) {
        return csr | rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRC || instr == InstrType_Complete::INSTR_CSRRCI) {
        return csr & ((-rs1) - 1);
    } else
        return 0;
}

unsigned int ISA::updateMCAUSE(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {
    if (MSTATUS_MIE(mstatus) != 0) {
#ifdef CoreTempSensor_ON
        if ((MTRAP_ML12I(mie) != 0) && (MTRAP_ML12I(mip) != 0)) {
            return 0x8000000C; // Mcause_ML12I
        } else
#endif
        if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {
            return 0x8000000B; // Mcause_MEI
        } else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {
            return 0x80000003; // Mcause_MSI
        } else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {
            return 0x80000007; // Mcause_MTI
        } else if (mcause != 0) { // exceptions
            return mcause; // mcause should be given a value earlier with the instruction that caused the exception
        } else {
            return mcause;
        }
    } else {
        return mcause;
    }
}


unsigned int ISA::updateMSTATUS(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {
    if (MSTATUS_MIE(mstatus) != 0) {
#ifdef CoreTempSensor_ON
        if ((MTRAP_ML12I(mie) != 0) && (MTRAP_ML12I(mip) != 0)) {
            return mstatus & static_cast<unsigned int>(0xFFFFFFF7);
        } else
#endif
        if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {
            return mstatus & static_cast<unsigned int>(0xFFFFFFF7); // Setting MPIE(7) and Clearing MIE(3)
        } else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {
            return mstatus & static_cast<unsigned int>(0xFFFFFFF7);
        } else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {
            return mstatus & static_cast<unsigned int>(0xFFFFFFF7);
        } else if (mcause != 0) { // exceptions
            return mstatus & static_cast<unsigned int>(0xFFFFFFF7);
        } else {
            return mstatus;
        }
    } else {
        return mstatus;
    }
}


unsigned int ISA::updateMEPC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mepc, unsigned int pcReg) const {
    if (MSTATUS_MIE(mstatus) != 0) {
#ifdef CoreTempSensor_ON
        if ((MTRAP_ML12I(mie) != 0) && (MTRAP_ML12I(mip) != 0)) {
            return pcReg; // store the return from interrupt address
        } else
#endif
        if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {
            return pcReg; // store the return from interrupt address
        } else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {
            return pcReg; // store the return from interrupt address
        } else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {
            return pcReg; // store the return from interrupt address
        } else if (mcause != 0) { // exceptions
            return mepc; // mepc should be should be holding the address of the instruction that caused the exception from earlier
        } else {
            return mepc;
        }
    } else {
        return mepc;
    }
}


unsigned int ISA::updatePC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mtvec, unsigned int pcReg) const {
    if (MSTATUS_MIE(mstatus) != 0) {
#ifdef CoreTempSensor_ON
        if ((MTRAP_ML12I(mie) != 0) && (MTRAP_ML12I(mip) != 0)) {
            return mtvec;
        } else
#endif
        if ((MTRAP_MEI(mie) != 0) && (MTRAP_MEI(mip) != 0)) {
            return mtvec;
        } else if ((MTRAP_MSI(mie) != 0) && (MTRAP_MSI(mip) != 0)) {
            return mtvec;
        } else if ((MTRAP_MTI(mie) != 0) && (MTRAP_MTI(mip) != 0)) {
            return mtvec;
        } else if (mcause != 0) { // exceptions
            return mtvec;
        } else {
            return pcReg;
        }
    } else {
        return pcReg;
    }
}


unsigned int ISA::getBranchresult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {
    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BEQ && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BNE && aluResult != 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BLT && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BGE && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BLTU && aluResult == 1) {
        return pcReg + getImmediate(encodedInstr);
    } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_BGEU && aluResult == 0) {
        return pcReg + getImmediate(encodedInstr);
    } else {
        return pcReg + 4;
    }
}


unsigned int ISA::getALUresult_U(unsigned int encodedInstr, unsigned int pcReg, unsigned int imm) const {
    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_LUI) {
        return getALUresult(ALU_COPY1, pcReg, imm); //Compute result
    } else { //INSTR_AUIPC
        return getALUresult(ALU_ADD, pcReg, imm); //Compute result
    }
}

#endif //RISCV_ISA_H_