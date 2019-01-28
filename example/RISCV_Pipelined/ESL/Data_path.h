//
// Created by salaheddin hetalani on 31.03.18.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//|NUM||DEPENDENCIES|S_NUM||STALL_TYPE|F_NUM|F_TYPE |F_TYPE |NUM||DEPENDENCIES|S_NUM||STALL_TYPE|F_NUM|F_TYPE |F_TYPE ||
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//||01||  R  ~>  R  || -- || ------- || 01 || EX1_1 | EX2_1 ||09|| I_I ~>  R  || -- || ------- || 07 || EX1_1 | EX2_1 ||
//||02||  R  ~> I_I || -- || ------- || 02 || EX1_1 | ----- ||10|| I_I ~> I_I || -- || ------- || 08 || EX1_1 | ----- ||
//||03||  R  ~> I_L || -- || ------- || 03 || EX1_1 | ----- ||11|| I_I ~> I_L || -- || ------- || 09 || EX1_1 | ----- ||
//||04||  R  ~> I_J || 01 || STALL_3 || 04 || ID1_1 | ----- ||12|| I_I ~> I_J || 03 || STALL_3 || 10 || ID1_1 | ----- ||
//||05||  R  ~>  S  || -- || ------- || 05 || EX1_1 | MEM_1 ||13|| I_I ~>  S  || -- || ------- || 11 || EX1_1 | MEM_1 ||
//||06||  R  ~>  B  || 02 || STALL_1 || 06 || ID1_1 | ID2_1 ||14|| I_I ~>  B  || 04 || STALL_1 || 12 || ID1_1 | ID2_1 ||
//||07||  R  ~>  U  || -- || ------- || -- || ----- | ----- ||15|| I_I ~>  U  || -- || ------- || -- || ----- | ----- ||
//||08||  R  ~>  J  || -- || ------- || -- || ----- | ----- ||16|| I_I ~>  J  || -- || ------- || -- || ----- | ----- ||
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//||17|| I_L ~>  R  || 05 || STALL_1 || 13 || EX1_2 | EX2_2 ||25|| I_J ~>  R  || -- || ------- || 19 || ID1_3 | ID2_3 ||*ID_4
//||18|| I_L ~> I_I || 06 || STALL_3 || 14 || EX1_2 | ----- ||26|| I_J ~> I_I || -- || ------- || 20 || ID1_3 | ----- ||*
//||19|| I_L ~> I_L || 07 || STALL_3 || 15 || EX1_2 | ----- ||27|| I_J ~> I_L || -- || ------- || 21 || ID1_3 | ----- ||*
//||20|| I_L ~> I_J || 08 || STALL_4 || 16 || ID1_5 | ----- ||28|| I_J ~> I_J || -- || ------- || 22 || ID1_3 | ----- ||*
//||21|| I_L ~>  S  ||*09 ||*STALL_4 ||*17 ||*ID1_5 |*ID2_5 ||29|| I_J ~>  S  || -- || ------- || 23 || ID1_3 | ID2_3 ||* *MEM_2 in case only rs2 is needed without any STALL
//||22|| I_L ~>  B  || 10 || STALL_2 || 18 || ID1_5 | ID2_5 ||30|| I_J ~>  B  || -- || ------- || 24 || ID1_3 | ID2_3 ||*
//||23|| I_L ~>  U  || -- || ------- || -- || ----- | ----- ||31|| I_J ~>  U  || -- || ------- || -- || ----- | ----- ||
//||24|| I_L ~>  J  || -- || ------- || -- || ----- | ----- ||32|| I_J ~>  J  || -- || ------- || -- || ----- | ----- ||
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//||33||  S  ~>  R  || -- || ------- || -- || ----- | ----- ||41||  B  ~>  R  || -- || ------- || -- || ----- | ----- ||
//||34||  S  ~> I_I || -- || ------- || -- || ----- | ----- ||42||  B  ~> I_I || -- || ------- || -- || ----- | ----- ||
//||35||  S  ~> I_L || -- || ------- || -- || ----- | ----- ||43||  B  ~> I_L || -- || ------- || -- || ----- | ----- ||
//||36||  S  ~> I_J || -- || ------- || -- || ----- | ----- ||44||  B  ~> I_J || -- || ------- || -- || ----- | ----- ||
//||37||  S  ~>  S  || -- || ------- || -- || ----- | ----- ||45||  B  ~>  S  || -- || ------- || -- || ----- | ----- ||
//||38||  S  ~>  B  || -- || ------- || -- || ----- | ----- ||46||  B  ~>  B  || -- || ------- || -- || ----- | ----- ||
//||39||  S  ~>  U  || -- || ------- || -- || ----- | ----- ||47||  B  ~>  U  || -- || ------- || -- || ----- | ----- ||
//||40||  S  ~>  J  || -- || ------- || -- || ----- | ----- ||48||  B  ~>  J  || -- || ------- || -- || ----- | ----- ||
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//||49||  U  ~>  R  || -- || ------- || 25 || EX1_1 | EX2_1 ||57||  J  ~>  R  || -- || ------- || 31 || ID1_3 | ID2_3 ||
//||50||  U  ~> I_I || -- || ------- || 26 || EX1_1 | ----- ||58||  J  ~> I_I || -- || ------- || 32 || ID1_3 | ----- ||
//||51||  U  ~> I_L || -- || ------- || 27 || EX1_1 | ----- ||59||  J  ~> I_L || -- || ------- || 33 || ID1_3 | ----- ||
//||52||  U  ~> I_J || 11 || STALL_3 || 28 || ID1_1 | ----- ||60||  J  ~> I_J || -- || ------- || 34 || ID1_3 | ----- ||
//||53||  U  ~>  S  || -- || ------- || 29 || EX1_1 | MEM_1 ||61||  J  ~>  S  || -- || ------- || 35 || ID1_3 | ID2_3 ||
//||54||  U  ~>  B  || 12 || STALL_1 || 30 || ID1_1 | ID2_1 ||62||  J  ~>  B  || -- || ------- || 36 || ID1_3 | ID2_3 ||
//||55||  U  ~>  U  || -- || ------- || -- || ----- | ----- ||63||  J  ~>  U  || -- || ------- || -- || ----- | ----- ||
//||56||  U  ~>  J  || -- || ------- || -- || ----- | ----- ||64||  J  ~>  J  || -- || ------- || -- || ----- | ----- ||
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
            DPtoCP_port("DPtoCP_port"),
            CPtoDP_port("CPtoDP_port"),
            DPtoRF_port("DPtoRF_port"),
            RFtoDP_port("RFtoDP_port"),
            section(ID_writeCP_readCP),
            nextsection(ID_writeCP_readCP),
            reg1_content(0),
            reg2_content(0),
            wb_data(0),
            rec(false)
    {
        SC_THREAD(run); // register thread with kernel
    }

    // ports for communication with control path
    slave_out<DPtoCP_IF> DPtoCP_port;
    slave_in<CPtoDP_IF> CPtoDP_port;

    // ports for communication with register file
    master_out<DPtoRF_IF> DPtoRF_port;
    master_in<RFtoDP_IF> RFtoDP_port;

    // data for communication with data path
    DPtoCP_IF DPtoCP_data;
    CPtoDP_IF CPtoDP_data;

    // data for communication with register file
    DPtoRF_IF DPtoRF_data;
    RFtoDP_IF RFtoDP_data;

    // data for communication with ALU
    DPtoAL_IF DPtoAL_data;

    // Other control signals:
    DP_S3_IF DP_S3_data;
    DP_S4_IF DP_S4_data;
    DP_S5_IF DP_S5_data;

    enum Sections {
        ID_writeCP_readCP, ID_writeRF_readRF, ID_setPCsignals, EX_writeAL_readAL, ME_setDMsignals, DP_setPipelineSignals
    };

    Sections section, nextsection;

    unsigned int reg1_content;
    unsigned int reg2_content;

    unsigned int wb_data;

    bool rec;

    void run(); // thread

    unsigned int ALU(DPtoAL_IF DPtoAL_data) const;

    unsigned int RF(RF_RD_AccessType rdReq, unsigned int src, RFtoDP_IF RFtoDP_data) const;
};


