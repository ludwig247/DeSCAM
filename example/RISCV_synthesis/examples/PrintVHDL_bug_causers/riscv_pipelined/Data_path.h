//
// Created by salaheddin hetalani (salaheddinhetalani@gmail.com) on 31 Mar, 2018
//

#ifndef PROJECT_DATA_PATH__H
#define PROJECT_DATA_PATH__H

#include "systemc.h"
#include "Interfaces.h"
#include "CPU_Interfaces.h"
#include "../../RISCV_commons/Utilities.h"


class Data_path : public sc_module {
public:

    SC_HAS_PROCESS(Data_path);

    Data_path(sc_module_name name) :
            DPtoCU_port("DPtoCU_port"),
            CUtoDP_port("CUtoDP_port"),
            DPtoRF_port("DPtoRF_port"),
            RFtoDP_port("RFtoDP_port"),
            section(readRegFileStage),
            nextsection(readRegFileStage),
            reg1Content(0),
            reg2Content(0),
            rec(false)
    {
        SC_THREAD(run); // register thread with kernel
    }

    slave_out<DPtoCU_IF> DPtoCU_port;
    slave_in<CUtoDP_IF> CUtoDP_port;

    master_out<DPtoRF_IF> DPtoRF_port;
    master_in<RFtoDP_IF> RFtoDP_port;

    DPtoCU_IF DPtoCU_data;
    CUtoDP_IF CUtoDP_data;

    DPtoRF_IF DPtoRF_data;
    RFtoDP_IF RFtoDP_data;

    DPtoAL_IF DPtoAL_data;

    DP_S3 DP_S3_data;
    DP_S4 DP_S4_data;
    DP_S5 DP_S5_data;

    enum Sections {
        readRegFileStage, executeStage, memoryStage, writeBackStage, setPipelineSignals           
    };

    Sections section, nextsection;

    unsigned int reg1Content;
    unsigned int reg2Content;

    bool rec;

    void run(); // thread

    unsigned int regContentFwdUnit(unsigned int srcAddr, unsigned int dstAddr_s4, EncType encType_s4, unsigned int dstAddr_s5, EncType encType_s5, unsigned int loadedData, unsigned int pc_s5, unsigned int pc_s4, unsigned int aluResult_s4, unsigned int aluResult_s5, unsigned int regContent) const;

    unsigned int getRegContent(RF_RD_AccessType rdReq, unsigned int srcAddr, RFtoDP_IF RFtoDP_data) const;

    unsigned int aluOpFwdUnit(unsigned int srcAddr_s3, unsigned int dstAddr_s4, unsigned int dstAddr_s5, EncType encType_s5, unsigned int loadedData, unsigned int aluResult_s4, unsigned int regContent_s3) const;

    unsigned int getALUoperand(AL_OperandSelType aluOpSel_s3, unsigned int aluOpFwdUnitValue, unsigned int imm_s3, unsigned int pc_s3) const;

    unsigned int getALUresult(DPtoAL_IF DPtoAL_data) const;

    unsigned int dmemDataInFwdUnit(unsigned int src2Addr_s4, unsigned int dstAddr_s5, EncType encType_s5, bool fwdPrevLoadedData, unsigned int loadedData, unsigned int aluResult_s5, unsigned int prevLoadedData, unsigned int reg2Content_s4) const;

    unsigned int getWBdata(RF_WriteDataSelType wbSel_s5, unsigned int aluResult_s5, unsigned int loadedData, unsigned int pc_s5) const;
};


