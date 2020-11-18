//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 13.10.18.
//

#ifndef RISCV_ISS_Interrupts_H_
#define RISCV_ISS_Interrupts_H_

#include "systemc.h"
#include "../../Interfaces/Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Defines.h"
#include "../../RISCV_commons/Utilities.h"
#include "CPU_Interfaces.h"

// Adjusts code to be appropriate for the SCAM tool
// Working ESL-Description -> //#define SCAM
// Properties can be generated -> #define SCAM
#define SCAM

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

class ISS_Interrupts : public sc_module {
public:
    //Constructor
    SC_HAS_PROCESS(ISS_Interrupts);

    ISS_Interrupts(sc_module_name name) :
            fromMemoryPort("fromMemoryPort"),
            toMemoryPort("toMemoryPort"),
            toRegsPort("toRegsPort"),
            fromRegsPort("fromRegsPort"),
            isa_ecall_Port("isa_ecall_Port"),
            ecall_isa_Port("ecall_isa_Port"),
            mip_isa_Port("mip_isa_Port"),
            isaREQ(false),
            sysRES(true),
            pcReg(0) {
        SC_THREAD(run);
    }

    // ports for communication with memory/decoder
    blocking_out<CUtoME_IF> toMemoryPort;
    blocking_in<MEtoCU_IF> fromMemoryPort;

    // ports for communication with register file
    master_in<unsigned int[32]> fromRegsPort;
    master_out<RegfileWriteType> toRegsPort;

    // ports for communication with ecallHandler
    blocking_out<bool> isa_ecall_Port;
    blocking_in<bool> ecall_isa_Port;

    // port for communication with mip
    master_in<unsigned int> mip_isa_Port;

    // data for communication with memory
    CUtoME_IF toMemoryData;
    MEtoCU_IF fromMemoryData;

    // data for communication with register file
    RegfileWriteType regfileWrite;
    unsigned int regfile[32];

    // data for communication with ecallHandler
    bool isaREQ;
    bool sysRES;

    // data for communication with mip
//    unsigned int mip;

    // ISS_Interrupts Phases
    enum Phases {
        fetch,              // fetch next instruction from memory
        execute             // decode the fetched instruction and do all the manipulations till writing back to the register file
    };
    Phases phase, nextphase;

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

    unsigned int getImmediate(unsigned int encodedInstr) const;

    ME_MaskType getMemoryMask(InstrType_Complete instr) const;

    ALUfuncType getALUfunc(InstrType_Complete instr) const;

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


void ISS_Interrupts::run() {
    nextphase = Phases::fetch;
    while (true) {
        phase = nextphase;
        // fetch next instruction 
        if (phase == Phases::fetch) {

            // Set up memory access
            toMemoryData.req = ME_RD;
            toMemoryData.mask = MT_W; // always for instructions
            toMemoryData.addrIn = pcReg;
            toMemoryData.dataIn = 0;    // not relevant

            toMemoryPort->write(toMemoryData, "FETCH_REQ"); //Send request to memory

            fromMemoryPort->read(fromMemoryData, "FETCH_DONE"); //Read encoded instruction from memory

            encodedInstr = fromMemoryData.loadedData;
//                std::cout << "----------------------------------- instr: " << hex << (pcReg) << ", instruction: " << hex
//                          << encodedInstr << " ------- addr: " << toMemoryData.addrIn << "\n";

            /// Termination happens through a proper EBREAK or ECALL(SYS_exit)

            nextphase = Phases::execute;
        }

        if (phase == Phases::execute) {

            // Decode instruction
            if (getEncType(encodedInstr) == ENC_R) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_R"); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = regfile[RS1_FIELD(encodedInstr)];
                aluOp2 = regfile[RS2_FIELD(encodedInstr)];

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                //Set up write back
                regfileWrite.dst = RD_FIELD(encodedInstr);
                regfileWrite.dstData = aluResult;

                toRegsPort->master_write(regfileWrite, "Write_ENC_R"); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_B) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_B"); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = regfile[RS1_FIELD(encodedInstr)];
                aluOp2 = regfile[RS2_FIELD(encodedInstr)];

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                //Set-up PC
                pcReg = getBranchresult(encodedInstr, aluResult, pcReg);

            } else if (getEncType(encodedInstr) == ENC_S) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |    ---------    |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_S"); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = regfile[RS1_FIELD(encodedInstr)];
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2); //Compute result

                //prepare memory access
                toMemoryData.req = ME_WR;
                toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                toMemoryData.addrIn = aluResult; // Set address (getALUresult result) for stores
                toMemoryData.dataIn = regfile[RS2_FIELD(encodedInstr)];// Set data for stores, rs2 = source for store

