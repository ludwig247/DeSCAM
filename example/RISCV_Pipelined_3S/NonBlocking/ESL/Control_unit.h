//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 29 Jan, 2019
//

#ifndef PROJECT_CONTROL_PATH_H
#define PROJECT_CONTROL_PATH_H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../RISCV_commons/Memory_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"
#include "../../RISCV_commons/Defines.h"

// Adjusts code to be appropriate for the SCAM tool
// 0 : Working ESL-Description
// 1 : Properties can be generated
#define SCAM 0

class Control_unit : public sc_module {
public:

    SC_HAS_PROCESS(Control_unit);

    Control_unit(sc_module_name name) :
            CUtoME_port("CUtoME_port"),
            MEtoCU_port("MEtoCU_port"),
            CUtoRF_port("CUtoRF_port"),
            RFtoCU_port("RFtoCU_port"),
            section(instrFetch_write),
            nextsection(instrFetch_write),
            pc(0)
    {
        SC_THREAD(run);
    }

    blocking_out<CUtoME_IF> CUtoME_port;
    blocking_in<MEtoCU_IF> MEtoCU_port;

    master_out<CUtoRF_IF> CUtoRF_port;
    master_in<RFtoCU_IF> RFtoCU_port;

    CUtoME_IF CUtoME_data;
    MEtoCU_IF MEtoCU_data;

    CUtoRF_IF CUtoRF_data;
    RFtoCU_IF RFtoCU_data;

    DEtoCU_IF DEtoCU_data;

    CUtoAL_IF CUtoAL_data;
    
    ControlSignals_s2 CS_2_s2;
    ControlSignals_s3 CS_3_s2;
    ControlSignals_s3 CS_3_s3;

    DataSignals_s2 DS_s2;
    DataSignals_s3 DS_s3;

    enum Sections {
        instrFetch_write, instrFetch_read, instrDecode, readRegfile, execute, writeBack, setPipelineSignals, updatePC, memAccess_write, memAccess_read
    };

    Sections section, nextsection;

    unsigned int encodedInstr;
    unsigned int loadedData;
    unsigned int reg1content_s1;
    unsigned int reg2content_s1;
    unsigned int pc;

    bool read_sync, write_sync;

    void run(); // thread
    
    PC_SelType          getPCsel(unsigned int encodedInstr) const;
    unsigned int        getImm(unsigned int encodedInstr) const;
    EncType             getEncType(unsigned int encodedInstr) const;
    InstrType           getInstrType(unsigned int encodedInstr) const;
    unsigned int        getRegRs1Addr(unsigned int encodedInstr) const;
    unsigned int        getRegRs2Addr(unsigned int encodedInstr) const;
    unsigned int        getRegRdAddr(unsigned int encodedInstr) const;
    ALUfuncType         getALUfunc(unsigned int encodedInstr) const;
    AL_OperandSelType   getALUop1Sel(unsigned int encodedInstr) const;
    AL_OperandSelType   getALUop2Sel(unsigned int encodedInstr) const;
    bool                getRegfileWriteReq(unsigned int encodedInstr) const;
    RF_WriteDataSelType getwriteDataSel(unsigned int encodedInstr) const;
    ME_MaskType         getDmemMask(unsigned int encodedInstr) const;

    bool         getBranchEvaluation(InstrType instrType, unsigned int reg1Content, unsigned int reg2Content) const;
    unsigned int getPC(PC_SelType pcSel, unsigned int imm, bool branchTaken, unsigned int reg1Content, unsigned int pcReg) const;
    unsigned int getRegContent(unsigned int src, RFtoCU_IF regfile) const;
    unsigned int regContentFwdUnit(unsigned int srcAddr, unsigned int dstAddr_s3, EncType encType_s3, unsigned int dstAddr_s2, EncType encType_s2, unsigned int loadedData, unsigned int pc_s3, unsigned int pc_s2, unsigned int aluResult_s3, unsigned int aluResult_s2, unsigned int regContent) const;
    unsigned int getALUoperand(AL_OperandSelType aluOpSel, unsigned int regContent, unsigned int imm, unsigned int pc) const;
    unsigned int getALUresult(CUtoAL_IF CUtoAL_data) const;
    unsigned int getWBdata(RF_WriteDataSelType wbSel_s3, unsigned int aluResult_s3, unsigned int loadedData, unsigned int pc_s3) const;
};