void Data_path::run() {

    while (true) {

        if (section == readRegFileStage) {

            DPtoCU_port->nb_write(DPtoCU_data);

            rec = CUtoDP_port->nb_read(CUtoDP_data);

            if (rec) {

#ifdef LOGTOFILE
                cout << "S2: @DP:                                                                                           "
                     << setw(7) << stringInstrType(CUtoDP_data.instrType_s2) << "  :  " << setw(7) << stringInstrType(DP_S3_data.instrType_s3) << "  :  "
                     << setw(7) << stringInstrType(DP_S4_data.instrType_s4) << "  :  " << setw(7) << stringInstrType(DP_S5_data.instrType_s5) << endl;

                cout << "S2: @DP:                                                                                           "
                     << hex << "0x" << setw(5) << CUtoDP_data.pc_s2 << "  :  " << "0x" << setw(5) << DP_S3_data.pc_s3 << "  :  "
                            << "0x" << setw(5) << DP_S4_data.pc_s4 << "  :  " << "0x" << setw(5) << DP_S5_data.pc_s5 << endl;
#endif

                RFtoDP_port->read(RFtoDP_data);

                reg1Content = regContentFwdUnit(CUtoDP_data.regRs1Addr_s2, DP_S4_data.regRdAddr_s4, DP_S4_data.encType_s4, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, CUtoDP_data.loadedData, DP_S5_data.pc_s5, DP_S4_data.pc_s4, DP_S4_data.aluResult_s4, DP_S5_data.aluResult_s5, getRegContent(CUtoDP_data.regFileReq_s2, CUtoDP_data.regRs1Addr_s2, RFtoDP_data));
                reg2Content = regContentFwdUnit(CUtoDP_data.regRs2Addr_s2, DP_S4_data.regRdAddr_s4, DP_S4_data.encType_s4, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, CUtoDP_data.loadedData, DP_S5_data.pc_s5, DP_S4_data.pc_s4, DP_S4_data.aluResult_s4, DP_S5_data.aluResult_s5, getRegContent(CUtoDP_data.regFileReq_s2, CUtoDP_data.regRs2Addr_s2, RFtoDP_data));

                DPtoCU_data.reg1Content = reg1Content;
                DPtoCU_data.reg2Content = reg2Content;

                nextsection = executeStage;

            } else {

#ifdef LOGTOFILE
                cout << "S2: @DP: Control unit did not send data yet, try reading again" << endl;
#endif

            }
        }

        if (section == executeStage) {

            DPtoAL_data.aluFunc = CUtoDP_data.aluFunc_s3;
            DPtoAL_data.aluOp1 = getALUoperand(CUtoDP_data.aluOp1Sel_s3, aluOpFwdUnit(DP_S3_data.regRs1Addr_s3, DP_S4_data.regRdAddr_s4, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, CUtoDP_data.loadedData, DP_S4_data.aluResult_s4, DP_S3_data.reg1Content_s3), CUtoDP_data.imm_s3, DP_S3_data.pc_s3);
            DPtoAL_data.aluOp2 = getALUoperand(CUtoDP_data.aluOp2Sel_s3, aluOpFwdUnit(DP_S3_data.regRs2Addr_s3, DP_S4_data.regRdAddr_s4, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, CUtoDP_data.loadedData, DP_S4_data.aluResult_s4, DP_S3_data.reg2Content_s3), CUtoDP_data.imm_s3, DP_S3_data.pc_s3);

#ifdef LOGTOFILE
            if (DPtoAL_data.aluFunc != ALU_X) {
                cout << "S3: @AL: Operand1 = 0x" << hex << DPtoAL_data.aluOp1 << "(hex) = " << dec << DPtoAL_data.aluOp1 << "(dec), Operand2 = 0x" << hex << DPtoAL_data.aluOp2
                     << "(hex) = " << dec << DPtoAL_data.aluOp2 << "(dec)" << endl;
                cout << "S3: @AL: Result = 0x" << hex << getALUresult(DPtoAL_data) << "(hex) = " << dec << getALUresult(DPtoAL_data) << "(dec)" << endl;
            }
#endif

            nextsection = memoryStage;
        }

        if (section == memoryStage) {

            if (CUtoDP_data.dmemReq_s4 == ME_RD) {

                DPtoCU_data.req = CUtoDP_data.dmemReq_s4;
                DPtoCU_data.mask = CUtoDP_data.dmemMask_s4;
                DPtoCU_data.addrIn = DP_S4_data.aluResult_s4;
                DPtoCU_data.dataIn = 0;

            } else if (CUtoDP_data.dmemReq_s4 == ME_WR) {

                DPtoCU_data.req = CUtoDP_data.dmemReq_s4;
                DPtoCU_data.mask = CUtoDP_data.dmemMask_s4;
                DPtoCU_data.addrIn = DP_S4_data.aluResult_s4;
                DPtoCU_data.dataIn = dmemDataInFwdUnit(DP_S4_data.regRs2Addr_s4, DP_S5_data.regRdAddr_s5, DP_S5_data.encType_s5, DP_S4_data.fwdPrevLoadedData, CUtoDP_data.loadedData, DP_S5_data.aluResult_s5, DP_S4_data.prevLoadedData, DP_S4_data.reg2Content_s4);

            } else {

                DPtoCU_data.req = ME_X;
                DPtoCU_data.mask = MT_X;
                DPtoCU_data.addrIn = 0;
                DPtoCU_data.dataIn = 0;
            }

            if (CUtoDP_data.prevDmemAccess && DP_S3_data.encType_s3 == ENC_S && DP_S5_data.encType_s5 == ENC_I_L && DP_S3_data.regRs2Addr_s3 == DP_S5_data.regRdAddr_s5 && DP_S5_data.regRdAddr_s5 != 0) {
                DP_S4_data.fwdPrevLoadedData = true;
                DP_S4_data.prevLoadedData = CUtoDP_data.loadedData;
            } else if (DP_S4_data.fwdPrevLoadedData && CUtoDP_data.stallDmemAccess) {
                DP_S4_data.fwdPrevLoadedData = true;
            } else {
                DP_S4_data.fwdPrevLoadedData = false;
            }

            nextsection = writeBackStage;
        }

        if (section == writeBackStage) {

            DPtoRF_data.wrReq = CUtoDP_data.regFileReq_s5;
            DPtoRF_data.dst = DP_S5_data.regRdAddr_s5;
            DPtoRF_data.dstData = getWBdata(CUtoDP_data.regFileWriteDataSel_s5, DP_S5_data.aluResult_s5, CUtoDP_data.loadedData, DP_S5_data.pc_s5);

            DPtoRF_port->write(DPtoRF_data);

            nextsection = setPipelineSignals;
        }

        if (section == setPipelineSignals) {

            if (!CUtoDP_data.stallDmemAccess) {

                DP_S5_data.pc_s5 = DP_S4_data.pc_s4;
                DP_S5_data.encType_s5 = DP_S4_data.encType_s4;
                DP_S5_data.regRdAddr_s5 = DP_S4_data.regRdAddr_s4;
                DP_S5_data.aluResult_s5 = DP_S4_data.aluResult_s4;

                DP_S4_data.pc_s4 = DP_S3_data.pc_s3;
                DP_S4_data.encType_s4 = DP_S3_data.encType_s3;
                DP_S4_data.regRs2Addr_s4 = DP_S3_data.regRs2Addr_s3;
                DP_S4_data.regRdAddr_s4 = DP_S3_data.regRdAddr_s3;
                DP_S4_data.reg2Content_s4 = DP_S3_data.reg2Content_s3;
                DP_S4_data.aluResult_s4 = getALUresult(DPtoAL_data);

                DP_S3_data.pc_s3 = CUtoDP_data.pc_s2;
                DP_S3_data.encType_s3 = CUtoDP_data.encType_s2;
                DP_S3_data.regRs1Addr_s3 = CUtoDP_data.regRs1Addr_s2;
                DP_S3_data.regRs2Addr_s3 = CUtoDP_data.regRs2Addr_s2;
                DP_S3_data.regRdAddr_s3 = CUtoDP_data.regRdAddr_s2;
                DP_S3_data.reg1Content_s3 = reg1Content;
                DP_S3_data.reg2Content_s3 = reg2Content;

#ifdef LOGTOFILE
                DP_S5_data.instrType_s5 = DP_S4_data.instrType_s4;
                DP_S4_data.instrType_s4 = DP_S3_data.instrType_s3;
                DP_S3_data.instrType_s3 = CUtoDP_data.instrType_s2;
#endif

            }

            nextsection = readRegFileStage;
        }

        section = nextsection;
    }
}