void Data_path::run() {

    while (true) {

        if (section == ID_writeCP_readCP) {

            DPtoCP_port->nb_write(DPtoCP_data);

            rec = CPtoDP_port->nb_read(CPtoDP_data);

            if (rec) {

#ifdef LOGTOFILE
                cout << "S2: @DP:                                                                                           "
                     << setw(7) << stringInstrType(CPtoDP_data.inst_type_s2) << "  :  "
                     << setw(7) << stringInstrType(DP_S3_data.inst_type_s3) << "  :  "
                     << setw(7) << stringInstrType(DP_S4_data.inst_type_s4) << "  :  "
                     << setw(7) << stringInstrType(DP_S5_data.inst_type_s5) << endl;

                cout << "S2: @DP:                                                                                           "
                     << hex << "0x" << setw(5) << CPtoDP_data.pc_s2 << "  :  " << "0x" << setw(5) << DP_S3_data.pc_s3
                     << "  :  " << "0x" << setw(5) << DP_S4_data.pc_s4 << "  :  " << "0x" << setw(5)
                     << DP_S5_data.pc_s5 << endl;
#endif
                nextsection = ID_writeRF_readRF;
            } else {
#ifdef LOGTOFILE
                cout << "REPEAT" << endl;
#endif
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_writeRF_readRF) {

            RFtoDP_port->read(RFtoDP_data);

            // Set Write Back data
            if (CPtoDP_data.reg_write_data_sel_s5 == WB_ALU) {
                wb_data = DP_S5_data.alu_result_s5;
            } else if (CPtoDP_data.reg_write_data_sel_s5 == WB_MEM) {
                wb_data = CPtoDP_data.loadedData_s5;
            } else if (CPtoDP_data.reg_write_data_sel_s5 == WB_PC4) {
                wb_data = DP_S5_data.pc_s5 + 4;
            } else { //(CPtoDP_data.reg_write_data_sel_s5 == WB_X)
                wb_data = 0;
            }

            // Perform Register File Write Back
            DPtoRF_data.wrReq = CPtoDP_data.reg_req_s5;
            DPtoRF_data.dst = DP_S5_data.reg_rd_addr_s5;
            DPtoRF_data.dstData = wb_data;

            DPtoRF_port->write(DPtoRF_data);

            if (CPtoDP_data.reg_rs1_addr_s2 == 0) {

                reg1_content = 0;

            } else if (CPtoDP_data.reg_rs1_addr_s2 == DP_S5_data.reg_rd_addr_s5 && DP_S5_data.enc_type_s5 == ENC_I_L && CPtoDP_data.reg_rs1_addr_s2 != DP_S4_data.reg_rd_addr_s4) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_5 || STALL_TYPE: (STALL_4 | STALL_2) FORWARDING_NUM: (16 | 17 | 18)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~||>>~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~ID~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~IF~~~||~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg1_content = CPtoDP_data.loadedData_s5;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID1_5~.~.~. after stalling twice  "
                     << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   "
                     << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    MEM's content in stage_5: " << hex << CPtoDP_data.loadedData_s5
                     << " FORWARDED to REG1's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs1_addr_s2 == DP_S5_data.reg_rd_addr_s5 &&
                       (DP_S5_data.enc_type_s5 == ENC_I_J || DP_S5_data.enc_type_s5 == ENC_J)) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_4 ||
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~|
                //|                   |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                             |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg1_content = DP_S5_data.pc_s5 + 4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID1_4~.~.~.  " << stringInstrType(DP_S5_data.inst_type_s5)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    Next PC's value in stage_5: "
                     << hex << DP_S5_data.pc_s5 + 4 << " FORWARDED to REG1's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs1_addr_s2 == DP_S4_data.reg_rd_addr_s4 &&
                       (/*DP_S4_data.enc_type_s4 == I_J ||*/DP_S4_data.enc_type_s4 == ENC_J)) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_3 || FORWARDING_NUM: (19 | 20 | 21 | 22 | 23 | 24 | 31 | 32 | 33 | 34 | 35 | 36)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~|
                //|                   |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg1_content = DP_S4_data.pc_s4 + 4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID1_3~.~.~.  " << stringInstrType(DP_S4_data.inst_type_s4)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    Next PC's value in stage_4: "
                     << hex << DP_S4_data.pc_s4 + 4 << " FORWARDED to REG1's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs1_addr_s2 == DP_S4_data.reg_rd_addr_s4) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_1 || GENERAL FORWARDING IN THE NORMAL CASE
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_1 || STALL_TYPE: (STALL_3 | STALL_1) FORWARDING_NUM: (04 | 06 | 10 | 12 | 28 | 30)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg1_content = DP_S4_data.alu_result_s4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID1_1~.~.~. (after stalling once)  "
                     << stringInstrType(DP_S4_data.inst_type_s4) << "   ~~>   "
                     << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    AL's content in stage_4: " << hex << DP_S4_data.alu_result_s4
                     << " FORWARDED TO REG1's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs1_addr_s2 == DP_S5_data.reg_rd_addr_s5) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID1_2 || GENERAL FORWARDING IN THE NORMAL CASE
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||>>~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                             |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg1_content = DP_S5_data.alu_result_s5;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~.~.~.~.~FORWARDING TYPE: ID1_2~.~.~.~.~.~.~.  "
                     << stringInstrType(DP_S5_data.inst_type_s5)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2) << "    AL's content in stage_5: "
                     << hex << DP_S5_data.alu_result_s5 << " FORWARDED to REG1's content" << endl;
#endif

            } else { //Normal case: No Forwarding needed

                reg1_content = RF(CPtoDP_data.reg_req_s2, CPtoDP_data.reg_rs1_addr_s2, RFtoDP_data);
            }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            if (CPtoDP_data.reg_rs2_addr_s2 == 0) {

                reg2_content = 0;

            } else if (CPtoDP_data.reg_rs2_addr_s2 == DP_S5_data.reg_rd_addr_s5 && DP_S5_data.enc_type_s5 == ENC_I_L && CPtoDP_data.reg_rs2_addr_s2 != DP_S4_data.reg_rd_addr_s4) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_5 || STALL_TYPE: (STALL_4 | STALL_2) FORWARDING_NUM: (17 | 18)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~||>>~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~ID~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~IF~~~||~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg2_content = CPtoDP_data.loadedData_s5;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID2_5~.~.~. after stalling twice  "
                     << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   "
                     << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    MEM's content in stage_5: " << hex << CPtoDP_data.loadedData_s5
                     << " FORWARDED to REG2's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs2_addr_s2 == DP_S5_data.reg_rd_addr_s5 &&
                       (DP_S5_data.enc_type_s5 == ENC_I_J || DP_S5_data.enc_type_s5 == ENC_J)) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_4 ||
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~|
                //|                   |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                             |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg2_content = DP_S5_data.pc_s5 + 4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID2_4~.~.~.  " << stringInstrType(DP_S5_data.inst_type_s5)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    Next PC's value in stage_5: "
                     << hex << DP_S5_data.pc_s5 + 4 << " FORWARDED to REG2's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs2_addr_s2 == DP_S4_data.reg_rd_addr_s4 &&
                       (/*DP_S4_data.enc_type_s4 == I_J ||*/ DP_S4_data.enc_type_s4 == ENC_J)) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_3 || FORWARDING_NUM: (19 | 23 | 24 | 31 | 35 | 36)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~||~~~~~~~~|
                //|                   |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg2_content = DP_S4_data.pc_s4 + 4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID2_3~.~.~.  " << stringInstrType(DP_S4_data.inst_type_s4)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    Next PC's value in stage_4: "
                     << hex << DP_S4_data.pc_s4 + 4 << " FORWARDED to REG2's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs2_addr_s2 == DP_S4_data.reg_rd_addr_s4) {
                /////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_1 || GENERAL FORWARDING IN THE NORMAL CASE
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_1 || STALL_TYPE: (STALL_1) FORWARDING_NUM: (06 | 12 | 30)
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg2_content = DP_S4_data.alu_result_s4;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID2_1~.~.~. (after stalling once)  "
                     << stringInstrType(DP_S4_data.inst_type_s4) << "   ~~>   "
                     << stringInstrType(CPtoDP_data.inst_type_s2)
                     << "    AL's content in stage_4: " << hex << DP_S4_data.alu_result_s4
                     << " FORWARDED TO REG2's content" << endl;