void Control_unit::run() {

    while (true) {

        if (section == instrFetch_write) {

            CUtoME_data.req = ME_RD;
            CUtoME_data.mask = MT_W;
            CUtoME_data.addrIn = pc;
            CUtoME_data.dataIn = 0;

            write_sync = CUtoME_port->nb_write(CUtoME_data);

            if (CS_3_s3.regfileWrite) {

                CUtoRF_data.dst = DS_s3.regRdAddr;
                CUtoRF_data.dstData = getWBdata(CS_3_s3.writeDataSel, DS_s3.aluResult, loadedData, DS_s3.pc);

                CUtoRF_port->write(CUtoRF_data);
            }

            if (!(DS_s3.encType == ENC_I_L && DS_s2.encType == ENC_I_L)) {

                CUtoAL_data.aluFunc = CS_2_s2.aluFunc;
                CUtoAL_data.aluOp1 = getALUoperand(CS_2_s2.aluOp1Sel, DS_s2.reg1content, DS_s2.imm, DS_s2.pc);
                CUtoAL_data.aluOp2 = getALUoperand(CS_2_s2.aluOp2Sel, DS_s2.reg2content, DS_s2.imm, DS_s2.pc);

                CS_3_s3.regfileWrite = CS_3_s2.regfileWrite;
                CS_3_s3.writeDataSel = CS_3_s2.writeDataSel;

                DS_s3.encType = DS_s2.encType;
                DS_s3.regRdAddr = DS_s2.regRdAddr;
                DS_s3.aluResult = getALUresult(CUtoAL_data);
                DS_s3.pc = DS_s2.pc;
            }

            if (write_sync) {
                nextsection = instrFetch_read;
            }
        }

        if (section == instrFetch_read) {

            read_sync = MEtoCU_port->nb_read(MEtoCU_data);

#if SCAM == 0
            // Terminate if:
            if (MEtoCU_data.loadedData == 0X00100073) {

#ifdef LOGTOFILE
                cout << "@CU: End of program... Terminating!" << endl;
#endif
                sc_stop();
                wait(SC_ZERO_TIME);
            }
#endif
            if (read_sync) {
                nextsection = instrDecode;
            } else {

                if (CS_3_s3.regfileWrite) {

                    CUtoRF_data.dst = DS_s3.regRdAddr;
                    CUtoRF_data.dstData = getWBdata(CS_3_s3.writeDataSel, DS_s3.aluResult, loadedData, DS_s3.pc);

                    CUtoRF_port->write(CUtoRF_data);
                }

                CUtoAL_data.aluFunc = CS_2_s2.aluFunc;
                CUtoAL_data.aluOp1 = getALUoperand(CS_2_s2.aluOp1Sel, DS_s2.reg1content, DS_s2.imm, DS_s2.pc);
                CUtoAL_data.aluOp2 = getALUoperand(CS_2_s2.aluOp2Sel, DS_s2.reg2content, DS_s2.imm, DS_s2.pc);

                CS_3_s3.regfileWrite = CS_3_s2.regfileWrite;
                CS_3_s3.writeDataSel = CS_3_s2.writeDataSel;

                DS_s3.encType = DS_s2.encType;
                DS_s3.regRdAddr = DS_s2.regRdAddr;
                DS_s3.aluResult = getALUresult(CUtoAL_data);
                DS_s3.pc = DS_s2.pc;
            }
        }

        if (section == instrDecode) {

            encodedInstr = MEtoCU_data.loadedData;

            DEtoCU_data.pcSel_s1 = getPCsel(encodedInstr);
            DEtoCU_data.imm_s1 = getImm(encodedInstr);
            DEtoCU_data.encType_s1 = getEncType(encodedInstr);
            DEtoCU_data.instrType_s1 = getInstrType(encodedInstr);
            DEtoCU_data.regRs1Addr_s1 = getRegRs1Addr(encodedInstr);
            DEtoCU_data.regRs2Addr_s1 = getRegRs2Addr(encodedInstr);
            DEtoCU_data.regRdAddr_s1 = getRegRdAddr(encodedInstr);
            DEtoCU_data.aluFunc_s2 = getALUfunc(encodedInstr);
            DEtoCU_data.aluOp1Sel_s2 = getALUop1Sel(encodedInstr);
            DEtoCU_data.aluOp2Sel_s2 = getALUop2Sel(encodedInstr);
            DEtoCU_data.regfileWrite_s3 = getRegfileWriteReq(encodedInstr);
            DEtoCU_data.writeDataSel_s3 = getwriteDataSel(encodedInstr);
            DEtoCU_data.dmemMask = getDmemMask(encodedInstr);

#ifdef LOGTOFILE
            cout << "S2: @DE: Decoding instr 0x" << hex << encodedInstr << ", InstrType = " << stringInstrType(DEtoCU_data.instrType_s1) << endl;
            cout << "S2: @DE: Immediate = 0x" << hex << DEtoCU_data.imm_s1 << "(hex) = " << dec << DEtoCU_data.imm_s1 << "(dec)" << endl;
#endif

            nextsection = execute;
        }

        if (section == execute) {

            CUtoAL_data.aluFunc = CS_2_s2.aluFunc;
            CUtoAL_data.aluOp1 = getALUoperand(CS_2_s2.aluOp1Sel, DS_s2.reg1content, DS_s2.imm, DS_s2.pc);
            CUtoAL_data.aluOp2 = getALUoperand(CS_2_s2.aluOp2Sel, DS_s2.reg2content, DS_s2.imm, DS_s2.pc);

#ifdef LOGTOFILE
            if (CUtoAL_data.aluFunc != ALU_X) {
                cout << "S3: @AL: Operand1 = 0x" << hex << CUtoAL_data.aluOp1 << "(hex) = " << dec << CUtoAL_data.aluOp1 << "(dec), Operand2 = 0x" << hex << CUtoAL_data.aluOp2
                     << "(hex) = " << dec << CUtoAL_data.aluOp2 << "(dec)" << endl;
                cout << "S3: @AL: Result = 0x" << hex << getALUresult(CUtoAL_data) << "(hex) = " << dec << getALUresult(CUtoAL_data) << "(dec)" << endl;
            }
#endif

            nextsection = readRegfile;
        }

        if (section == readRegfile) {

            RFtoCU_port->read(RFtoCU_data);

            reg1content_s1 = regContentFwdUnit(DEtoCU_data.regRs1Addr_s1, DS_s3.regRdAddr, DS_s3.encType, DS_s2.regRdAddr, DS_s2.encType, loadedData, DS_s3.pc, DS_s2.pc, DS_s3.aluResult, getALUresult(CUtoAL_data), getRegContent(DEtoCU_data.regRs1Addr_s1, RFtoCU_data));
            reg2content_s1 = regContentFwdUnit(DEtoCU_data.regRs2Addr_s1, DS_s3.regRdAddr, DS_s3.encType, DS_s2.regRdAddr, DS_s2.encType, loadedData, DS_s3.pc, DS_s2.pc, DS_s3.aluResult, getALUresult(CUtoAL_data), getRegContent(DEtoCU_data.regRs2Addr_s1, RFtoCU_data));

#ifdef LOGTOFILE
            cout << "S1: @RF: reg1content_s1 = 0x" << hex << reg1content_s1 << "(hex) = " << dec << reg1content_s1 << "(dec), reg2content_s1 = 0x" << hex << reg2content_s1
                     << "(hex) = " << dec << reg2content_s1 << "(dec)" << endl;
#endif

            nextsection = writeBack;
        }

        if (section == writeBack) {

#ifdef LOGTOFILE
            cout << "WB:                                                                                           "
                     << setw(7) << stringInstrType(DEtoCU_data.instrType_s1) << "  :  " << setw(7) << stringInstrType(DS_s2.instrType) << "  :  "
                     << setw(7) << stringInstrType(DS_s3.instrType) << endl;
            cout << "WB:                                                                                           "
                     << hex << "0x" << setw(5) << pc << "  :  " << "0x" << setw(5) << DS_s2.pc << "  :  "
                            << "0x" << setw(5) << DS_s3.pc << endl;
#endif

            if (CS_3_s3.regfileWrite) {

                CUtoRF_data.dst = DS_s3.regRdAddr;
                CUtoRF_data.dstData = getWBdata(CS_3_s3.writeDataSel, DS_s3.aluResult, loadedData, DS_s3.pc);

                CUtoRF_port->write(CUtoRF_data);
            }
            
            nextsection = setPipelineSignals;
        }

        if (section == setPipelineSignals) {

#ifdef LOGTOFILE
            DS_s3.instrType = DS_s2.instrType;
            DS_s2.instrType = DEtoCU_data.instrType_s1;
#endif

            CS_3_s3.regfileWrite = CS_3_s2.regfileWrite;
            CS_3_s3.writeDataSel = CS_3_s2.writeDataSel;

            CS_2_s2.aluFunc = DEtoCU_data.aluFunc_s2;
            CS_2_s2.aluOp1Sel = DEtoCU_data.aluOp1Sel_s2;
            CS_2_s2.aluOp2Sel = DEtoCU_data.aluOp2Sel_s2;
            CS_3_s2.regfileWrite = DEtoCU_data.regfileWrite_s3;
            CS_3_s2.writeDataSel = DEtoCU_data.writeDataSel_s3;

            DS_s3.encType = DS_s2.encType;
            DS_s3.regRdAddr = DS_s2.regRdAddr;
            DS_s3.aluResult = getALUresult(CUtoAL_data);
            DS_s3.pc = DS_s2.pc;

            DS_s2.encType = DEtoCU_data.encType_s1;
            DS_s2.regRdAddr = DEtoCU_data.regRdAddr_s1;
            DS_s2.reg1content = reg1content_s1;
            DS_s2.reg2content = reg2content_s1;
            DS_s2.imm = DEtoCU_data.imm_s1;
            DS_s2.pc = pc;

            nextsection = updatePC;
        }

        if (section == updatePC) {

            pc = getPC(DEtoCU_data.pcSel_s1, DEtoCU_data.imm_s1, getBranchEvaluation(DEtoCU_data.instrType_s1, reg1content_s1, reg2content_s1), reg1content_s1, pc);

            if (DEtoCU_data.encType_s1 == ENC_S) {

                CUtoME_data.req = ME_WR;
                CUtoME_data.dataIn = reg2content_s1;
                CUtoME_data.mask = DEtoCU_data.dmemMask;
                CUtoME_data.addrIn = reg1content_s1 + DEtoCU_data.imm_s1;
                nextsection = memAccess_write;

            } else if (DEtoCU_data.encType_s1 == ENC_I_L) {

                CUtoME_data.req = ME_RD;
                CUtoME_data.dataIn = 0;
                CUtoME_data.mask = DEtoCU_data.dmemMask;
                CUtoME_data.addrIn = reg1content_s1 + DEtoCU_data.imm_s1;
                nextsection = memAccess_write;

            } else {
                nextsection = instrFetch_write;
            }
        }

        if (section == memAccess_write) {

            write_sync = CUtoME_port->nb_write(CUtoME_data);

            if (CS_3_s3.regfileWrite) {

                CUtoRF_data.dst = DS_s3.regRdAddr;
                CUtoRF_data.dstData = getWBdata(CS_3_s3.writeDataSel, DS_s3.aluResult, loadedData, DS_s3.pc);

                CUtoRF_port->write(CUtoRF_data);
            }

            if (write_sync) {
                nextsection = memAccess_read;
            }
        }

        if (section == memAccess_read) {

            MEtoCU_port->read(MEtoCU_data);

            loadedData = MEtoCU_data.loadedData;

            if (CS_3_s3.regfileWrite) {

                CUtoRF_data.dst = DS_s3.regRdAddr;
                CUtoRF_data.dstData = getWBdata(CS_3_s3.writeDataSel, DS_s3.aluResult, loadedData, DS_s3.pc);

                CUtoRF_port->write(CUtoRF_data);
            }

            CS_3_s3.regfileWrite = CS_3_s2.regfileWrite;
            CS_3_s3.writeDataSel = CS_3_s2.writeDataSel;
            CS_3_s2.regfileWrite = false;

            DS_s3.encType = DS_s2.encType;
            DS_s3.regRdAddr = DS_s2.regRdAddr;
            DS_s3.pc = DS_s2.pc;
            DS_s2.regRdAddr = 0;

            nextsection = instrFetch_write;
        }

        section = nextsection;
    }
}