                toMemoryPort->write(toMemoryData, "STORE"); // Store
                //fromMemoryPort->read(fromMemoryData, "STORE");
                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_U) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                aluOp1 = pcReg;
                aluOp2 = getImmediate(encodedInstr);
                aluResult = getALUresult_U(encodedInstr, aluOp1, aluOp2);

                regfileWrite.dst = RD_FIELD(encodedInstr); //Compute destination
                regfileWrite.dstData = aluResult; //Compute result

                toRegsPort->master_write(regfileWrite, "Write_ENC_U"); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|        ID       |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                //Set up write back
                regfileWrite.dst = RD_FIELD(encodedInstr);
                regfileWrite.dstData = pcReg + 4; //Compute result

                toRegsPort->master_write(regfileWrite, "Write_ENC_J"); //Perform write back

                //Set-up PC
                pcReg = pcReg + getImmediate(encodedInstr);

            } else if (getEncType(encodedInstr) == ENC_I_I) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_I_I"); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = regfile[RS1_FIELD(encodedInstr)];
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(getALUfunc(getInstrType(encodedInstr)), aluOp1, aluOp2); //Compute result

                //Set up write back
                regfileWrite.dst = RD_FIELD(encodedInstr);
                regfileWrite.dstData = aluResult; //Compute result

                toRegsPort->master_write(regfileWrite, "Write_ENC_I_I"); //Perform write back

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_I_L) { // loads
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |        EX       |       MEM       |  ID (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_I_L"); //Read register contents

                //Set-up operands for alu by reading from regfile
                aluOp1 = regfile[RS1_FIELD(encodedInstr)];
                aluOp2 = getImmediate(encodedInstr);

                aluResult = getALUresult(ALU_ADD, aluOp1, aluOp2);

                //prepare memory access
                toMemoryData.req = ME_RD;
                toMemoryData.mask = getMemoryMask(getInstrType(encodedInstr)); // set memory access mask
                toMemoryData.addrIn = aluResult; // Set address (getALUresult result) for loads
                toMemoryData.dataIn = 0; // (not relevant for loads)

                regfileWrite.dst = RD_FIELD(encodedInstr);

                // Request load
                toMemoryPort->write(toMemoryData, "LOAD_REQ");

                // Load done
                fromMemoryPort->read(fromMemoryData, "LOAD_DONE");

                //Set up write back
                regfileWrite.dstData = fromMemoryData.loadedData;

                //Perform write back
                toRegsPort->master_write(regfileWrite, "Write_ENC_I_L");

                //Set-up PC
                pcReg = pcReg + 4;

            } else if (getEncType(encodedInstr) == ENC_I_J) {
                /////////////////////////////////////////////////////////////////////////////
                //|  ID (RF_READ)   |    ---------    |    ---------    |  WB (RF_WRITE)  |//
                /////////////////////////////////////////////////////////////////////////////
                fromRegsPort->master_read_array(regfile, "Read_ENC_I_J"); //Read register contents

                //Set up write back
                regfileWrite.dst = RD_FIELD(encodedInstr);
                regfileWrite.dstData = pcReg + 4; //Compute result

                //Perform write back
                toRegsPort->master_write(regfileWrite, "Write_ENC_I_J");

                //Set-up PC
                pcReg = regfile[RS1_FIELD(encodedInstr)] + getImmediate(encodedInstr);

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
                    fromRegsPort->master_read_array(regfile, "Read_ENC_I_S"); //Read register contents

                    //get operand for next csr by reading from regfile and read current csr value
                    aluOp1 = regfile[RS1_FIELD(encodedInstr)];
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
                    regfileWrite.dst = RD_FIELD(encodedInstr);
                    regfileWrite.dstData = aluOp2; //Compute result

                    toRegsPort->master_write(regfileWrite, "Write_ENC_I_S"); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;
                } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRWI ||
                           getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRSI ||
                           getInstrType(encodedInstr) == InstrType_Complete::INSTR_CSRRCI) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|    ------    |       ------      |       ------     |  WB (RF_WRITE)  |//
                    /////////////////////////////////////////////////////////////////////////////
                    //get operand for next csr by reading from regfile and read current csr value
                    aluOp1 = RS1_FIELD(encodedInstr);
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
                    regfileWrite.dst = RD_FIELD(encodedInstr);
                    regfileWrite.dstData = aluOp2; //Compute result

                    toRegsPort->master_write(regfileWrite, "Write_ENC_IS_S_CSRRI"); //Perform write back

                    //Set-up PC
                    pcReg = pcReg + 4;
                } else if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_PRIV) {
                    /////////////////////////////////////////////////////////////////////////////
                    //|    ------     |       ------      |       ------      |    ------     |//
                    /////////////////////////////////////////////////////////////////////////////
                    if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_ECALL) {
//                        isaREQ = true; // FIXME: no need for this variable
                        isa_ecall_Port->write(true, "ECALL_REQ");
                        // wait for ecall to finish processing the ecall
                        ecall_isa_Port->read(sysRES, "ECALL_DONE");
#ifndef SCAM
                        if(!sysRES) {
                            std::cout << "ECALL exit" << std::endl;
                            sc_stop();
                            wait(WAIT_TIME, SC_PS);
//                            wait(SC_ZERO_TIME);
                        }
#endif
                        pcReg = pcReg + 4;
                    } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_EBREAK) {
#ifndef SCAM
                        std::cout << "EBREAK" << std::endl;
                        sc_stop();
                        wait(WAIT_TIME, SC_PS);
//                        wait(SC_ZERO_TIME);
#endif
                    } else if (getPrivInstrType(encodedInstr) == PrivInstrType::INSTR_MRET) {
                        csrfile.mstatus = csrfile.mstatus | 0x00000008; // set MIE
                        csrfile.mcause = 0;
                        pcReg = csrfile.mepc;
                    } else
                        pcReg = pcReg + 4;
                }
            } else {
#ifndef SCAM
                // Terminate if Unknown instr
                if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_UNKNOWN) {
                    std::cout << "Unknown INST" << std::endl;
                    sc_stop();
                    wait(WAIT_TIME, SC_PS);
//                    wait(SC_ZERO_TIME);
                }