unsigned int Data_path::regContentFwdUnit(unsigned int srcAddr, unsigned int dstAddr_s4, EncType encType_s4, unsigned int dstAddr_s5, EncType encType_s5, unsigned int loadedData, unsigned int pc_s5, unsigned int pc_s4, unsigned int aluResult_s4, unsigned int aluResult_s5, unsigned int regContent) const {

    if (srcAddr == 0) {
        return 0;
    } else if (srcAddr == dstAddr_s5 && encType_s5 == ENC_I_L && srcAddr != dstAddr_s4) {
        return loadedData;
    } else if (srcAddr == dstAddr_s5 && (encType_s5 == ENC_I_J || encType_s5 == ENC_J)) {
        return pc_s5 + 4;
    } else if (srcAddr == dstAddr_s4 && encType_s4 == ENC_J) {
        return pc_s4 + 4;
    } else if (srcAddr == dstAddr_s4) {
        return aluResult_s4;
    } else if (srcAddr == dstAddr_s5) {
        return aluResult_s5;
    } else {
        return regContent;
    }
}

unsigned int Data_path::getRegContent(RF_RD_AccessType rdReq, unsigned int srcAddr, RFtoDP_IF RFtoDP_data) const {

    if (rdReq == RF_RD) {

        if (srcAddr == 0) {
            return 0;
        } else if (srcAddr == 1) {
            return RFtoDP_data.reg_file_01;
        } else if (srcAddr == 2) {
            return RFtoDP_data.reg_file_02;
        } else if (srcAddr == 3) {
            return RFtoDP_data.reg_file_03;
        } else if (srcAddr == 4) {
            return RFtoDP_data.reg_file_04;
        } else if (srcAddr == 5) {
            return RFtoDP_data.reg_file_05;
        } else if (srcAddr == 6) {
            return RFtoDP_data.reg_file_06;
        } else if (srcAddr == 7) {
            return RFtoDP_data.reg_file_07;
        } else if (srcAddr == 8) {
            return RFtoDP_data.reg_file_08;
        } else if (srcAddr == 9) {
            return RFtoDP_data.reg_file_09;
        } else if (srcAddr == 10) {
            return RFtoDP_data.reg_file_10;
        } else if (srcAddr == 11) {
            return RFtoDP_data.reg_file_11;
        } else if (srcAddr == 12) {
            return RFtoDP_data.reg_file_12;
        } else if (srcAddr == 13) {
            return RFtoDP_data.reg_file_13;
        } else if (srcAddr == 14) {
            return RFtoDP_data.reg_file_14;
        } else if (srcAddr == 15) {
            return RFtoDP_data.reg_file_15;
        } else if (srcAddr == 16) {
            return RFtoDP_data.reg_file_16;
        } else if (srcAddr == 17) {
            return RFtoDP_data.reg_file_17;
        } else if (srcAddr == 18) {
            return RFtoDP_data.reg_file_18;
        } else if (srcAddr == 19) {
            return RFtoDP_data.reg_file_19;
        } else if (srcAddr == 20) {
            return RFtoDP_data.reg_file_20;
        } else if (srcAddr == 21) {
            return RFtoDP_data.reg_file_21;
        } else if (srcAddr == 22) {
            return RFtoDP_data.reg_file_22;
        } else if (srcAddr == 23) {
            return RFtoDP_data.reg_file_23;
        } else if (srcAddr == 24) {
            return RFtoDP_data.reg_file_24;
        } else if (srcAddr == 25) {
            return RFtoDP_data.reg_file_25;
        } else if (srcAddr == 26) {
            return RFtoDP_data.reg_file_26;
        } else if (srcAddr == 27) {
            return RFtoDP_data.reg_file_27;
        } else if (srcAddr == 28) {
            return RFtoDP_data.reg_file_28;
        } else if (srcAddr == 29) {
            return RFtoDP_data.reg_file_29;
        } else if (srcAddr == 30) {
            return RFtoDP_data.reg_file_30;
        } else {
            return RFtoDP_data.reg_file_31;
        }

    } else {
        return 0;
    }
}