#endif

            } else if (CPtoDP_data.reg_rs2_addr_s2 == DP_S5_data.reg_rd_addr_s5) {
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|  ID2_2 || GENERAL FORWARDING IN THE NORMAL CASE
                ////////////////////////////////////////////////////////////////////////////////////////////
                //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||>>~WB~~~|
                //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                   |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                //|                             |~~~IF~~~||~>>ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                ////////////////////////////////////////////////////////////////////////////////////////////
                reg2_content = DP_S5_data.alu_result_s5;

#ifdef LOGTOFILE
                cout << "S2: @DP: .~.~.~FORWARDING TYPE: ID2_2~.~.~.  " << stringInstrType(DP_S5_data.inst_type_s5)
                     << "   ~~>   " << stringInstrType(CPtoDP_data.inst_type_s2) << "    AL's content in stage_5: "
                     << hex << DP_S5_data.alu_result_s5 << " FORWARDED to REG2's content" << endl;
#endif

            } else { //Normal case: No Forwarding needed

                reg2_content = RF(CPtoDP_data.reg_req_s2, CPtoDP_data.reg_rs2_addr_s2, RFtoDP_data);
            }

#ifdef LOGTOFILE
            cout << "S2: @DP: Reading registers x" << dec << CPtoDP_data.reg_rs1_addr_s2 << hex << " = "
                 << reg1_content << " , x" << dec << CPtoDP_data.reg_rs2_addr_s2 << hex << " = " << reg2_content
                 << endl;