#endif
            }

            mip_isa_Port->master_read(csrfile.mip, "Read_MIP"); //Read mip status // FIXME: no need for the variable "mip"
            csrfile.mcause = updateMCAUSE(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause);
            csrfile.mepc = updateMEPC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mepc, pcReg);
            pcReg = updatePC(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause, csrfile.mtvec, pcReg);
            csrfile.mstatus = updateMSTATUS(csrfile.mstatus, csrfile.mie, csrfile.mip, csrfile.mcause);

            nextphase = Phases::fetch; // Fetch next instruction
        }
    }
}


EncType ISS_Interrupts::getEncType(unsigned int encodedInstr) const {
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


InstrType_Complete ISS_Interrupts::getInstrType(unsigned int encodedInstr) const {
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

unsigned int ISS_Interrupts::getImmediate(unsigned int encodedInstr) const {
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


ALUfuncType ISS_Interrupts::getALUfunc(InstrType_Complete instr) const {
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


ME_MaskType ISS_Interrupts::getMemoryMask(InstrType_Complete instr) const {
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

unsigned int ISS_Interrupts::getALUresult(ALUfuncType aluFunction, unsigned int operand1, unsigned int operand2) const {
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


PrivInstrType ISS_Interrupts::getPrivInstrType(unsigned int encodedInstr) const {
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


unsigned int ISS_Interrupts::getCSR(CSRfileType csrfile, unsigned int encodedInstr) const {
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


unsigned int ISS_Interrupts::getCSRresult(InstrType_Complete instr, unsigned int rs1, unsigned int csr) const {
    if (instr == InstrType_Complete::INSTR_CSRRW || instr == InstrType_Complete::INSTR_CSRRWI) {
        return rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRS || instr == InstrType_Complete::INSTR_CSRRSI) {
        return csr | rs1;
    } else if (instr == InstrType_Complete::INSTR_CSRRC || instr == InstrType_Complete::INSTR_CSRRCI) {
        return csr & ((-rs1) - 1);
    } else
        return 0;
}

unsigned int ISS_Interrupts::updateMCAUSE(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {
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


unsigned int ISS_Interrupts::updateMSTATUS(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause) const {
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


unsigned int ISS_Interrupts::updateMEPC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mepc, unsigned int pcReg) const {
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


unsigned int ISS_Interrupts::updatePC(unsigned int mstatus, unsigned int mie, unsigned int mip, unsigned int mcause, unsigned int mtvec, unsigned int pcReg) const {
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


unsigned int ISS_Interrupts::getBranchresult(unsigned int encodedInstr, unsigned int aluResult, unsigned int pcReg) const {
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


unsigned int ISS_Interrupts::getALUresult_U(unsigned int encodedInstr, unsigned int pcReg, unsigned int imm) const {
    if (getInstrType(encodedInstr) == InstrType_Complete::INSTR_LUI) {
        return getALUresult(ALU_COPY1, pcReg, imm); //Compute result
    } else { //INSTR_AUIPC
        return getALUresult(ALU_ADD, pcReg, imm); //Compute result
    }
}

#endif //RISCV_ISS_Interrupts_H_