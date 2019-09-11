//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 31 Mar, 2018
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
            CUtoDP_port("CUtoDP_port"),
            DPtoCU_port("DPtoCU_port"),
            section(memAccess),
            nextsection(memAccess),
            loadedInstr(0x13),
            encodedInstr(0),
            dmemAccess(false),
            pc(0)
    {
        SC_THREAD(run);
    }

    blocking_out<CUtoME_IF> CUtoME_port;
    blocking_in<MEtoCU_IF> MEtoCU_port;

    master_out<CUtoDP_IF> CUtoDP_port;
    master_in<DPtoCU_IF> DPtoCU_port;

    CUtoME_IF CUtoME_data;
    MEtoCU_IF MEtoCU_data;

    DEtoCU_IF DEtoCU_data;

    CUtoDP_IF CUtoDP_data;
    DPtoCU_IF DPtoCU_data;

    CUtoDP_S3 CUtoDP_3_s2;
    CUtoDP_S4 CUtoDP_4_s2;
    CUtoDP_S5 CUtoDP_5_s2;

    CUtoDP_S3 CUtoDP_3_s3;
    CUtoDP_S4 CUtoDP_4_s3;
    CUtoDP_S5 CUtoDP_5_s3;

    CUtoDP_S4 CUtoDP_4_s4;
    CUtoDP_S5 CUtoDP_5_s4;

    CUtoDP_S5 CUtoDP_5_s5;

    enum Sections {
        memAccess, decodeInstr, setStallSignals, setDataPathSignals, updatePC, setPipelineSignals, setDmemAccess
    };

    Sections section, nextsection;

    InstrType prevInstrType;
    EncType encType_prev2;
    EncType encType_prev3;
    PC_SelType prevPCsel;
    PC_SelType currPCsel;

    unsigned int loadedInstr;
    unsigned int encodedInstr;
    unsigned int prevReg1Content;
    unsigned int currReg1Content;
    unsigned int prevPCimm;
    unsigned int currPCimm;
    unsigned int regRdAddr_prev2;
    unsigned int regRdAddr_prev3;
    unsigned int pc;

    bool stall;
    bool stallOnce;
    bool stallTwice;
    bool dmemAccess;
    bool flush;
    bool flushDmemAccess;
    bool flushDmemAccessTemp;
    bool prevDmemAccess;
    bool prevJalrInstr;
    bool currBranchTaken;

    void run(); // thread

    PC_SelType          getPCsel(unsigned int encodedInstr) const;
    unsigned int        getImmS2(unsigned int encodedInstr) const;
    EncType             getEncType(unsigned int encodedInstr) const;
    InstrType           getInstrType(unsigned int encodedInstr) const;
    RF_RD_AccessType    getRegFileReqS2(unsigned int encodedInstr) const;
    unsigned int        getRegRs1Addr(unsigned int encodedInstr) const;
    unsigned int        getRegRs2Addr(unsigned int encodedInstr) const;
    unsigned int        getRegRdAddr(unsigned int encodedInstr) const;
    ALUfuncType         getALUfunc(unsigned int encodedInstr) const;
    AL_OperandSelType   getALUop1Sel(unsigned int encodedInstr) const;
    AL_OperandSelType   getALUop2Sel(unsigned int encodedInstr) const;
    unsigned int        getImmS5(unsigned int encodedInstr) const;
    ME_AccessType       getDmemReq(unsigned int encodedInstr) const;
    ME_MaskType         getDmemMask(unsigned int encodedInstr) const;
    RF_WR_AccessType    getRegFileReqS5(unsigned int encodedInstr) const;
    RF_WriteDataSelType getRegFileWriteDataSel(unsigned int encodedInstr) const;

    bool                getBranchEvaluation(InstrType instrType, unsigned int reg1Content, unsigned int reg2Content) const;
    bool                getStallOnce(EncType currEncType, EncType prevEncType, unsigned int regRs1Addr, unsigned int regRs2Addr, unsigned int regRdAddr) const;
    bool                getStallTwice(EncType currEncType, EncType prevEncType, unsigned int regRs1Addr, unsigned int regRs2Addr, unsigned int regRdAddr) const;
    unsigned int        getPC(PC_SelType pcSel, unsigned int imm, bool branchTaken, unsigned int reg1Content, unsigned int pcReg) const;