PC_SelType Control_unit::getPCsel(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return PC_4;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        return PC_JR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return PC_BR;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return PC_J;
    } else {
        return PC_4;
    }
}

unsigned int Control_unit::getImm(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_J || OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_I_FIELD(encodedInstr);
        } else {
            return POS_IMM_I_FIELD(encodedInstr);
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_S_FIELD(encodedInstr);
        } else {
            return POS_IMM_S_FIELD(encodedInstr);
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_B_FIELD(encodedInstr);
        } else {
            return POS_IMM_B_FIELD(encodedInstr);
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return IMM_U_FIELD(encodedInstr);
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_J_FIELD(encodedInstr);
        } else {
            return POS_IMM_J_FIELD(encodedInstr);
        }
    } else {
        return 0;
    }
}

EncType Control_unit::getEncType(unsigned int encodedInstr) const {

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

InstrType Control_unit::getInstrType(unsigned int encodedInstr) const {

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

unsigned int Control_unit::getRegRs1Addr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS1_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

unsigned int Control_unit::getRegRs2Addr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RS2_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

unsigned int Control_unit::getRegRdAddr(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return RD_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

ALUfuncType Control_unit::getALUfunc(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return ALU_ADD;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return ALU_SUB;
            } else {
                return ALU_X;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return ALU_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return ALU_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return ALU_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return ALU_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return ALU_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return ALU_SRA;
            } else {
                return ALU_X;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return ALU_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return ALU_AND;
        } else {
            return ALU_X;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return ALU_ADD;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return ALU_SLL;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return ALU_SLT;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x03) {
            return ALU_SLTU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return ALU_XOR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            if (FUNCT7_FIELD(encodedInstr) == 0x00) {
                return ALU_SRL;
            } else if (FUNCT7_FIELD(encodedInstr) == 0x20) {
                return ALU_SRA;
            } else {
                return ALU_X;
            }
        } else if (FUNCT3_FIELD(encodedInstr) == 0x06) {
            return ALU_OR;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x07) {
            return ALU_AND;
        } else {
            return ALU_X;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return ALU_COPY1;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return ALU_ADD;
    } else {
        return ALU_X;
    }
}

AL_OperandSelType Control_unit::getALUop1Sel(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I) {
        return OP_REG;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1) {
        return OP_IMM;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return OP_PC;
    } else {
        return OP_X;
    }
}

AL_OperandSelType Control_unit::getALUop2Sel(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R) {
        return OP_REG;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
               OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return OP_IMM;
    } else {
        return OP_X;
    }
}