#endif

            nextsection = ID_setPCsignals;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ID_setPCsignals) {

            DPtoCP_data.reg1_content = reg1_content;
            DPtoCP_data.reg2_content = reg2_content;

            nextsection = EX_writeAL_readAL;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == EX_writeAL_readAL) {

            DPtoAL_data.alu_fun = CPtoDP_data.alu_fun_s3;

            // select ALU operand 1
            if (CPtoDP_data.alu_op1_sel_s3 == OP_REG) {

                if (DP_S3_data.reg_rs1_addr_s3 == DP_S5_data.reg_rd_addr_s5 && DP_S3_data.reg_rs1_addr_s3 != 0 && DP_S5_data.enc_type_s5 == ENC_I_L && DP_S3_data.reg_rs1_addr_s3 != DP_S4_data.reg_rd_addr_s4) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  EX1_2 || STALL_TYPE: (STALL_1 | STALL_3) FORWARDING_NUM: (13 | 14 | 15)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~||>>~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~EX~~~||~>>EX~~~||~~~ME~~~||~~~WB~~~|
                    //|                   |~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoAL_data.alu_op1 = CPtoDP_data.loadedData_s5;

#ifdef LOGTOFILE
                    cout << "S3: @DP: .~.~.~FORWARDING TYPE: EX1_2~.~.~. after stalling once  "
                         << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   " << stringInstrType(DP_S3_data.inst_type_s3)
                         << "    MEM's content in stage_5: " << hex << CPtoDP_data.loadedData_s5
                         << " FORWARDED TO OP1's content" << endl;
#endif

                } else if (DP_S3_data.reg_rs1_addr_s3 == DP_S4_data.reg_rd_addr_s4 && DP_S3_data.reg_rs1_addr_s3 != 0) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  EX1_1 || FORWARDING_NUM: (01 | 02 | 03 | 07 | 08 | 09 | 25 | 26 | 27 | 29)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~>>EX~~~||~~~ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoAL_data.alu_op1 = DP_S4_data.alu_result_s4;

#ifdef LOGTOFILE
                    cout << "S3: @DP: .~.~.~FORWARDING TYPE: EX1_1~.~.~.  "
                         << stringInstrType(DP_S4_data.inst_type_s4) << "   ~~>   " << stringInstrType(DP_S3_data.inst_type_s3)
                         << "    AL's content in stage_4: " << hex << DP_S4_data.alu_result_s4 << " FORWARDED TO OP1's content"
                         << endl;
#endif

                } else { //Normal case: No Forwarding needed

                    DPtoAL_data.alu_op1 = DP_S3_data.reg1_content_s3;
                }

            } else if (CPtoDP_data.alu_op1_sel_s3 == OP_IMM) {
                DPtoAL_data.alu_op1 = CPtoDP_data.imm_s3;
            } else if (CPtoDP_data.alu_op1_sel_s3 == OP_PC) {
                DPtoAL_data.alu_op1 = DP_S3_data.pc_s3;
            } else { //(CPtoDP_data.alu_op1_sel_s3 == OP_X)
                DPtoAL_data.alu_op1 = 0;
            }
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            // select ALU operand 2
            if (CPtoDP_data.alu_op2_sel_s3 == OP_REG) {

                if (DP_S3_data.reg_rs2_addr_s3 == DP_S5_data.reg_rd_addr_s5 && DP_S3_data.reg_rs2_addr_s3 != 0 && DP_S5_data.enc_type_s5 == ENC_I_L && DP_S3_data.reg_rs2_addr_s3 != DP_S4_data.reg_rd_addr_s4) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  EX2_2 || STALL_TYPE: (STALL_1) FORWARDING_NUM: (13)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~||>>~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~EX~~~||~>>EX~~~||~~~ME~~~||~~~WB~~~|
                    //|                   |~~~IF~~~||~~~IF~~~||~~~ID~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoAL_data.alu_op2 = CPtoDP_data.loadedData_s5;

#ifdef LOGTOFILE
                    cout << "S3: @DP: .~.~.~FORWARDING TYPE: EX2_2~.~.~. after stalling once  "
                         << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   " << stringInstrType(DP_S3_data.inst_type_s3)
                         << "    MEM's content in stage_5: " << hex << CPtoDP_data.loadedData_s5
                         << " FORWARDED TO OP2's content" << endl;
#endif

                } else if (DP_S3_data.reg_rs2_addr_s3 == DP_S4_data.reg_rd_addr_s4 && DP_S3_data.reg_rs2_addr_s3 != 0) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  EX2_1 || FORWARDING_NUM: (01 | 07 | 25)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||>>~ME~~~||~~~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~>>EX~~~||~~~ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoAL_data.alu_op2 = DP_S4_data.alu_result_s4;