#ifdef LOGTOFILE
    InstrType instrType_prev2;
    InstrType instrType_prev3;
#endif

};


void Control_unit::run() {

    while (true) {

        if (section == memAccess) {

            if (dmemAccess) {

                CUtoME_data.req = DPtoCU_data.req;
                CUtoME_data.mask = DPtoCU_data.mask;
                CUtoME_data.addrIn = DPtoCU_data.addrIn;
                CUtoME_data.dataIn = DPtoCU_data.dataIn;

            } else {

                CUtoME_data.req = ME_RD;
                CUtoME_data.mask = MT_W;
                CUtoME_data.addrIn = pc;
                CUtoME_data.dataIn = 0;
            }

            CUtoME_port->write(CUtoME_data);

            MEtoCU_port->read(MEtoCU_data);

            if (dmemAccess) {
                CUtoDP_data.loadedData = MEtoCU_data.loadedData;
            } else {
                CUtoDP_data.loadedData = 0;
            }

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
            nextsection = decodeInstr;
        }

        if (section == decodeInstr) {

            if (!stall) {
                encodedInstr = loadedInstr;
                loadedInstr = MEtoCU_data.loadedData;
            }

            DEtoCU_data.pcSel_s2 = getPCsel(encodedInstr);
            DEtoCU_data.imm_s2 = getImmS2(encodedInstr);
            DEtoCU_data.encType_s2 = getEncType(encodedInstr);
            DEtoCU_data.instrType_s2 = getInstrType(encodedInstr);
            DEtoCU_data.regFileReq_s2 = getRegFileReqS2(encodedInstr);
            DEtoCU_data.regRs1Addr_s2 = getRegRs1Addr(encodedInstr);
            DEtoCU_data.regRs2Addr_s2 = getRegRs2Addr(encodedInstr);
            DEtoCU_data.regRdAddr_s2 = getRegRdAddr(encodedInstr);
            DEtoCU_data.aluFunc_s3 = getALUfunc(encodedInstr);
            DEtoCU_data.aluOp1Sel_s3 = getALUop1Sel(encodedInstr);
            DEtoCU_data.aluOp2Sel_s3 = getALUop2Sel(encodedInstr);
            DEtoCU_data.imm_s3 = getImmS5(encodedInstr);
            DEtoCU_data.dmemReq_s4 = getDmemReq(encodedInstr);
            DEtoCU_data.dmemMask_s4 = getDmemMask(encodedInstr);
            DEtoCU_data.regFileReq_s5 = getRegFileReqS5(encodedInstr);
            DEtoCU_data.regFileWriteDataSel_s5 = getRegFileWriteDataSel(encodedInstr);

#ifdef LOGTOFILE
            cout << "S2: @DE: Decoding instr 0x" << hex << encodedInstr << ", InstrType = " << stringInstrType(DEtoCU_data.instrType_s2) << endl;

            if (DEtoCU_data.encType_s2 == ENC_I_J || DEtoCU_data.encType_s2 == ENC_B || DEtoCU_data.encType_s2 == ENC_J) {
                cout << "S2: @DE: Immediate = 0x" << hex << DEtoCU_data.imm_s2 << "(hex) = "
                     << dec << DEtoCU_data.imm_s2 << "(dec)" << endl;
            } else {
                cout << "S2: @DE: Immediate = 0x" << hex << DEtoCU_data.imm_s3 << "(hex) = "
                     << dec << DEtoCU_data.imm_s3 << "(dec)" << endl;
            }
#endif

            nextsection = setStallSignals;
        }

        if (section == setStallSignals) {

            DPtoCU_port->read(DPtoCU_data);

            if (flush && dmemAccess) {
                currReg1Content = prevReg1Content;
                currBranchTaken = true;
            } else {
                currReg1Content = DPtoCU_data.reg1Content;
                currBranchTaken = getBranchEvaluation(prevInstrType, DPtoCU_data.reg1Content, DPtoCU_data.reg2Content);
            }

            if (!stall && CUtoDP_data.regRdAddr_s2 != 0) {
                stallOnce = getStallOnce(DEtoCU_data.encType_s2, CUtoDP_data.encType_s2, DEtoCU_data.regRs1Addr_s2, DEtoCU_data.regRs2Addr_s2, CUtoDP_data.regRdAddr_s2);
                stallTwice = getStallTwice(DEtoCU_data.encType_s2, CUtoDP_data.encType_s2, DEtoCU_data.regRs1Addr_s2, DEtoCU_data.regRs2Addr_s2, CUtoDP_data.regRdAddr_s2);
            }

            if (!stallOnce && !stallTwice && CUtoDP_data.encType_s2 != ENC_J && CUtoDP_data.encType_s2 != ENC_I_J && !currBranchTaken) {

                if ((DEtoCU_data.encType_s2 == ENC_I_J && encType_prev2 == ENC_I_L && DEtoCU_data.regRs1Addr_s2 == regRdAddr_prev2 && regRdAddr_prev2 != 0) ||
                    (DEtoCU_data.encType_s2 == ENC_B && encType_prev2 == ENC_I_L &&  (DEtoCU_data.regRs1Addr_s2 == regRdAddr_prev2 ||
                                                                                      DEtoCU_data.regRs2Addr_s2 == regRdAddr_prev2) && regRdAddr_prev2 != 0)   ) {
                    stallOnce = true;
                } else if (prevDmemAccess &&
                           ((DEtoCU_data.encType_s2 == ENC_I_J && encType_prev3 == ENC_I_L && DEtoCU_data.regRs1Addr_s2 == regRdAddr_prev3 && regRdAddr_prev3 != 0) ||
                            (DEtoCU_data.encType_s2 == ENC_B && encType_prev3 == ENC_I_L &&  (DEtoCU_data.regRs1Addr_s2 == regRdAddr_prev3 ||
                                                                                              DEtoCU_data.regRs2Addr_s2 == regRdAddr_prev3) && regRdAddr_prev3 != 0)))
                {
                    stallOnce = true;
                } else {
                    stallOnce = false;
                }
            }

            nextsection = setDataPathSignals;
        }

        if (section == setDataPathSignals) {

            if (dmemAccess) {
                CUtoDP_data.prevDmemAccess = true;
                prevDmemAccess = true;
            } else {
                CUtoDP_data.prevDmemAccess = false;
                prevDmemAccess = false;
            }

            encType_prev3 = encType_prev2;
            regRdAddr_prev3 = regRdAddr_prev2;
            encType_prev2 = CUtoDP_data.encType_s2;
            regRdAddr_prev2 = CUtoDP_data.regRdAddr_s2;

            if (flushDmemAccess) {
                flushDmemAccessTemp = true;
            } else {
                flushDmemAccessTemp = false;
            }

            if ((CUtoDP_data.encType_s2 == ENC_J && CUtoDP_data.stallDmemAccess) || (flush && (CUtoDP_data.stallDmemAccess || dmemAccess))) {
                flushDmemAccess = true;
            } else {
                flushDmemAccess = false;
            }

            if (currBranchTaken || flushDmemAccessTemp || flush || CUtoDP_data.stallDmemAccess || stallOnce || stallTwice || CUtoDP_data.encType_s2 == ENC_J || CUtoDP_data.encType_s2 == ENC_I_J ) {

                currPCsel = PC_4;
                currPCimm = 0;

                CUtoDP_data.encType_s2 = ENC_I_I;
                prevInstrType = InstrType::INSTR_ADDI;

                CUtoDP_data.regFileReq_s2 = RF_RD_X;
                CUtoDP_data.regRs1Addr_s2 = 0;
                CUtoDP_data.regRs2Addr_s2 = 0;
                CUtoDP_data.regRdAddr_s2 = 0;

                CUtoDP_3_s2.aluFunc_s3 = ALU_X;
                CUtoDP_3_s2.aluOp1Sel_s3 = OP_X;
                CUtoDP_3_s2.aluOp2Sel_s3 = OP_X;
                CUtoDP_3_s2.imm_s3 = 0;

                CUtoDP_4_s2.dmemReq_s4 = ME_X;
                CUtoDP_4_s2.dmemMask_s4 = MT_X;

                CUtoDP_5_s2.regFileReq_s5 = RF_WR_X;
                CUtoDP_5_s2.regFileWriteDataSel_s5 = WB_X;

#ifdef LOGTOFILE
                CUtoDP_data.instrType_s2 = InstrType::INSTR_ADDI;
#endif

            } else {

                currPCsel = DEtoCU_data.pcSel_s2;
                currPCimm = DEtoCU_data.imm_s2;

                CUtoDP_data.encType_s2 = DEtoCU_data.encType_s2;
                prevInstrType = DEtoCU_data.instrType_s2;

                CUtoDP_data.regFileReq_s2 = DEtoCU_data.regFileReq_s2;
                CUtoDP_data.regRs1Addr_s2 = DEtoCU_data.regRs1Addr_s2;
                CUtoDP_data.regRs2Addr_s2 = DEtoCU_data.regRs2Addr_s2;
                CUtoDP_data.regRdAddr_s2 = DEtoCU_data.regRdAddr_s2;

                CUtoDP_3_s2.aluFunc_s3 = DEtoCU_data.aluFunc_s3;
                CUtoDP_3_s2.aluOp1Sel_s3 = DEtoCU_data.aluOp1Sel_s3;
                CUtoDP_3_s2.aluOp2Sel_s3 = DEtoCU_data.aluOp2Sel_s3;
                CUtoDP_3_s2.imm_s3 = DEtoCU_data.imm_s3;

                CUtoDP_4_s2.dmemReq_s4 = DEtoCU_data.dmemReq_s4;
                CUtoDP_4_s2.dmemMask_s4 = DEtoCU_data.dmemMask_s4;

                CUtoDP_5_s2.regFileReq_s5 = DEtoCU_data.regFileReq_s5;
                CUtoDP_5_s2.regFileWriteDataSel_s5 = DEtoCU_data.regFileWriteDataSel_s5;

#ifdef LOGTOFILE
                CUtoDP_data.instrType_s2 = DEtoCU_data.instrType_s2;
#endif
            }

            CUtoDP_data.aluFunc_s3 = CUtoDP_3_s3.aluFunc_s3;
            CUtoDP_data.aluOp1Sel_s3 = CUtoDP_3_s3.aluOp1Sel_s3;
            CUtoDP_data.aluOp2Sel_s3 = CUtoDP_3_s3.aluOp2Sel_s3;
            CUtoDP_data.imm_s3 = CUtoDP_3_s3.imm_s3;

            CUtoDP_data.dmemReq_s4 = CUtoDP_4_s4.dmemReq_s4;
            CUtoDP_data.dmemMask_s4 = CUtoDP_4_s4.dmemMask_s4;

            CUtoDP_data.regFileReq_s5 = CUtoDP_5_s5.regFileReq_s5;
            CUtoDP_data.regFileWriteDataSel_s5 = CUtoDP_5_s5.regFileWriteDataSel_s5;

            CUtoDP_port->write(CUtoDP_data);

            nextsection = updatePC;
        }

        if (section == updatePC) {

            if (CUtoDP_data.stallDmemAccess || stallOnce || stallTwice) {
                stall = true;
            } else {
                stall = false;
            }

            if (prevJalrInstr || (currBranchTaken)) {
                flush = true;
                prevReg1Content = DPtoCU_data.reg1Content;
                currPCsel = prevPCsel;
                currPCimm = prevPCimm;
            } else {
                flush = false;
                prevReg1Content = 0;
            }

            if ((CUtoDP_data.encType_s2 == ENC_I_J || CUtoDP_data.encType_s2 == ENC_B)) {
                
                prevPCsel = DEtoCU_data.pcSel_s2;
                prevPCimm = DEtoCU_data.imm_s2;
                currPCsel = PC_4;
                currPCimm = 0;

                if (CUtoDP_data.encType_s2 == ENC_I_J) {
                    prevJalrInstr = true;
                } else {
                    prevJalrInstr = false;
                }

            } else {
                prevJalrInstr = false;
            }

            if (!stall) {

                CUtoDP_data.pc_s2 = pc;

                pc = getPC(currPCsel, currPCimm, currBranchTaken, currReg1Content, CUtoDP_data.pc_s2);
            }

#ifdef LOGTOFILE
            instrType_prev3 = instrType_prev2;
            instrType_prev2 = prevInstrType;
#endif

            nextsection = setPipelineSignals;
        }

        if (section == setPipelineSignals) {

            if(!CUtoDP_data.stallDmemAccess) {

                CUtoDP_5_s5.regFileReq_s5 = CUtoDP_5_s4.regFileReq_s5;
                CUtoDP_5_s5.regFileWriteDataSel_s5 = CUtoDP_5_s4.regFileWriteDataSel_s5;

                CUtoDP_4_s4.dmemReq_s4 = CUtoDP_4_s3.dmemReq_s4;
                CUtoDP_4_s4.dmemMask_s4 = CUtoDP_4_s3.dmemMask_s4;
                CUtoDP_5_s4.regFileReq_s5 = CUtoDP_5_s3.regFileReq_s5;
                CUtoDP_5_s4.regFileWriteDataSel_s5 = CUtoDP_5_s3.regFileWriteDataSel_s5;

                CUtoDP_3_s3.aluFunc_s3 = CUtoDP_3_s2.aluFunc_s3;
                CUtoDP_3_s3.aluOp1Sel_s3 = CUtoDP_3_s2.aluOp1Sel_s3;
                CUtoDP_3_s3.aluOp2Sel_s3 = CUtoDP_3_s2.aluOp2Sel_s3;
                CUtoDP_3_s3.imm_s3 = CUtoDP_3_s2.imm_s3;
                CUtoDP_4_s3.dmemReq_s4 = CUtoDP_4_s2.dmemReq_s4;
                CUtoDP_4_s3.dmemMask_s4 = CUtoDP_4_s2.dmemMask_s4;
                CUtoDP_5_s3.regFileReq_s5 = CUtoDP_5_s2.regFileReq_s5;
                CUtoDP_5_s3.regFileWriteDataSel_s5 = CUtoDP_5_s2.regFileWriteDataSel_s5;
            }

            nextsection = setDmemAccess;
        }

        if (section == setDmemAccess) {

            if (CUtoDP_data.stallDmemAccess) {
                dmemAccess = true;
            } else {
                dmemAccess = false;
            }

            if ((CUtoDP_data.dmemReq_s4 == ME_RD || CUtoDP_data.dmemReq_s4 == ME_WR) && !dmemAccess) {
                CUtoDP_data.stallDmemAccess = true;
            } else {
                CUtoDP_data.stallDmemAccess = false;
            }

            if ((dmemAccess) && stallTwice) {
                stallTwice = true;
                stallOnce = false;
            } else if ((dmemAccess) && stallOnce) {
                stallOnce = true;
                stallTwice = false;
            } else if (stallTwice) {
                stallOnce = true;
                stallTwice = false;
            } else {
                stallOnce = false;
                stallTwice = false;
            }

            nextsection = memAccess;
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

unsigned int Control_unit::getImmS2(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_J) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_I_FIELD(encodedInstr);
        } else {
            return POS_IMM_I_FIELD(encodedInstr);
        }
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        if (SIGN_FIELD(encodedInstr) == 1) {
            return NEG_IMM_B_FIELD(encodedInstr);
        } else {
            return POS_IMM_B_FIELD(encodedInstr);
        }
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

RF_RD_AccessType Control_unit::getRegFileReqS2(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_B) {
        return RF_RD;
    } else {
        return RF_RD_X;
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return ALU_ADD;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return ALU_ADD;
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
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
        OPCODE_FIELD(encodedInstr) == OPCODE_S) {
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L ||
               OPCODE_FIELD(encodedInstr) == OPCODE_S   ||
               OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return OP_IMM;
    } else {
        return OP_X;
    }
}

unsigned int Control_unit::getImmS5(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
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
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_U1 || OPCODE_FIELD(encodedInstr) == OPCODE_U2) {
        return IMM_U_FIELD(encodedInstr);
    } else {
        return 0;
    }
}