unsigned int Data_path::aluOpFwdUnit(unsigned int srcAddr_s3, unsigned int dstAddr_s4, unsigned int dstAddr_s5, EncType encType_s5, unsigned int loadedData, unsigned int aluResult_s4, unsigned int regContent_s3) const {

    if (srcAddr_s3 == dstAddr_s5 && encType_s5 == ENC_I_L && srcAddr_s3 != dstAddr_s4 && srcAddr_s3 != 0) {
        return loadedData;
    } else if (srcAddr_s3 == dstAddr_s4 && srcAddr_s3 != 0) {
        return aluResult_s4;
    } else {
        return regContent_s3;
    }
}

unsigned int Data_path::getALUoperand(AL_OperandSelType aluOpSel_s3, unsigned int aluOpFwdUnitValue, unsigned int imm_s3, unsigned int pc_s3) const {

    if (aluOpSel_s3 == OP_REG) {
        return aluOpFwdUnitValue;
    } else if (aluOpSel_s3 == OP_IMM) {
        return imm_s3;
    } else if (aluOpSel_s3 == OP_PC) {
        return pc_s3;
    } else {
        return 0;
    }
}

unsigned int Data_path::getALUresult(DPtoAL_IF DPtoAL_data) const {

    if (DPtoAL_data.aluFunc == ALU_ADD) {
        return DPtoAL_data.aluOp1 + DPtoAL_data.aluOp2;
    } else if (DPtoAL_data.aluFunc == ALU_SUB) {
        return DPtoAL_data.aluOp1 + (-DPtoAL_data.aluOp2);
    } else if (DPtoAL_data.aluFunc == ALU_AND) {
        return DPtoAL_data.aluOp1 & DPtoAL_data.aluOp2;
    } else if (DPtoAL_data.aluFunc == ALU_OR) {
        return DPtoAL_data.aluOp1 | DPtoAL_data.aluOp2;
    } else if (DPtoAL_data.aluFunc == ALU_XOR) {
        return DPtoAL_data.aluOp1 ^ DPtoAL_data.aluOp2;
    } else if (DPtoAL_data.aluFunc == ALU_SLT) {
        if (static_cast<int>(DPtoAL_data.aluOp1) < static_cast<int>(DPtoAL_data.aluOp2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (DPtoAL_data.aluFunc == ALU_SLTU) {
        if (DPtoAL_data.aluOp1 < DPtoAL_data.aluOp2) {
            return 1;
        } else {
            return 0;
        }
    } else if (DPtoAL_data.aluFunc == ALU_SLL) {
        return DPtoAL_data.aluOp1 << ((DPtoAL_data.aluOp2) & 0x1F);
    } else if (DPtoAL_data.aluFunc == ALU_SRA) {
        return static_cast<unsigned int>(static_cast<int>(DPtoAL_data.aluOp1) >> static_cast<int>(DPtoAL_data.aluOp2 & 0x1F));
    } else if (DPtoAL_data.aluFunc == ALU_SRL) {
        return DPtoAL_data.aluOp1 >> ((DPtoAL_data.aluOp2) & 0x1F);
    } else if (DPtoAL_data.aluFunc == ALU_COPY1) {
        return DPtoAL_data.aluOp1;
    } else {
        return 0;
    }
}

unsigned int Data_path::dmemDataInFwdUnit(unsigned int src2Addr_s4, unsigned int dstAddr_s5, EncType encType_s5, bool fwdPrevLoadedData, unsigned int loadedData, unsigned int aluResult_s5, unsigned int prevLoadedData, unsigned int reg2Content_s4) const {

    if (src2Addr_s4 == dstAddr_s5 && encType_s5 == ENC_I_L && src2Addr_s4 != 0) {
        return loadedData;
    } else if (src2Addr_s4 == dstAddr_s5 && src2Addr_s4 != 0) {
        return aluResult_s5;
    } else if (fwdPrevLoadedData) {
        return prevLoadedData;
    } else {
        return reg2Content_s4;
    }
}

unsigned int Data_path::getWBdata(RF_WriteDataSelType wbSel_s5, unsigned int aluResult_s5, unsigned int loadedData, unsigned int pc_s5) const {

    if (wbSel_s5 == WB_ALU) {
        return aluResult_s5;
    } else if (wbSel_s5 == WB_MEM) {
        return loadedData;
    } else if (wbSel_s5 == WB_PC4) {
        return pc_s5 + 4;
    } else {
        return 0;
    }
}


#endif //PROJECT_DATA_PATH_H