#ifdef LOGTOFILE
                    cout << "S3: @DP: .~.~.~FORWARDING TYPE: EX2_1~.~.~.  "
                         << stringInstrType(DP_S4_data.inst_type_s4) << "   ~~>   " << stringInstrType(DP_S3_data.inst_type_s3)
                         << "    AL's content in stage_4: " << hex << DP_S4_data.alu_result_s4 << " FORWARDED TO OP2's content"
                         << endl;
#endif

                } else { //Normal case: No Forwarding needed

                    DPtoAL_data.alu_op2 = DP_S3_data.reg2_content_s3;
                }

            } else if (CPtoDP_data.alu_op2_sel_s3 == OP_IMM) {
                DPtoAL_data.alu_op2 = CPtoDP_data.imm_s3;
            } else if (CPtoDP_data.alu_op2_sel_s3 == OP_PC) {
                DPtoAL_data.alu_op2 = DP_S3_data.pc_s3;
            } else { //(CPtoDP_data.alu_op2_sel_s3 == OP_X)
                DPtoAL_data.alu_op2 = 0;
            }

#ifdef LOGTOFILE
            if (DPtoAL_data.alu_fun != ALU_X) {
                cout << "S3: @AL: Decoded ALU operands: OP1 = 0x" << hex << DPtoAL_data.alu_op1 << "(hex) = "
                     << dec << DPtoAL_data.alu_op1 << "(dec), OP2 = 0x" << hex << DPtoAL_data.alu_op2
                     << "(hex) = " << dec << DPtoAL_data.alu_op2 << "(dec)" << endl;
                cout << "S3: @AL: Output = 0x" << hex << ALU(DPtoAL_data) << "(hex) = "
                     << dec << ALU(DPtoAL_data) << "(dec)" << endl;
            }