ME_AccessType Control_unit::getDmemReq(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_I_L) {
        return ME_RD;
    } else if (OPCODE_FIELD(encodedInstr) == OPCODE_S) {
        return ME_WR;
    } else {
        return ME_X;
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

RF_WR_AccessType Control_unit::getRegFileReqS5(unsigned int encodedInstr) const {

    if (OPCODE_FIELD(encodedInstr) == OPCODE_R   ||
        OPCODE_FIELD(encodedInstr) == OPCODE_I_I || OPCODE_FIELD(encodedInstr) == OPCODE_I_L || OPCODE_FIELD(encodedInstr) == OPCODE_I_J ||
        OPCODE_FIELD(encodedInstr) == OPCODE_U1  || OPCODE_FIELD(encodedInstr) == OPCODE_U2  ||
        OPCODE_FIELD(encodedInstr) == OPCODE_J) {
        return RF_WR;
    } else {
        return RF_WR_X;
    }
}

RF_WriteDataSelType Control_unit::getRegFileWriteDataSel(unsigned int encodedInstr) const {

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

bool Control_unit::getStallOnce(EncType currEncType, EncType prevEncType, unsigned int regRs1Addr, unsigned int regRs2Addr, unsigned int regRdAddr) const {

    if ((((currEncType == ENC_B) && (prevEncType == ENC_R || prevEncType == ENC_I_I || prevEncType == ENC_U)) || (currEncType == ENC_R && prevEncType == ENC_I_L)) &&
        ((regRs1Addr == regRdAddr) || (regRs2Addr == regRdAddr))) {
        return true;
    } else if ((((currEncType == ENC_I_I || currEncType == ENC_I_L || currEncType == ENC_S) && prevEncType == ENC_I_L) ||
                (currEncType == ENC_I_J && (prevEncType == ENC_R || prevEncType == ENC_I_I || prevEncType == ENC_U))) && (regRs1Addr == regRdAddr)) {
        return true;
    } else {
        return false;
    }
}

bool Control_unit::getStallTwice(EncType currEncType, EncType prevEncType, unsigned int regRs1Addr, unsigned int regRs2Addr, unsigned int regRdAddr) const {

    if ((currEncType == ENC_B) && (prevEncType == ENC_I_L) && ((regRs1Addr == regRdAddr) || (regRs2Addr == regRdAddr))) {
        return true;
    } else if (currEncType == ENC_I_J && prevEncType == ENC_I_L && regRs1Addr == regRdAddr) {
        return true;
    } else {
        return false;
    }
}

unsigned int Control_unit::getPC(PC_SelType pcSel, unsigned int imm, bool branchTaken, unsigned int reg1Content, unsigned int pcReg) const {

    if (pcSel == PC_BR) {
        if (branchTaken) {
#ifdef LOGTOFILE
            cout << "S2: @PC: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~BRANCH TAKEN~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~." << endl;
#endif
            return pcReg - 8 + imm;
        } else {
#ifdef LOGTOFILE
            cout << "S2: @PC: .~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~BRANCH NOT TAKEN~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~" << endl;
#endif
            return pcReg + 4;
        }
    } else if (pcSel == PC_J) {
        return pcReg - 4 + imm;
    } else if (pcSel == PC_JR) {
        return reg1Content + imm;
    } else {
        return pcReg + 4;
    }
}


#endif //PROJECT_CONTROL_PATH_H