bool Control_unit::getRegfileWriteReq(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return true;
    } else {
        return false;
    }
}

RF_WriteDataSelType Control_unit::getwriteDataSel(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return WB_ALU;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return WB_MEM;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J || OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return WB_PC4;
    } else {
        return WB_X;
    }
}

ME_MaskType Control_unit::getDmemMask(unsigned int encodedInstr) const {
    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return MT_B;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return MT_H;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return MT_W;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x04) {
            return MT_BU;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x05) {
            return MT_HU;
        } else {
            return MT_X;
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        if (FUNCT3_FIELD(encodedInstr) == 0x00) {
            return MT_B;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x01) {
            return MT_H;
        } else if (FUNCT3_FIELD(encodedInstr) == 0x02) {
            return MT_W;
        } else {
            return MT_X;
        }
    } else {
        return MT_X;
    }
}


bool Control_unit::getBranchEvaluation(InstrType instrType, unsigned int reg1Content, unsigned int reg2Content) const {

    if (instrType == InstrType::INSTR_BEQ && (reg1Content - reg2Content) == 0) {
        return true;
    } else if (instrType == InstrType::INSTR_BNE && (reg1Content - reg2Content) != 0) {
        return true;
    } else if (instrType == InstrType::INSTR_BLT && static_cast<int>(reg1Content) < static_cast<int>(reg2Content)) {
        return true;
    } else if (instrType == InstrType::INSTR_BGE && static_cast<int>(reg1Content) >= static_cast<int>(reg2Content)) {
        return true;
    } else if (instrType == InstrType::INSTR_BLTU && reg1Content < reg2Content) {
        return true;
    } else if (instrType == InstrType::INSTR_BGEU && reg1Content >= reg2Content) {
        return true;
    } else {
        return false;
    }
}