#endif

            nextsection = ME_setDMsignals;
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == ME_setDMsignals) {

            if (CPtoDP_data.dmem_req_s4 == ME_RD) {

                DPtoCP_data.req = CPtoDP_data.dmem_req_s4;
                DPtoCP_data.mask = CPtoDP_data.dmem_mask_s4;
                DPtoCP_data.addrIn = DP_S4_data.alu_result_s4;
                DPtoCP_data.dataIn = 0;

            } else if (CPtoDP_data.dmem_req_s4 == ME_WR) {

                DPtoCP_data.req = CPtoDP_data.dmem_req_s4;
                DPtoCP_data.mask = CPtoDP_data.dmem_mask_s4;
                DPtoCP_data.addrIn = DP_S4_data.alu_result_s4;

                if (DP_S4_data.reg_rs2_addr_s4 == DP_S5_data.reg_rd_addr_s5 && DP_S4_data.reg_rs2_addr_s4 != 0 && DP_S5_data.enc_type_s5 == ENC_I_L) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  MEM_2 || FORWARDING_NUM: (17*)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~~~WB~~~||>>~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||~>>ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoCP_data.dataIn = CPtoDP_data.loadedData_s5;

#ifdef LOGTOFILE
                    cout << "S4: @DP: .~.~.~FORWARDING TYPE: MEM_2~.~.~.  "
                         << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   " << stringInstrType(DP_S4_data.inst_type_s4)
                         << "    MEM's content in stage_5: " << hex << CPtoDP_data.loadedData_s5
                         << " FORWARDED TO MEM's dataIn-content" << endl;
#endif

                } else if (DP_S4_data.reg_rs2_addr_s4 == DP_S5_data.reg_rd_addr_s5 && DP_S4_data.reg_rs2_addr_s4 != 0) {
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|  MEM_1 || FORWARDING_NUM: (5 | 11)
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    //|~~~IF~~~||~~~ID~~~||~~~EX~~~||~~~ME~~~||>>~WB~~~|
                    //|         |~~~IF~~~||~~~ID~~~||~~~EX~~~||~>>ME~~~||~~~WB~~~|
                    ////////////////////////////////////////////////////////////////////////////////////////////
                    DPtoCP_data.dataIn = DP_S5_data.alu_result_s5;

#ifdef LOGTOFILE
                    cout << "S4: @DP: .~.~.~FORWARDING TYPE: MEM_1~.~.~.  "
                         << stringInstrType(DP_S5_data.inst_type_s5) << "   ~~>   " << stringInstrType(DP_S4_data.inst_type_s4)
                         << "    AL's content in stage_5: " << hex << DP_S5_data.alu_result_s5
                         << " FORWARDED TO MEM's dataIn-content" << endl;
#endif

                } else if (DP_S4_data.prev_memory_access) {
                    DPtoCP_data.dataIn = DP_S4_data.prev_loadedData;

                } else { //Normal case: No Forwarding needed
                    DPtoCP_data.dataIn = DP_S4_data.reg2_content_s4;
                }

            } else {

                DPtoCP_data.req = ME_X;
                DPtoCP_data.mask = MT_X;
                DPtoCP_data.addrIn = 0;
                DPtoCP_data.dataIn = 0;
            }


            if (CPtoDP_data.prev_memory_access && DP_S3_data.enc_type_s3 == ENC_S && DP_S5_data.enc_type_s5 == ENC_I_L && DP_S3_data.reg_rs2_addr_s3 == DP_S5_data.reg_rd_addr_s5 && DP_S5_data.reg_rd_addr_s5 != 0) {
                DP_S4_data.prev_memory_access = true;
                DP_S4_data.prev_loadedData = CPtoDP_data.loadedData_s5;
            } else if (DP_S4_data.prev_memory_access && CPtoDP_data.stall_dmem_access_s4) {
                DP_S4_data.prev_memory_access = true;
            } else {
                DP_S4_data.prev_memory_access = false;
            }

            if (!CPtoDP_data.stall_dmem_access_s4) {
                nextsection = DP_setPipelineSignals;
            } else {
                nextsection = ID_writeCP_readCP;
            }
        }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (section == DP_setPipelineSignals) {

            DP_S5_data.pc_s5 = DP_S4_data.pc_s4;

            DP_S5_data.enc_type_s5 = DP_S4_data.enc_type_s4;
            DP_S5_data.inst_type_s5 = DP_S4_data.inst_type_s4;

            DP_S5_data.reg_rd_addr_s5 = DP_S4_data.reg_rd_addr_s4;

            DP_S5_data.alu_result_s5 = DP_S4_data.alu_result_s4;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            DP_S4_data.pc_s4 = DP_S3_data.pc_s3;

            DP_S4_data.enc_type_s4 = DP_S3_data.enc_type_s3;
            DP_S4_data.inst_type_s4 = DP_S3_data.inst_type_s3;

            DP_S4_data.reg_rs2_addr_s4 = DP_S3_data.reg_rs2_addr_s3;
            DP_S4_data.reg_rd_addr_s4 = DP_S3_data.reg_rd_addr_s3;

            DP_S4_data.reg2_content_s4 = DP_S3_data.reg2_content_s3;

            DP_S4_data.alu_result_s4 = ALU(DPtoAL_data);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            DP_S3_data.pc_s3 = CPtoDP_data.pc_s2;

            //if (!CPtoDP_data.flush_branch) {
                DP_S3_data.enc_type_s3 = CPtoDP_data.enc_type_s2;
                DP_S3_data.inst_type_s3 = CPtoDP_data.inst_type_s2;

                DP_S3_data.reg_rs1_addr_s3 = CPtoDP_data.reg_rs1_addr_s2;
                DP_S3_data.reg_rs2_addr_s3 = CPtoDP_data.reg_rs2_addr_s2;
                DP_S3_data.reg_rd_addr_s3 = CPtoDP_data.reg_rd_addr_s2;
           /* } else {
                DP_S3_data.enc_type_s3 = ENC_I_I;
                DP_S3_data.inst_type_s3 = InstrType::INSTR_ADDI;

                DP_S3_data.reg_rs1_addr_s3 = 0;
                DP_S3_data.reg_rs2_addr_s3 = 0;
                DP_S3_data.reg_rd_addr_s3 = 0;
            }*/

            DP_S3_data.reg1_content_s3 = reg1_content;
            DP_S3_data.reg2_content_s3 = reg2_content;

            nextsection = ID_writeCP_readCP;
        }

        section = nextsection;
    }
}


unsigned int Data_path::ALU(DPtoAL_IF DPtoAL_data) const {

    // perform ALU operations
    if (DPtoAL_data.alu_fun == ALU_ADD) {
        return DPtoAL_data.alu_op1 + DPtoAL_data.alu_op2;
    } else if (DPtoAL_data.alu_fun == ALU_SUB) {
        return DPtoAL_data.alu_op1 + (-DPtoAL_data.alu_op2);
    } else if (DPtoAL_data.alu_fun == ALU_AND) {
        return DPtoAL_data.alu_op1 & DPtoAL_data.alu_op2;
    } else if (DPtoAL_data.alu_fun == ALU_OR) {
        return DPtoAL_data.alu_op1 | DPtoAL_data.alu_op2;
    } else if (DPtoAL_data.alu_fun == ALU_XOR) {
        return DPtoAL_data.alu_op1 ^ DPtoAL_data.alu_op2;
    } else if (DPtoAL_data.alu_fun == ALU_SLT) {
        if (static_cast<int>(DPtoAL_data.alu_op1) < static_cast<int>(DPtoAL_data.alu_op2)) {
            return 1;
        } else {
            return 0;
        }
    } else if (DPtoAL_data.alu_fun == ALU_SLTU) {
        if (DPtoAL_data.alu_op1 < DPtoAL_data.alu_op2) {
            return 1;
        } else {
            return 0;
        }
    } else if (DPtoAL_data.alu_fun == ALU_SLL) {
        // shamt in alu_op2 (imm)! Arithmetic and logical the same: no problem
        return DPtoAL_data.alu_op1 << ((DPtoAL_data.alu_op2) & 0x1F);
    } else if (DPtoAL_data.alu_fun == ALU_SRA) {
        // shamt in alu_op2 (imm)!
        return static_cast<unsigned int>(static_cast<int>(DPtoAL_data.alu_op1) >> static_cast<int>(DPtoAL_data.alu_op2 & 0x1F));
    } else if (DPtoAL_data.alu_fun == ALU_SRL) {
        // shamt in alu_op2 (imm)!
        return DPtoAL_data.alu_op1 >> ((DPtoAL_data.alu_op2) & 0x1F);
    } else if (DPtoAL_data.alu_fun == ALU_COPY1) {
        return DPtoAL_data.alu_op1;
    } else {
        return 0;
    }
}