unsigned int Control_unit::getPC(PC_SelType pcSel, unsigned int imm, bool branchTaken, unsigned int reg1Content, unsigned int pcReg) const {

    if (pcSel == PC_BR) {
        if (branchTaken) {
            return pcReg + imm;
        } else {
            return pcReg + 4;
        }
    } else if (pcSel == PC_J) {
        return pcReg + imm;
    } else if (pcSel == PC_JR) {
        return reg1Content + imm;
    } else {
        return pcReg + 4;
    }
}

unsigned int Control_unit::getRegContent(unsigned int src, RFtoCU_IF regfile) const {

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

unsigned int Control_unit::regContentFwdUnit(unsigned int srcAddr, unsigned int dstAddr_s3, EncType encType_s3, unsigned int dstAddr_s2, EncType encType_s2, unsigned int loadedData, unsigned int pc_s3, unsigned int pc_s2, unsigned int aluResult_s3, unsigned int aluResult_s2, unsigned int regContent) const {

    if (srcAddr == 0) {
        return 0;
    } else if (srcAddr == dstAddr_s3 && encType_s3 == ENC_I_L) {
        return loadedData;
    } else if (srcAddr == dstAddr_s3 && srcAddr != dstAddr_s2 && (encType_s3 == ENC_I_J || encType_s3 == ENC_J)) {
        return pc_s3 + 4;
    } else if (srcAddr == dstAddr_s3 && srcAddr != dstAddr_s2) {
        return aluResult_s3;
    } else if (srcAddr == dstAddr_s2 && (encType_s2 == ENC_I_J || encType_s2 == ENC_J)) {
        return pc_s2 + 4;
    } else if (srcAddr == dstAddr_s2) {
        return aluResult_s2;
    } else {
        return regContent;
    }
}

unsigned int Control_unit::getALUoperand(AL_OperandSelType aluOpSel, unsigned int regContent, unsigned int imm, unsigned int pc) const {

    if (aluOpSel == OP_REG) {
        return regContent;
    } else if (aluOpSel == OP_IMM) {
        return imm;
    } else if (aluOpSel == OP_PC) {
        return pc;
    } else {
        return 0;
    }
}

unsigned int Control_unit::getALUresult(CUtoAL_IF CUtoAL_data) const {

    if (CUtoAL_data.aluFunc == ALU_ADD) {
        return CUtoAL_data.aluOp1 + CUtoAL_data.aluOp2;
    } else if (CUtoAL_data.aluFunc == ALU_SUB) {
        return CUtoAL_data.aluOp1 + (-CUtoAL_data.aluOp2);
    } else if (CUtoAL_data.aluFunc == ALU_AND) {
        return CUtoAL_data.aluOp1 & CUtoAL_data.aluOp2;
    } else if (CUtoAL_data.aluFunc == ALU_OR) {
        return CUtoAL_data.aluOp1 | CUtoAL_data.aluOp2;
    } else if (CUtoAL_data.aluFunc == ALU_XOR) {
        return CUtoAL_data.aluOp1 ^ CUtoAL_data.aluOp2;
    } else if (CUtoAL_data.aluFunc == ALU_SLT) {
        if (static_cast<int>(CUtoAL_data.aluOp1) < static_cast<int>(CUtoAL_data.aluOp2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (CUtoAL_data.aluFunc == ALU_SLTU) {
        if (CUtoAL_data.aluOp1 < CUtoAL_data.aluOp2) {
            return 1;
        } else {
            return 0;
        }
    } else if (CUtoAL_data.aluFunc == ALU_SLL) {
        return CUtoAL_data.aluOp1 << ((CUtoAL_data.aluOp2) & 0x1F);
    } else if (CUtoAL_data.aluFunc == ALU_SRA) {
        return static_cast<unsigned int>(static_cast<int>(CUtoAL_data.aluOp1) >> static_cast<int>(CUtoAL_data.aluOp2 & 0x1F));
    } else if (CUtoAL_data.aluFunc == ALU_SRL) {
        return CUtoAL_data.aluOp1 >> ((CUtoAL_data.aluOp2) & 0x1F);
    } else if (CUtoAL_data.aluFunc == ALU_COPY1) {
        return CUtoAL_data.aluOp1;
    } else {
        return 0;
    }
}

unsigned int Control_unit::getWBdata(RF_WriteDataSelType wbSel_s3, unsigned int aluResult_s3, unsigned int loadedData, unsigned int pc_s3) const {

    if (wbSel_s3 == WB_ALU) {
        return aluResult_s3;
    } else if (wbSel_s3 == WB_MEM) {
        return loadedData;
    } else if (wbSel_s3 == WB_PC4) {
        return pc_s3 + 4;
    } else {
        return 0;
    }
}

#endif //PROJECT_CONTROL_PATH_H