unsigned int Data_path::RF(RF_RD_AccessType rdReq, unsigned int src, RFtoDP_IF RFtoDP_data) const {

    if (rdReq == RF_RD) {

        if (src == 0) {
            return 0;
        } else if (src == 1) {
            return RFtoDP_data.reg_file_01;
        } else if (src == 2) {
            return RFtoDP_data.reg_file_02;
        } else if (src == 3) {
            return RFtoDP_data.reg_file_03;
        } else if (src == 4) {
            return RFtoDP_data.reg_file_04;
        } else if (src == 5) {
            return RFtoDP_data.reg_file_05;
        } else if (src == 6) {
            return RFtoDP_data.reg_file_06;
        } else if (src == 7) {
            return RFtoDP_data.reg_file_07;
        } else if (src == 8) {
            return RFtoDP_data.reg_file_08;
        } else if (src == 9) {
            return RFtoDP_data.reg_file_09;
        } else if (src == 10) {
            return RFtoDP_data.reg_file_10;
        } else if (src == 11) {
            return RFtoDP_data.reg_file_11;
        } else if (src == 12) {
            return RFtoDP_data.reg_file_12;
        } else if (src == 13) {
            return RFtoDP_data.reg_file_13;
        } else if (src == 14) {
            return RFtoDP_data.reg_file_14;
        } else if (src == 15) {
            return RFtoDP_data.reg_file_15;
        } else if (src == 16) {
            return RFtoDP_data.reg_file_16;
        } else if (src == 17) {
            return RFtoDP_data.reg_file_17;
        } else if (src == 18) {
            return RFtoDP_data.reg_file_18;
        } else if (src == 19) {
            return RFtoDP_data.reg_file_19;
        } else if (src == 20) {
            return RFtoDP_data.reg_file_20;
        } else if (src == 21) {
            return RFtoDP_data.reg_file_21;
        } else if (src == 22) {
            return RFtoDP_data.reg_file_22;
        } else if (src == 23) {
            return RFtoDP_data.reg_file_23;
        } else if (src == 24) {
            return RFtoDP_data.reg_file_24;
        } else if (src == 25) {
            return RFtoDP_data.reg_file_25;
        } else if (src == 26) {
            return RFtoDP_data.reg_file_26;
        } else if (src == 27) {
            return RFtoDP_data.reg_file_27;
        } else if (src == 28) {
            return RFtoDP_data.reg_file_28;
        } else if (src == 29) {
            return RFtoDP_data.reg_file_29;
        } else if (src == 30) {
            return RFtoDP_data.reg_file_30;
        } else { //(DPtoRF_data.src1 == 31)
            return RFtoDP_data.reg_file_31;
        }

    } else {
        return 0;
    }
}

#endif //PROJECT_DATA_PATH_H